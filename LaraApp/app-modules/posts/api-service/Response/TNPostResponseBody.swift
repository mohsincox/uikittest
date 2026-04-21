import Foundation

struct TNPostResponseBody: Decodable, Identifiable {
    let id: Int?
    let userId: Int?
    let title: String?
    let body: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, body
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
