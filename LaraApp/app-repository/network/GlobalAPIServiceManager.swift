import Foundation

final class GlobalAPIServiceManager {
    static let shared = GlobalAPIServiceManager()

    private let service = TNAPIService.shared

    private init() {}

    func request<Body: Encodable>(url: URL, method: HTTPMethod, body: Body?) async throws -> APIReply {
        var headers: [String: String] = [:]
        if let token = KeychainStorageManager.shared.get(.accessToken) {
            headers["Authorization"] = "Bearer \(token)"
        }
        return try await service.request(url: url, method: method, body: body, headers: headers)
    }

    func request(url: URL, method: HTTPMethod) async throws -> APIReply {
        try await request(url: url, method: method, body: Optional<String>.none)
    }
}
