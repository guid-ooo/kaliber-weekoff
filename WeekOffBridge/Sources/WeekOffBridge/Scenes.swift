import Foundation

struct Fixture: Codable, Equatable {
    let address: Int
    let channels: [String]
}

struct Scene: Codable, Equatable {
    let fade: Double
    let values: [String: Double]
    var audio: String?
    var audioFade: Double?
}

struct Pad: Codable, Equatable {
    var sample: String?
    var dmx: [String: Double]?
    var hold: Bool?
}

struct ArtNetConfig: Codable, Equatable {
    let host: String
    let universe: Int
    let broadcast: Bool
}

struct ShowConfig: Codable, Equatable {
    let artnet: ArtNetConfig
    let fixtures: [String: Fixture]
    let scenes: [String: Scene]
    var pads: [String: Pad]?

    func pad(channel: UInt8, note: UInt8) -> Pad? {
        pads?["\(channel):\(note)"] ?? pads?["\(note)"]
    }

    func audio(for tags: [String]) -> (path: String?, fade: Double)? {
        for tag in tags.reversed() {
            guard let scene = scenes[tag] else { continue }
            if let audio = scene.audio {
                return (audio == "keep" ? nil : audio, scene.audioFade ?? 1)
            }
        }
        return tags.contains(where: { scenes[$0] != nil }) ? (nil, 1) : nil
    }

    func levels(_ values: [String: Double]) -> [Int: Double] {
        var out: [Int: Double] = [:]
        for (path, percent) in values {
            guard let channel = dmxChannel(for: path) else { continue }
            out[channel] = min(max(percent, 0), 100) / 100 * 255
        }
        return out
    }

    func levels(for tags: [String]) -> (levels: [Int: Double], fade: Double, unknown: [String])? {
        var matched: [Scene] = []
        var unknown: [String] = []
        for tag in tags {
            if let scene = scenes[tag] { matched.append(scene) } else { unknown.append(tag) }
        }
        guard !matched.isEmpty else { return unknown.isEmpty ? nil : ([:], 0, unknown) }

        var levels: [Int: Double] = [:]
        for scene in matched {
            for (path, percent) in scene.values {
                guard let channel = dmxChannel(for: path) else { continue }
                levels[channel] = min(max(percent, 0), 100) / 100 * 255
            }
        }
        return (levels, matched.map(\.fade).max() ?? 0, unknown)
    }

    func dmxChannel(for path: String) -> Int? {
        let parts = path.split(separator: ".", maxSplits: 1).map(String.init)
        guard let fixture = fixtures[parts[0]] else { return nil }
        if parts.count == 1 { return fixture.address }
        guard let offset = fixture.channels.firstIndex(of: parts[1]) else { return nil }
        return fixture.address + offset
    }

    static let fallback = ShowConfig(
        artnet: ArtNetConfig(host: "10.11.46.11", universe: 0, broadcast: true),
        fixtures: [
            "spot": Fixture(address: 1, channels: ["warm", "cool", "strobe"]),
            "floods": Fixture(address: 4, channels: ["red", "green", "blue"]),
            "rookmachine": Fixture(address: 420, channels: ["rook"]),
        ],
        scenes: [
            "start": Scene(fade: 2, values: ["spot.warm": 18, "spot.cool": 9]),
            "twak": Scene(fade: 2, values: ["spot.warm": 74]),
            "samenvatting": Scene(fade: 2, values: ["spot.warm": 74]),
            "demo": Scene(fade: 2, values: ["spot.warm": 60, "floods.blue": 40]),
            "shoutouts": Scene(fade: 1, values: ["floods.red": 100]),
            "dilemma": Scene(fade: 2, values: ["spot.cool": 60, "floods.blue": 60]),
            "blackout": Scene(fade: 1, values: [:]),
        ],
        pads: [
            "44": Pad(sample: nil, dmx: ["rookmachine.rook": 100], hold: true),
        ]
    )
}

enum ConfigStore {
    static var url: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("WeekOffBridge", isDirectory: true)
        try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        return base.appendingPathComponent("scenes.json")
    }

    static func loadOrCreate() -> Result<ShowConfig, Error> {
        let path = url
        if !FileManager.default.fileExists(atPath: path.path) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            if let data = try? encoder.encode(ShowConfig.fallback) {
                try? data.write(to: path)
            }
        }
        do {
            let data = try Data(contentsOf: path)
            return .success(try JSONDecoder().decode(ShowConfig.self, from: data))
        } catch {
            return .failure(error)
        }
    }

    static func save(_ config: ShowConfig) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(config).write(to: url)
    }

    static var modified: Date? {
        try? FileManager.default.attributesOfItem(atPath: url.path)[.modificationDate] as? Date
    }
}
