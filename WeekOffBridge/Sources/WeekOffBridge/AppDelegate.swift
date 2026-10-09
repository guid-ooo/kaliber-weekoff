import AppKit
import UniformTypeIdentifiers

enum Backend: String, CaseIterable {
    case qlab, artnet, both
    var label: String {
        switch self {
        case .qlab: return "QLab"
        case .artnet: return "Art-Net"
        case .both: return "Allebei"
        }
    }
    var usesQLab: Bool { self != .artnet }
    var usesArtNet: Bool { self != .qlab }
}

final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private let runner = ScriptRunner()
    private let lights = LightEngine()
    private let audio = SamplePlayer()
    private let midi = MIDIListener()
    private let web = WebServer(port: 8733)
    private let overlay = EmojiOverlay()
    private var statusItem: NSStatusItem!
    private var timer: Timer?
    private var menuIsOpen = false
    private var tick = 0
    private var deck: [(tag: String, slide: Int, skipped: Bool)] = []
    private var blacked = false
    private var tagsByPlaybackSlide: [Int: [String]] = [:]
    private var deckName = ""
    private var origins: [String: [String]] = [:]

    private var documents: [KeynoteDocument] = []
    private var selectedID: String? {
        didSet {
            UserDefaults.standard.set(selectedID, forKey: "selectedDocumentID")
            lastTags = nil
            state = nil
            refreshMenu()
        }
    }

    private var state: SlideState?
    private var lastTags: [String]?
    private var statusLine = "Niet verbonden"
    private var lastFired = "nog niets"
    private var config: ShowConfig?
    private var configLine = "scenes.json niet geladen"
    private var configStamp: Date?
    private var heldPads: [String: [Int: Double]] = [:]
    private var toggled: Set<String> = []
    private var lastNote: (note: UInt8, channel: UInt8, at: Date)?
    private var padLine = "geen pad"
    private var backend: Backend = .qlab {
        didSet {
            UserDefaults.standard.set(backend.rawValue, forKey: "backend")
            backend.usesArtNet ? lights.start() : lights.stop()
            refreshMenu()
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        selectedID = UserDefaults.standard.string(forKey: "selectedDocumentID")
        backend = Backend(rawValue: UserDefaults.standard.string(forKey: "backend") ?? "") ?? .qlab
        loadConfig()
        audio.start()
        origins = OriginStore.load()
        midi.onNote = { [weak self] note in self?.handle(note) }
        midi.start()
        loadDeck()
        web.handler = { [weak self] request in
            guard let self else { return .notFound }
            return DispatchQueue.main.sync { self.route(request) }
        }
        web.start()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "◇"
        refreshMenu()

        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.poll()
        }
        timer?.tolerance = 0.05
    }

    func menuWillOpen(_ menu: NSMenu) {
        menuIsOpen = true
        loadDocuments()
    }

    func menuDidClose(_ menu: NSMenu) {
        menuIsOpen = false
    }

    private func loadDocuments() {
        guard Keynote.isRunning else {
            if !documents.isEmpty {
                documents = []
                refreshMenu()
            }
            return
        }
        runner.run(Keynote.documentsScript) { [weak self] result in
            guard let self else { return }
            guard case .success(let raw) = result else { return }
            let fresh = Keynote.parseDocuments(raw)
            let changed = fresh != self.documents
            self.documents = fresh
            let weg = self.selectedID.map { id in !fresh.contains { $0.id == id } } ?? true
            if weg, let volgende = fresh.first(where: { $0.name == self.deckName }) ?? fresh.first {
                self.selectedID = volgende.id
                self.deckName = volgende.name
                self.loadDeck()
                return
            }
            if changed { self.refreshMenu() }
        }
    }

    private func poll() {
        tick += 1
        if tick % 8 == 0, !menuIsOpen { loadDocuments() }
        if tick % 8 == 0, configStamp != ConfigStore.modified { loadConfig() }
        if tick % 40 == 1 { loadDeck() }

        guard Keynote.isRunning else {
            statusLine = "Keynote draait niet"
            state = nil
            blackout(reason: "Keynote is afgesloten")
            updateTitle()
            return
        }
        guard let id = selectedID else {
            statusLine = "Geen presentatie gekozen"
            updateTitle()
            return
        }

        runner.run(Keynote.pollScript(documentID: id)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.statusLine = error.localizedDescription
            case .success(let raw):
                guard let slide = Keynote.parseSlide(raw) else {
                    self.statusLine = raw == "GONE" ? "Presentatie is gesloten" : "Geen dia"
                    self.state = nil
                    self.blackout(reason: self.statusLine)
                    break
                }
                let effectief = self.effectiveTags(for: slide)
                self.statusLine = slide.skipped ? "dia \(slide.slide) (overgeslagen)" : "dia \(slide.slide)"
                self.state = SlideState(slide: slide.slide, skipped: slide.skipped, tags: effectief)
                self.handle(SlideState(slide: slide.slide, skipped: slide.skipped, tags: effectief))
            }
            self.updateTitle()
        }
    }

    private func loadDeck() {
        guard Keynote.isRunning, let id = selectedID else { deck = []; return }
        runner.run(Keynote.nameScript(documentID: id)) { [weak self] result in
            if case .success(let naam) = result { self?.deckName = naam.trimmingCharacters(in: .whitespacesAndNewlines) }
        }
        runner.run(Keynote.indexScript(documentID: id)) { [weak self] result in
            guard let self, case .success(let raw) = result else { return }
            var seen: [String: (Int, Bool)] = [:]
            var order: [String] = []
            var byPlayback: [Int: [String]] = [:]
            var playback = 0
            for entry in Keynote.parseIndex(raw) {
                if !entry.skipped {
                    playback += 1
                    if !entry.tags.isEmpty { byPlayback[playback] = entry.tags }
                }
                for tag in entry.tags where seen[tag] == nil {
                    seen[tag] = (entry.slide, entry.skipped)
                    order.append(tag)
                }
            }
            self.tagsByPlaybackSlide = byPlayback
            if !self.deckName.isEmpty {
                OriginStore.remember(deck: self.deckName, tags: order)
                self.origins = OriginStore.load()
            }
            self.deck = order.compactMap { tag in
                seen[tag].map { (tag: tag, slide: $0.0, skipped: $0.1) }
            }
        }
    }

    private func loadConfig() {
        configStamp = ConfigStore.modified
        switch ConfigStore.loadOrCreate() {
        case .success(let loaded):
            config = loaded
            lights.configure(loaded.artnet)
            NotoEmoji.warmOp(NotoEmoji.favorieten + (loaded.pads?.values.compactMap(\.emoji) ?? []))
            for pad in loaded.pads?.values ?? [:].values {
                if let sample = pad.sample { audio.preload(sample) }
            }
            configLine = "\(loaded.scenes.count) scenes, \(loaded.artnet.host)"
        case .failure(let error):
            config = nil
            configLine = "scenes.json fout: \(error.localizedDescription)"
        }
        refreshMenu()
    }

    private func inheritedTags(before slide: Int) -> [String] {
        tagsByPlaybackSlide.keys.filter { $0 <= slide }.max().flatMap { tagsByPlaybackSlide[$0] } ?? []
    }

    private func effectiveTags(for slide: SlideState) -> [String] {
        guard !slide.skipped else { return slide.tags }
        return slide.tags.isEmpty ? inheritedTags(before: slide.slide) : slide.tags
    }

    private func handle(_ slide: SlideState) {
        guard !slide.skipped, !slide.tags.isEmpty else { return }
        guard slide.tags != lastTags else { return }
        lastTags = slide.tags
        blacked = false
        guard !slide.tags.isEmpty else { return }

        let tags = slide.tags
        if backend.usesArtNet { applyLights(tags) }
        guard backend.usesQLab else { return }
        runner.run(QLab.startScript(tags: tags)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.lastFired = "QLab: \(error.localizedDescription)"
            case .success(let misses):
                let missing = misses.split(separator: " ").map(String.init)
                let fired = tags.filter { !missing.contains($0) }
                if misses == "NO_WORKSPACE" {
                    self.lastFired = "QLab heeft geen workspace open"
                } else if missing.isEmpty {
                    self.lastFired = fired.joined(separator: ", ")
                } else {
                    self.lastFired = "\(fired.joined(separator: ", ")) — onbekend: \(missing.joined(separator: ", "))"
                }
            }
            self.refreshMenu()
        }
    }

    private func route(_ request: WebRequest) -> WebResponse {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        switch (request.method, request.path) {
        case ("GET", "/"):
            return .html(Page.html)

        case ("GET", let path) where path.hasPrefix("/fonts/"):
            let name = String(path.dropFirst("/fonts/".count))
            guard !name.contains(".."),
                  let url = Bundle.main.url(forResource: "fonts/" + (name as NSString).deletingPathExtension, withExtension: "woff2"),
                  let data = try? Data(contentsOf: url) else { return .notFound }
            return WebResponse(status: "200 OK", type: "font/woff2", body: data)

        case ("GET", "/api/config"):
            guard let config, let data = try? encoder.encode(config) else { return .notFound }
            return .json(data)

        case ("POST", "/api/config"), ("PUT", "/api/config"):
            guard let incoming = try? JSONDecoder().decode(ShowConfig.self, from: request.body) else {
                return WebResponse(status: "400 Bad Request", type: "text/plain", body: Data("ongeldige json".utf8))
            }
            try? ConfigStore.save(incoming)
            loadConfig()
            return .json(Data("{\"ok\":true}".utf8))

        case ("GET", "/api/learn"):
            guard let last = lastNote, Date().timeIntervalSince(last.at) < 5 else {
                return .json(Data("{\"note\":null}".utf8))
            }
            return .json(Data("{\"note\":\(last.note),\"channel\":\(last.channel)}".utf8))

        case ("POST", "/api/pad"):
            guard let body = try? JSONDecoder().decode([String: String].self, from: request.body),
                  let key = body["pad"], let config, let pad = config.pads?[key] else { return .notFound }
            if let sample = pad.sample { audio.play(sample, level: pad.volume ?? 100) }
            if let emoji = pad.emoji { overlay.toon(emoji) }
            return .json(Data("{\"ok\":true}".utf8))

        case ("GET", "/api/state"):
            return .json(stateJSON(encoder))

        case ("POST", "/api/preview"):
            guard let body = try? JSONDecoder().decode([String: String].self, from: request.body),
                  let tag = body["tag"] else { return .notFound }
            lastTags = nil
            applyLights([tag])
            return .json(Data("{\"ok\":true,\"artnet\":\(backend.usesArtNet)}".utf8))

        case ("POST", "/api/kies-geluid"):
            guard let body = try? JSONDecoder().decode([String: String].self, from: request.body),
                  let key = body["pad"] else { return .notFound }
            kiesGeluid(voor: key)
            return .json(Data("{\"ok\":true}".utf8))

        case ("POST", "/api/panic"):
            blacked = false
            blackout(reason: "handmatig")
            return .json(Data("{\"ok\":true}".utf8))

        case ("POST", "/api/backend"):
            guard let body = try? JSONDecoder().decode([String: String].self, from: request.body),
                  let raw = body["backend"], let option = Backend(rawValue: raw) else { return .notFound }
            backend = option
            return .json(Data("{\"ok\":true}".utf8))

        case ("GET", let path) where !path.hasPrefix("/api/"):
            return .html(Page.html)

        default:
            return .notFound
        }
    }

    private func stateJSON(_ encoder: JSONEncoder) -> Data {
        var channels: [[String: Any]] = []
        if let config {
            let values = lights.snapshot()
            for (name, fixture) in config.fixtures.sorted(by: { $0.key < $1.key }) {
                for (index, channel) in fixture.channels.enumerated() {
                    let dmx = fixture.address + index
                    guard (1...512).contains(dmx) else { continue }
                    channels.append(["name": "\(name).\(channel)", "value": Int(values[dmx - 1].rounded())])
                }
            }
        }
        var payload: [String: Any] = [
            "lastNote": lastNote.map { ["note": Int($0.note), "channel": Int($0.channel), "age": Date().timeIntervalSince($0.at)] } as Any,
            "held": Array(heldPads.keys),
            "artnetActive": lights.isRunning,
            "blackout": blacked,
            "deck": deck.map { ["tag": $0.tag, "slide": $0.slide, "skipped": $0.skipped] },
            "deckName": deckName,
            "origins": origins.filter { $0.key != deckName },
            "slide": state?.slide as Any,
            "tags": state?.tags ?? [],
            "midi": midi.sourceCount,
            "backend": backend.rawValue,
            "channels": channels,
        ]
        if let config, let data = try? encoder.encode(config),
           let object = try? JSONSerialization.jsonObject(with: data) {
            payload["config"] = object
        }
        return (try? JSONSerialization.data(withJSONObject: payload)) ?? Data("{}".utf8)
    }

    private func handle(_ note: MIDINote) {
        if note.isOn { lastNote = (note.note, note.channel, Date()) }
        guard let config, let pad = config.pad(channel: note.channel, note: note.note) else {
            if note.isOn { padLine = "pad \(note.note) (niet gekoppeld)" ; refreshMenu() }
            return
        }
        let key = "\(note.channel):\(note.note)"

        if note.isOn {
            if let sample = pad.sample { audio.play(sample, velocity: note.velocity, level: pad.volume ?? 100) }
            if let emoji = pad.emoji { overlay.toon(emoji) }
            if let dmx = pad.dmx {
                if pad.isToggle {
                    if toggled.contains(key) {
                        toggled.remove(key)
                        heldPads[key] = nil
                    } else {
                        toggled.insert(key)
                        heldPads[key] = config.levels(dmx)
                    }
                } else {
                    heldPads[key] = config.levels(dmx)
                }
                pushOverlay()
            }
            padLine = "pad \(note.note) (vel \(note.velocity))"
        } else if pad.isHold, heldPads.removeValue(forKey: key) != nil {
            pushOverlay()
            padLine = "pad \(note.note) los"
        }
        refreshMenu()
    }

    private func kiesGeluid(voor key: String) {
        NSApp.activate(ignoringOtherApps: true)
        let panel = NSOpenPanel()
        panel.title = "Kies een geluid"
        panel.prompt = "Kiezen"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.audio]
        panel.begin { [weak self] response in
            guard let self, response == .OK, let url = panel.url, var config = self.config else { return }
            var pad = config.pads?[key] ?? Pad()
            pad.sample = url.path
            pad.dmx = [:]
            if pad.label == nil || pad.label == "Nieuw" {
                pad.label = url.deletingPathExtension().lastPathComponent
            }
            config.pads?[key] = pad
            if config.pads == nil { config.pads = [key: pad] }
            try? ConfigStore.save(config)
            self.loadConfig()
            self.audio.preload(url.path)
        }
    }

    private func blackout(reason: String) {
        guard !blacked else { return }
        blacked = true
        lastTags = state?.tags ?? []
        heldPads.removeAll()
        toggled.removeAll()
        lights.setOverlay([:])
        lights.apply(levels: [:], fade: 1)
        lastFired = "alles uit (\(reason))"
        refreshMenu()
    }

    private func pushOverlay() {
        var merged: [Int: Double] = [:]
        for levels in heldPads.values {
            for (channel, value) in levels { merged[channel] = max(merged[channel] ?? 0, value) }
        }
        lights.setOverlay(merged)
    }

    private func applyLights(_ tags: [String]) {
        guard let config else { return }
        guard let result = config.levels(for: tags) else { return }
        guard !result.levels.isEmpty || result.unknown.count < tags.count else { return }
        lights.apply(levels: result.levels, fade: result.fade)
    }

    private func updateTitle() {
        guard let button = statusItem.button else { return }
        if let state, !state.skipped {
            button.title = state.tags.isEmpty ? "◇ \(state.slide)" : "◆ \(state.slide)"
        } else {
            button.title = "◇"
        }
    }

    private func refreshMenu() {
        guard statusItem != nil else { return }
        let menu: NSMenu
        if menuIsOpen, let existing = statusItem.menu {
            menu = existing
            menu.removeAllItems()
        } else {
            menu = NSMenu()
            menu.delegate = self
        }

        menu.addItem(header("Presentatie"))
        if documents.isEmpty {
            menu.addItem(disabled(Keynote.isRunning ? "Geen presentatie open" : "Keynote draait niet"))
        } else {
            for doc in documents {
                let item = NSMenuItem(title: doc.name, action: #selector(selectDocument(_:)), keyEquivalent: "")
                item.target = self
                item.representedObject = doc.id
                item.state = doc.id == selectedID ? .on : .off
                menu.addItem(item)
            }
        }

        menu.addItem(.separator())
        menu.addItem(header("Uitvoer"))
        for option in Backend.allCases {
            let item = NSMenuItem(title: option.label, action: #selector(selectBackend(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = option.rawValue
            item.state = option == backend ? .on : .off
            menu.addItem(item)
        }
        menu.addItem(disabled(configLine))
        let edit = NSMenuItem(title: "scenes.json openen", action: #selector(openConfig), keyEquivalent: "")
        edit.target = self
        menu.addItem(edit)
        let ui = NSMenuItem(title: "Bedieningspaneel openen", action: #selector(openWebUI), keyEquivalent: "")
        ui.target = self
        menu.addItem(ui)

        menu.addItem(.separator())
        menu.addItem(header("Status"))
        menu.addItem(disabled(statusLine))
        menu.addItem(disabled("laatste cue: \(lastFired)"))
        menu.addItem(disabled("MIDI: \(midi.sourceCount) bron(nen), \(padLine)"))
        if let state, !state.tags.isEmpty {
            menu.addItem(disabled("scene: \(state.tags.joined(separator: ", "))"))
        }

        menu.addItem(.separator())
        let quit = NSMenuItem(title: "Stoppen", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quit)

        if menu !== statusItem.menu { statusItem.menu = menu }
    }

    private func header(_ title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.attributedTitle = NSAttributedString(
            string: title,
            attributes: [.font: NSFont.boldSystemFont(ofSize: NSFont.smallSystemFontSize)]
        )
        item.isEnabled = false
        return item
    }

    private func disabled(_ title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    @objc private func selectDocument(_ sender: NSMenuItem) {
        selectedID = sender.representedObject as? String
    }

    @objc private func selectBackend(_ sender: NSMenuItem) {
        guard let raw = sender.representedObject as? String, let option = Backend(rawValue: raw) else { return }
        backend = option
    }

    @objc private func openWebUI() {
        guard let url = URL(string: "http://127.0.0.1:\(web.port)/") else { return }
        NSWorkspace.shared.open(url)
    }

    @objc private func openConfig() {
        NSWorkspace.shared.open(ConfigStore.url)
    }
}
