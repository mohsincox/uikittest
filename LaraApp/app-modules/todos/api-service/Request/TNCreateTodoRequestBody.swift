import Foundation

struct TNCreateTodoRequestBody: Encodable {
    let title: String
    let isCompleted: Bool?

    enum CodingKeys: String, CodingKey {
        case title
        case isCompleted = "is_completed"
    }
}
