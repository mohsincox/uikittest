//
//  TNContentApiService.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

import Foundation

final class TNContentApiService {
    func getContents() async -> AppResult<[TNContentResponseBody]> {
        guard let url = URLS.Contents.list else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode([TNContentResponseBody].self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func getContent(id: Int) async -> AppResult<TNContentResponseBody> {
        guard let url = URLS.Contents.detail(id: id) else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode(TNContentResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func createContent(requestBody: TNCreateContentRequestBody) async -> AppResult<TNContentResponseBody> {
        guard let url = URLS.Contents.list else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .post, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNContentResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func updateContent(id: Int, requestBody: TNUpdateContentRequestBody) async -> AppResult<TNContentResponseBody> {
        guard let url = URLS.Contents.update(id: id) else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .put, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNContentResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func deleteContent(id: Int) async -> AppResult<GenericResponseModel<EmptyResponse>> {
        guard let url = URLS.Contents.delete(id: id) else { return .failure(NetworkError.invalidURL) }
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
}

