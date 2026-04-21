import Foundation

enum TNStep {
    case popRequired
    case dismissRequired(animated: Bool)

    // Auth
    case loginRequired
    case registerRequired
    case mainTabRequired

    // Posts
    case postDetailRequired(post: TNPostResponseBody)
    case createPostRequired
    case editPostRequired(post: TNPostResponseBody)
}
