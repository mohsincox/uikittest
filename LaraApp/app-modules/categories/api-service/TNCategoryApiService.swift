//
//  TNCategoryApiService.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/12.
//

import Foundation

final class TNCategoryApiService {
    func getCategories() async -> AppResult<[TNCategoryResponseBody]> {
        guard let url = URLS.Categories.list else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode([TNCategoryResponseBody].self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }
    
    func deleteCategory(id: Int) async -> AppResult<GenericResponseModel<EmptyResponse>> {
        guard let url = URLS.Categories.delete(id: id) else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .delete)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }
    
    func createCategory(requestBody: TNCreateCategoryRequestBody) async -> AppResult<TNCategoryResponseBody> {
            guard let url = URLS.Categories.list else { return .failure(NetworkError.invalidURL) }
            do {
                let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .post, body: requestBody)
                guard let data = reply.data else {
                    return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
                }
                guard reply.isSuccess else {
                    let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                    return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
                }
                return .success(try JSONDecoder().decode(TNCategoryResponseBody.self, from: data))
            } catch let e as DecodingError {
                return .failure(NetworkError.decodingFailed(underlying: e))
            } catch {
                return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
            }
        }
    
    func updateCategory(id: Int, requestBody: TNUpdateCategoryRequestBody) async -> AppResult<TNCategoryResponseBody> {
            print(id)
            guard let url = URLS.Categories.update(id: id) else { return .failure(NetworkError.invalidURL) }
            do {
                let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .put, body: requestBody)
                guard let data = reply.data else {
                    return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
                }
                guard reply.isSuccess else {
                    let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                    return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
                }
                return .success(try JSONDecoder().decode(TNCategoryResponseBody.self, from: data))
            } catch let e as DecodingError {
                return .failure(NetworkError.decodingFailed(underlying: e))
            } catch {
                return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
            }
        }
}
