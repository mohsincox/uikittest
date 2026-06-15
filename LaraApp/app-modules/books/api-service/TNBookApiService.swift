//
//  TNBookApiService.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/04.
//

import Foundation

final class TNBookApiService {
    func getBooks() async -> AppResult<[TNBookResponseBody]> {
        guard let url = URLS.Books.list else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode([TNBookResponseBody].self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func deleteBook(id: Int) async -> AppResult<GenericResponseModel<EmptyResponse>> {
        guard let url = URLS.Books.delete(id: id) else { return .failure(NetworkError.invalidURL) }
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
    
    func createBook(requestBody: TNCreateBookRequestBody) async -> AppResult<TNBookResponseBody> {
        guard let url = URLS.Books.list else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .post, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNBookResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }
    
    func updateBook(id: Int, requestBody: TNUpdateBookRequestBody) async -> AppResult<TNBookResponseBody> {
        print(id)
        guard let url = URLS.Books.update(id: id) else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .put, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNBookResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }
    
    func getBook(id: Int) async -> AppResult<TNBookResponseBody> {
        guard let url = URLS.Books.detail(id: id) else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode(TNBookResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }
    
    func getDateWiseBooks(startDate: String, endDate: String) async -> AppResult<[TNBookResponseBody]> {
        guard let url = URLS.Books.dateWiseList(startDate: startDate, endDate: endDate) else {
            return .failure(NetworkError.invalidURL)
        }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode([TNBookResponseBody].self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }
}
