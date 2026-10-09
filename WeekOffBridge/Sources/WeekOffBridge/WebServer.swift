import Foundation
import Network

struct WebResponse {
    let status: String
    let type: String
    let body: Data

    static func json(_ data: Data) -> WebResponse { WebResponse(status: "200 OK", type: "application/json", body: data) }
    static func html(_ text: String) -> WebResponse { WebResponse(status: "200 OK", type: "text/html; charset=utf-8", body: Data(text.utf8)) }
    static let notFound = WebResponse(status: "404 Not Found", type: "text/plain", body: Data())
}

struct WebRequest {
    let method: String
    let path: String
    let body: Data
}

final class WebServer {
    private var listener: NWListener?
    private let queue = DispatchQueue(label: "nl.kaliber.weekoffbridge.web")
    let port: UInt16

    var handler: ((WebRequest) -> WebResponse)?

    init(port: UInt16) {
        self.port = port
    }

    func start() {
        guard listener == nil, let nwPort = NWEndpoint.Port(rawValue: port) else { return }
        let parameters = NWParameters.tcp
        parameters.requiredLocalEndpoint = NWEndpoint.hostPort(host: "127.0.0.1", port: nwPort)
        listener = try? NWListener(using: parameters)
        listener?.newConnectionHandler = { [weak self] connection in
            connection.start(queue: self?.queue ?? .main)
            self?.receive(connection, buffer: Data())
        }
        listener?.start(queue: queue)
    }

    private func receive(_ connection: NWConnection, buffer: Data) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1 << 20) { [weak self] data, _, done, _ in
            guard let self else { return }
            var accumulated = buffer
            if let data { accumulated.append(data) }

            if let request = Self.parse(accumulated) {
                let response = self.handler?(request) ?? .notFound
                var head = "HTTP/1.1 \(response.status)\r\n"
                head += "Content-Type: \(response.type)\r\n"
                head += "Content-Length: \(response.body.count)\r\n"
                head += "Cache-Control: no-store\r\nConnection: close\r\n\r\n"
                connection.send(content: Data(head.utf8) + response.body, completion: .contentProcessed { _ in
                    connection.cancel()
                })
                return
            }
            if done { connection.cancel() } else { self.receive(connection, buffer: accumulated) }
        }
    }

    static func parse(_ data: Data) -> WebRequest? {
        guard let separator = data.range(of: Data("\r\n\r\n".utf8)) else { return nil }
        let header = String(decoding: data[..<separator.lowerBound], as: UTF8.self)
        let lines = header.components(separatedBy: "\r\n")
        let parts = lines[0].split(separator: " ")
        guard parts.count >= 2 else { return nil }

        var expected = 0
        for line in lines.dropFirst() where line.lowercased().hasPrefix("content-length:") {
            let waarde = line.split(separator: ":", maxSplits: 1).dropFirst().first ?? ""
            expected = Int(waarde.trimmingCharacters(in: .whitespaces)) ?? 0
        }
        let body = data[separator.upperBound...]
        guard body.count >= expected else { return nil }
        return WebRequest(method: String(parts[0]), path: String(parts[1]), body: Data(body.prefix(expected)))
    }
}
