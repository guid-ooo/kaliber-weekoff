import AppKit

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
    private var statusItem: NSStatusItem!
    private var timer: Timer?
    private var menuIsOpen = false
    private var tick = 0

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
        midi.onNote = { [weak self] note in self?.handle(note) }
        midi.start()
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
            if self.selectedID == nil, let first = fresh.first {
                self.selectedID = first.id
                return
            }
            if changed { self.refreshMenu() }
        }
    }

    private func poll() {
        tick += 1
        if tick % 8 == 0, !menuIsOpen { loadDocuments() }
        if tick % 8 == 0, configStamp != ConfigStore.modified { loadConfig() }

        guard Keynote.isRunning else {
            statusLine = "Keynote draait niet"
            state = nil
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
                    break
                }
                self.statusLine = slide.skipped ? "dia \(slide.slide) (overgeslagen)" : "dia \(slide.slide)"
                self.state = slide
                self.handle(slide)
            }
            self.updateTitle()
        }
    }

    private func loadConfig() {
        configStamp = ConfigStore.modified
        switch ConfigStore.loadOrCreate() {
        case .success(let loaded):
            config = loaded
            lights.configure(loaded.artnet)
            configLine = "\(loaded.scenes.count) scenes, \(loaded.artnet.host)"
        case .failure(let error):
            config = nil
            configLine = "scenes.json fout: \(error.localizedDescription)"
        }
        refreshMenu()
    }

    private func handle(_ slide: SlideState) {
        guard !slide.skipped else { return }
        guard slide.tags != lastTags else { return }
        lastTags = slide.tags
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

        case ("GET", "/api/config"):
            guard let config, let data = try? encoder.encode(config) else { return .notFound }
            return .json(data)

        case ("PUT", "/api/config"):
            guard let incoming = try? JSONDecoder().decode(ShowConfig.self, from: request.body) else {
                return WebResponse(status: "400 Bad Request", type: "text/plain", body: Data("ongeldige json".utf8))
            }
            try? ConfigStore.save(incoming)
            loadConfig()
            return .json(Data("{\"ok\":true}".utf8))

        case ("GET", "/api/state"):
            return .json(stateJSON(encoder))

        case ("POST", "/api/preview"):
            guard let body = try? JSONDecoder().decode([String: String].self, from: request.body),
                  let tag = body["tag"] else { return .notFound }
            lastTags = nil
            applyLights([tag])
            return .json(Data("{\"ok\":true,\"artnet\":\(backend.usesArtNet)}".utf8))

        case ("POST", "/api/backend"):
            guard let body = try? JSONDecoder().decode([String: String].self, from: request.body),
                  let raw = body["backend"], let option = Backend(rawValue: raw) else { return .notFound }
            backend = option
            return .json(Data("{\"ok\":true}".utf8))

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
        guard let config, let pad = config.pad(channel: note.channel, note: note.note) else { return }
        let key = "\(note.channel):\(note.note)"

        if note.isOn {
            if let sample = pad.sample { audio.play(sample, velocity: note.velocity) }
            if let dmx = pad.dmx {
                heldPads[key] = config.levels(dmx)
                pushOverlay()
            }
            padLine = "pad \(note.note) (vel \(note.velocity))"
        } else if pad.hold ?? false, heldPads.removeValue(forKey: key) != nil {
            pushOverlay()
            padLine = "pad \(note.note) los"
        }
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
        if let sound = config.audio(for: tags) {
            audio.playScene(sound.path, fade: sound.fade)
        }
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
