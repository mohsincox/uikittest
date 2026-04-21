import Foundation

struct TNUpdateTodoRequestBody: Encodable {
    let title: String?
    let isCompleted: Bool?

    enum CodingKeys: String, CodingKey {
        case title
        case isCompleted = "is_completed"
    }
}
