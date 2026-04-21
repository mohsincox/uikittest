import Foundation

struct TNReorderTodosRequestBody: Encodable {
    let orderedIds: [String]

    enum CodingKeys: String, CodingKey {
        case orderedIds = "ordered_ids"
    }
}
