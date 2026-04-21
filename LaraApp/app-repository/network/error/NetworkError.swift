import Foundation

protocol AppError: Error {
    var errorCode: String { get }
    var errorMessage: String { get }
}

enum NetworkError: AppError {
    case noInternetConnection
    case serverError(code: Int, message: String?)
    case serverResponseData(Data)
    case timeout
    case decodingFailed(underlying: Error)
    case invalidURL
    case unauthorized

    var errorCode: String {
        switch self {
        case .noInternetConnection: return "NETWORK_NO_INTERNET"
        case .serverError(let code, _): return "NETWORK_SERVER_\(code)"
        case .decodingFailed: return "NETWORK_DECODE_FAILED"
        case .timeout: return "NETWORK_TIMEOUT"
        case .invalidURL: return "NETWORK_INVALID_URL"
        case .serverResponseData: return "NETWORK_RESPONSE_DATA"
        case .unauthorized: return "NETWORK_UNAUTHORIZED"
        }
    }

    var errorMessage: String {
        switch self {
        case .noInternetConnection: return "Please check your internet connection."
        case .serverError(_, let message): return message ?? "Server error occurred."
        case .timeout: return "Request timed out. Please try again."
        case .decodingFailed: return "Unable to process server response."
        case .invalidURL: return "Invalid URL."
        case .serverResponseData: return "Server response data error."
        case .unauthorized: return "Invalid credentials."
        }
    }
}
