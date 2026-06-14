//
//  TNChapterApiService.swift
//  LaraApp
//
//  Created by TN-LAP-0134 on 9/6/26.
//

import Foundation

final class TNChapterApiService {
    func getChapters(bookId: Int) async -> AppResult<[TNChapterResponseBody]> {
        guard let url = URL(string: "\(URLS.baseURL)/chapters?book_id=\(bookId)") else {
            return .failure(NetworkError.invalidURL)
        }

        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            let response = try JSONDecoder().decode(TNChapterListResponse.self, from: data)
            return .success(response.data)
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }
}
