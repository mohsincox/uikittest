import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct APIReply {
    let data: Data?
    let statusCode: Int
    var isSuccess: Bool { (200...299).contains(statusCode) }
}

final class TNAPIService {
    static let shared = TNAPIService()

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config)
    }

    func request<Body: Encodable>(
        url: URL,
        method: HTTPMethod,
        body: Body?,
        headers: [String: String] = [:]
    ) async throws -> APIReply {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await session.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        return APIReply(data: data, statusCode: statusCode)
    }

    func request(url: URL, method: HTTPMethod, headers: [String: String] = [:]) async throws -> APIReply {
        try await request(url: url, method: method, body: Optional<String>.none, headers: headers)
    }
}
