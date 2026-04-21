import Foundation

final class TNTodoApiService {
    func getTodos() async -> AppResult<[TNTodoResponseBody]> {
        guard let url = URLS.Todos.list else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode([TNTodoResponseBody].self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func createTodo(requestBody: TNCreateTodoRequestBody) async -> AppResult<TNTodoResponseBody> {
        guard let url = URLS.Todos.list else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .post, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNTodoResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func updateTodo(id: String, requestBody: TNUpdateTodoRequestBody) async -> AppResult<TNTodoResponseBody> {
        guard let url = URLS.Todos.update(id: id) else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .put, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNTodoResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func deleteTodo(id: String) async -> AppResult<GenericResponseModel<EmptyResponse>> {
        guard let url = URLS.Todos.delete(id: id) else { return .failure(NetworkError.invalidURL) }
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

    func reorderTodos(requestBody: TNReorderTodosRequestBody) async -> AppResult<GenericResponseModel<EmptyResponse>> {
        guard let url = URLS.Todos.reorder else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .put, body: requestBody)
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
