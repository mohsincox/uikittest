import Foundation

final class TNPostApiService {
    func getPosts() async -> AppResult<[TNPostResponseBody]> {
        guard let url = URLS.Posts.list else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode([TNPostResponseBody].self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func getPost(id: Int) async -> AppResult<TNPostResponseBody> {
        guard let url = URLS.Posts.detail(id: id) else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode(TNPostResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func createPost(requestBody: TNCreatePostRequestBody) async -> AppResult<TNPostResponseBody> {
        guard let url = URLS.Posts.list else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .post, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNPostResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func updatePost(id: Int, requestBody: TNUpdatePostRequestBody) async -> AppResult<TNPostResponseBody> {
        guard let url = URLS.Posts.update(id: id) else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .put, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNPostResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func deletePost(id: Int) async -> AppResult<GenericResponseModel<EmptyResponse>> {
        guard let url = URLS.Posts.delete(id: id) else { return .failure(NetworkError.invalidURL) }
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
