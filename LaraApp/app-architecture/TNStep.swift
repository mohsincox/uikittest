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

    // Content
    case contentDetailRequired(content: TNContentResponseBody)
    case createContentRequired
    case editContentRequired(content: TNContentResponseBody)
    
    // Book
    case bookDetailRequired(book: TNBookResponseBody)
    case createBookRequired
    case editBookRequired(book: TNBookResponseBody)
    case bookTabRequired
    
    // Category
    case categoryDetailRequired(category: TNCategoryResponseBody)
    case createCategoryRequired
    case editCategoryRequired(category: TNCategoryResponseBody)
    case categoryTabRequired
    
    // drawer
    case toggleDrawerRequired
}
