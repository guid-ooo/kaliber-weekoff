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
        guard inet_pton(AF_INET, host, &target.sin_addr) == 1 else {
            close(fd)
            return nil
        }
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

    private(set) var isRunning = false

    func configure(_ config: ArtNetConfig) {
        queue.sync {
            sender = ArtNetSender(host: config.host, universe: config.universe, broadcast: config.broadcast)
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

    func apply(levels: [Int: Double], fade: Double) {
        queue.async {
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

    private func frame() {
        guard let sender else { return }
        sender.send(currentLevels().map { UInt8(min(max($0.rounded(), 0), 255)) })
    }
}
