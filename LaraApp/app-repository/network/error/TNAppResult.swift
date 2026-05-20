import Foundation

enum AppResult<Success> {
    case success(Success)
    case failure(AppError)
}
