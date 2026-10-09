import AppKit

struct KeynoteDocument: Equatable {
    let id: String
    let name: String
}

struct SlideState: Equatable {
    let slide: Int
    let skipped: Bool
    let tags: [String]
}

enum Keynote {
    static let bundleIDs = ["com.apple.iWork.Keynote", "com.apple.Keynote"]

    static var isRunning: Bool {
        bundleIDs.contains { !NSRunningApplication.runningApplications(withBundleIdentifier: $0).isEmpty }
    }

    static let documentsScript = """
    tell application "Keynote"
        set out to ""
        repeat with d in documents
            set out to out & (id of d) & tab & (name of d) & linefeed
        end repeat
        return out
    end tell
    """

    static func pollScript(documentID: String) -> String {
        """
        tell application "Keynote"
            set target to missing value
            repeat with d in documents
                if (id of d) is "\(documentID)" then set target to d
            end repeat
            if target is missing value then return "GONE"
            tell target
                set c to current slide
                set n to slide number of c
                set sk to "0"
                try
                    if skipped of c then set sk to "1"
                end try
                set nts to ""
                try
                    set nts to presenter notes of c as string
                end try
            end tell
            return (n as string) & "|" & sk & "<<<" & nts
        end tell
        """
    }

    static func parseDocuments(_ raw: String) -> [KeynoteDocument] {
        raw.split(separator: "\n").compactMap { line in
            let parts = line.split(separator: "\t", maxSplits: 1).map(String.init)
            guard parts.count == 2 else { return nil }
            return KeynoteDocument(id: parts[0], name: parts[1])
        }
    }

    static func parseSlide(_ raw: String) -> SlideState? {
        guard raw != "GONE", let marker = raw.range(of: "<<<") else { return nil }
        let head = raw[raw.startIndex..<marker.lowerBound].split(separator: "|").map(String.init)
        guard head.count == 2, let slide = Int(head[0]) else { return nil }
        let notes = String(raw[marker.upperBound...])
        return SlideState(slide: slide, skipped: head[1] == "1", tags: tags(in: notes))
    }

    private static let tagPattern = try! NSRegularExpression(pattern: "#([A-Za-z][A-Za-z0-9_.-]*)")

    static func tags(in notes: String) -> [String] {
        let flat = notes.precomposedStringWithCompatibilityMapping
            .replacingOccurrences(of: "\u{2028}", with: "\n")
            .replacingOccurrences(of: "\u{2029}", with: "\n")
        let range = NSRange(flat.startIndex..., in: flat)
        var found: [String] = []
        for match in tagPattern.matches(in: flat, range: range) {
            guard let r = Range(match.range(at: 1), in: flat) else { continue }
            let tag = flat[r].lowercased()
            if !found.contains(tag) { found.append(tag) }
        }
        return found
    }
}
