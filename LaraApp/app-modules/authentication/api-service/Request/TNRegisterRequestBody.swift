import Foundation

struct TNRegisterRequestBody: Encodable {
    let name: String
    let email: String
    let password: String
}
