import Foundation

struct URLS {
    static let baseURL = "http://localhost:8000/api"
//    static let baseURL = "http://10.70.34.124:8000/api"

    enum Auth {
        static var login: URL?    { URL(string: "\(URLS.baseURL)/login") }
        static var register: URL? { URL(string: "\(URLS.baseURL)/register") }
        static var logout: URL?   { URL(string: "\(URLS.baseURL)/logout") }
        static var me: URL?       { URL(string: "\(URLS.baseURL)/me") }
    }

    enum Posts {
        static var list: URL? { URL(string: "\(URLS.baseURL)/posts") }
        static func detail(id: Int) -> URL? { URL(string: "\(URLS.baseURL)/posts/\(id)") }
        static func update(id: Int) -> URL? { URL(string: "\(URLS.baseURL)/posts/\(id)") }
        static func delete(id: Int) -> URL? { URL(string: "\(URLS.baseURL)/posts/\(id)") }
    }

    enum Todos {
        static var list: URL?    { URL(string: "\(URLS.baseURL)/todos") }
        static var reorder: URL? { URL(string: "\(URLS.baseURL)/todos/reorder") }
        static func update(id: String) -> URL? { URL(string: "\(URLS.baseURL)/todos/\(id)") }
        static func delete(id: String) -> URL? { URL(string: "\(URLS.baseURL)/todos/\(id)") }
    }

    enum Contents {
        static var list: URL?                  { URL(string: "\(URLS.baseURL)/contents") }
        static func detail(id: Int) -> URL?    { URL(string: "\(URLS.baseURL)/contents/\(id)") }
        static func update(id: Int) -> URL?    { URL(string: "\(URLS.baseURL)/contents/\(id)") }
        static func delete(id: Int) -> URL?    { URL(string: "\(URLS.baseURL)/contents/\(id)") }
    }
    
    enum Books {
        static var list: URL? { URL(string: "\(URLS.baseURL)/books") }
        static func detail(id: Int) -> URL? { URL(string: "\(URLS.baseURL)/books/\(id)") }
        static func update(id: Int) -> URL? { URL(string: "\(URLS.baseURL)/books/\(id)") }
        static func delete(id: Int) -> URL? { URL(string: "\(URLS.baseURL)/books/\(id)") }
        static func dateWiseList(startDate: String, endDate: String) -> URL? {
            URL(string: "\(URLS.baseURL)/date-wise-books?start_date=\(startDate)&end_date=\(endDate)")
        }
    }
    
    enum Categories {
        static var list: URL? { URL(string: "\(URLS.baseURL)/categories") }
        static func detail(id: Int) -> URL? { URL(string: "\(URLS.baseURL)/categories/\(id)") }
        static func update(id: Int) -> URL? { URL(string: "\(URLS.baseURL)/categories/\(id)") }
        static func delete(id: Int) -> URL? { URL(string: "\(URLS.baseURL)/categories/\(id)") }
        static func dateWiseList(startDate: String, endDate: String) -> URL? {
            URL(string: "\(URLS.baseURL)/date-wise-categories?start_date=\(startDate)&end_date=\(endDate)")
        }
    }
}
