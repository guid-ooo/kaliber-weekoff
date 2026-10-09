import Foundation

enum ScriptError: LocalizedError {
    case failed(String)
    var errorDescription: String? {
        switch self {
        case .failed(let m): return m
        }
    }
}

final class ScriptRunner {
    private let queue = DispatchQueue(label: "nl.kaliber.weekoffbridge.applescript")
    private var cache: [String: NSAppleScript] = [:]

    func run(_ source: String, completion: @escaping (Result<String, Error>) -> Void) {
        queue.async {
            let result = self.execute(source)
            DispatchQueue.main.async { completion(result) }
        }
    }

    private func execute(_ source: String) -> Result<String, Error> {
        let script: NSAppleScript
        if let cached = cache[source] {
            script = cached
        } else if let fresh = NSAppleScript(source: source) {
            cache[source] = fresh
            script = fresh
        } else {
            return .failure(ScriptError.failed("script compileert niet"))
        }

        var error: NSDictionary?
        let result = script.executeAndReturnError(&error)
        if let error {
            let message = error[NSAppleScript.errorMessage] as? String ?? "onbekende AppleScript-fout"
            return .failure(ScriptError.failed(message))
        }
        return .success(result.stringValue ?? "")
    }
}
