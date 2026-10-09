import AppKit
import ImageIO

enum NotoEmoji {
    static func code(for emoji: String) -> String? {
        let punten = emoji.unicodeScalars
            .filter { $0.value != 0xFE0F && $0.value != 0x200D }
            .map { String(format: "%x", $0.value) }
        return punten.isEmpty ? nil : punten.joined(separator: "_")
    }

    private static var map: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("WeekOffBridge/emoji", isDirectory: true)
        try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        return base
    }

    static func bestand(voor emoji: String) -> URL? {
        guard let code = code(for: emoji) else { return nil }
        let doel = map.appendingPathComponent(code + ".webp")
        return FileManager.default.fileExists(atPath: doel.path) ? doel : nil
    }

    static func haalOp(_ emoji: String, klaar: ((URL?) -> Void)? = nil) {
        if let bestaand = bestand(voor: emoji) { klaar?(bestaand); return }
        guard let code = code(for: emoji),
              let bron = URL(string: "https://fonts.gstatic.com/s/e/notoemoji/latest/\(code)/512.webp")
        else { klaar?(nil); return }

        URLSession.shared.dataTask(with: bron) { data, antwoord, _ in
            guard let data, (antwoord as? HTTPURLResponse)?.statusCode == 200,
                  CGImageSourceCreateWithData(data as CFData, nil) != nil else {
                DispatchQueue.main.async { klaar?(nil) }
                return
            }
            let doel = map.appendingPathComponent(code + ".webp")
            try? data.write(to: doel)
            DispatchQueue.main.async { klaar?(doel) }
        }.resume()
    }

    static func frames(_ url: URL) -> (beelden: [CGImage], duur: Double)? {
        guard let data = try? Data(contentsOf: url),
              let bron = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let aantal = CGImageSourceGetCount(bron)
        guard aantal > 1 else { return nil }

        var beelden: [CGImage] = []
        var duur = 0.0
        for i in 0..<aantal {
            guard let beeld = CGImageSourceCreateImageAtIndex(bron, i, nil) else { continue }
            beelden.append(beeld)
            let props = CGImageSourceCopyPropertiesAtIndex(bron, i, nil) as? [String: Any]
            let web = props?[kCGImagePropertyWebPDictionary as String] as? [String: Any]
            duur += (web?[kCGImagePropertyWebPDelayTime as String] as? Double) ?? 0.05
        }
        return beelden.isEmpty ? nil : (beelden, max(duur, 0.4))
    }
}
