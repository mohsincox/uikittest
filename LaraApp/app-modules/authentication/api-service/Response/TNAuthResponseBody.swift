import Foundation

struct TNAuthResponseBody: Decodable {
    let user: TNUserResponseBody?
    let token: String?
}

struct TNUserResponseBody: Decodable {
    let id: Int?
    let name: String?
    let email: String?
    let emailVerifiedAt: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
