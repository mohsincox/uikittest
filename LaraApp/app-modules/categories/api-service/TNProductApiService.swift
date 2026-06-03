//
//  TNProductApiService.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/06/03.
//

import Foundation

final class TNProductApiService {
    func getProducts(categoryId: Int) async -> AppResult<[TNProductResponseBody]> {
        guard let url = URL(string: "\(URLS.baseURL)/products?category_id=\(categoryId)") else {
            return .failure(NetworkError.invalidURL)
        }

        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            let response = try JSONDecoder().decode(TNProductListResponse.self, from: data)
            return .success(response.data)
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }
}