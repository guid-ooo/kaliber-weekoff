import Foundation

enum QLab {
    static func startScript(tags: [String]) -> String {
        let body = tags.map { tag in
            """
                    try
                        start (first cue whose q number is "\(tag)")
                    on error
                        set misses to misses & "\(tag) "
                    end try
            """
        }.joined(separator: "\n")

        return """
        set misses to ""
        tell application id "com.figure53.QLab.5"
            if (count of workspaces) is 0 then return "NO_WORKSPACE"
            tell front workspace
        \(body)
            end tell
        end tell
        return misses
        """
    }
}
