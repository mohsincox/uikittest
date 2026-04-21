import Foundation

struct TNTodoResponseBody: Decodable, Identifiable {
    let id: String?
    let title: String?
    let isCompleted: Bool?
    let sortOrder: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case isCompleted = "is_completed"
        case sortOrder   = "sort_order"
        case createdAt   = "created_at"
        case updatedAt   = "updated_at"
    }
}
