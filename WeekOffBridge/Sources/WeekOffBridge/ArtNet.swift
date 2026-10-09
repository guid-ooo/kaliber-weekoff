import Darwin
import Foundation

final class ArtNetSender {
    private var fd: Int32 = -1
    private var target = sockaddr_in()
    private var sequence: UInt8 = 1
    let universe: Int

    init?(host: String, universe: Int, broadcast: Bool, port: UInt16 = 6454) {
        self.universe = universe
        fd = socket(AF_INET, SOCK_DGRAM, 0)
        guard fd >= 0 else { return nil }
        if broadcast {
            var on: Int32 = 1
            setsockopt(fd, SOL_SOCKET, SO_BROADCAST, &on, socklen_t(MemoryLayout<Int32>.size))
        }
        target.sin_family = sa_family_t(AF_INET)
        target.sin_port = port.bigEndian
        guard let adres = Self.adres(voor: host) else {
            close(fd)
            return nil
        }
        target.sin_addr = adres
    }

    /// Accepteert zowel 10.11.46.11 als artnet.local; inet_pton kan alleen het eerste.
    private static func adres(voor host: String) -> in_addr? {
        var numeriek = in_addr()
        if inet_pton(AF_INET, host, &numeriek) == 1 { return numeriek }
        var hints = addrinfo()
        hints.ai_family = AF_INET
        hints.ai_socktype = SOCK_DGRAM
        var info: UnsafeMutablePointer<addrinfo>?
        guard getaddrinfo(host, nil, &hints, &info) == 0, let eerste = info else { return nil }
        defer { freeaddrinfo(info) }
        guard let sa = eerste.pointee.ai_addr else { return nil }
        return sa.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { $0.pointee.sin_addr }
    }

    deinit {
        if fd >= 0 { close(fd) }
    }

    func send(_ data: [UInt8]) {
        var packet = Array("Art-Net".utf8) + [0]
        packet += [0x00, 0x50]
        packet += [0x00, 14]
        packet += [sequence, 0]
        packet += [UInt8(universe & 0xFF), UInt8((universe >> 8) & 0x7F)]
        packet += [UInt8((data.count >> 8) & 0xFF), UInt8(data.count & 0xFF)]
        packet += data
        sequence = sequence == 255 ? 1 : sequence + 1

        withUnsafePointer(to: &target) { pointer in
            pointer.withMemoryRebound(to: sockaddr.self, capacity: 1) { addr in
                _ = packet.withUnsafeBytes { bytes in
                    sendto(fd, bytes.baseAddress, bytes.count, 0, addr, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }
        }
    }
}

final class LightEngine {
    private let queue = DispatchQueue(label: "nl.kaliber.weekoffbridge.artnet")
    private var timer: DispatchSourceTimer?
    private var sender: ArtNetSender?

    private var from = [Double](repeating: 0, count: 512)
    private var to = [Double](repeating: 0, count: 512)
    private var fadeStart = Date.distantPast
    private var fadeDuration: Double = 0
    private var overlay: [Int: Double] = [:]
    private var effecten: [(rood: Int, groen: Int, blauw: Int, niveau: Double)] = []
    private var gestart = Date()
    var bpm: Double = 120

    private(set) var isRunning = false
    /// False als het adres niet te bereiken was; dan gaat er niets de deur uit.
    private(set) var uitvoerKlaar = false

    func configure(_ config: ArtNetConfig) {
        // Opzoeken kan blokkeren bij een hostnaam, dus niet op de uitvoerwachtrij.
        DispatchQueue.global(qos: .utility).async {
            let nieuwe = ArtNetSender(host: config.host, universe: config.universe, broadcast: config.broadcast)
            self.queue.async { self.sender = nieuwe }
            DispatchQueue.main.async { self.uitvoerKlaar = nieuwe != nil }
        }
    }

    func start() {
        guard timer == nil else { return }
        let source = DispatchSource.makeTimerSource(queue: queue)
        source.schedule(deadline: .now(), repeating: .milliseconds(25))
        source.setEventHandler { [weak self] in self?.frame() }
        source.resume()
        timer = source
        isRunning = true
    }

    func stop() {
        timer?.cancel()
        timer = nil
        isRunning = false
    }

    func apply(levels: [Int: Double], fade: Double, effecten: [(rood: Int, groen: Int, blauw: Int, niveau: Double)] = []) {
        queue.async {
            self.effecten = effecten
            self.gestart = Date()
            self.from = self.currentLevels()
            var next = [Double](repeating: 0, count: 512)
            for (channel, value) in levels where (1...512).contains(channel) {
                next[channel - 1] = value
            }
            self.to = next
            self.fadeDuration = max(fade, 0)
            self.fadeStart = Date()
        }
    }

    private func currentLevels() -> [Double] {
        let progress = fadeDuration <= 0 ? 1 : min(Date().timeIntervalSince(fadeStart) / fadeDuration, 1)
        guard progress < 1 else { return to }
        return zip(from, to).map { $0 + ($1 - $0) * progress }
    }

    func snapshot() -> [Double] {
        queue.sync { samenstellen() }
    }

    private func samenstellen() -> [Double] {
        var values = currentLevels()

        if !effecten.isEmpty {
            let perTel = 60.0 / bpm
            let tellen = Date().timeIntervalSince(gestart) / perTel
            let tel = Int(floor(tellen))
            let fase = tellen - floor(tellen)
            let maatslag = ((tel % 4) + 4) % 4

            let aanzet = maatslag == 0 ? 1.0 : 0.72
            let envelop = aanzet * (0.18 + 0.82 * pow(1 - fase, 1.6))
            let (r, g, b) = Self.hueNaarRGB(Double(tel) * 57)

            for effect in effecten {
                for (kanaal, deel) in [(effect.rood, r), (effect.groen, g), (effect.blauw, b)]
                where (1...512).contains(kanaal) {
                    values[kanaal - 1] = deel * effect.niveau * envelop
                }
            }
        }
        for (channel, value) in overlay where (1...512).contains(channel) {
            values[channel - 1] = value
        }
        return values
    }

    func setOverlay(_ levels: [Int: Double]) {
        queue.async { self.overlay = levels }
    }

    private static func hueNaarRGB(_ hoek: Double) -> (Double, Double, Double) {
        let h = hoek.truncatingRemainder(dividingBy: 360) / 60
        let x = 1 - abs(h.truncatingRemainder(dividingBy: 2) - 1)
        switch Int(h) {
        case 0: return (1, x, 0)
        case 1: return (x, 1, 0)
        case 2: return (0, 1, x)
        case 3: return (0, x, 1)
        case 4: return (x, 0, 1)
        default: return (1, 0, x)
        }
    }

    private func frame() {
        guard let sender else { return }
        let values = samenstellen()
        sender.send(values.map { UInt8(min(max($0.rounded(), 0), 255)) })
    }
}
