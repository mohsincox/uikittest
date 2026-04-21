import Foundation

final class TNAuthApiService {
    func login(requestBody: TNLoginRequestBody) async -> AppResult<TNAuthResponseBody> {
        guard let url = URLS.Auth.login else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .post, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                if reply.statusCode == 401 { return .failure(NetworkError.unauthorized) }
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNAuthResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func register(requestBody: TNRegisterRequestBody) async -> AppResult<TNAuthResponseBody> {
        guard let url = URLS.Auth.register else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .post, body: requestBody)
            guard let data = reply.data else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            guard reply.isSuccess else {
                let msg = (try? JSONDecoder().decode(GenericResponseModel<EmptyResponse>.self, from: data))?.message
                return .failure(NetworkError.serverError(code: reply.statusCode, message: msg))
            }
            return .success(try JSONDecoder().decode(TNAuthResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func logout() async -> AppResult<EmptyResponse> {
        guard let url = URLS.Auth.logout else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .post)
            guard reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(EmptyResponse())
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }

    func getMe() async -> AppResult<TNUserResponseBody> {
        guard let url = URLS.Auth.me else { return .failure(NetworkError.invalidURL) }
        do {
            let reply = try await GlobalAPIServiceManager.shared.request(url: url, method: .get)
            guard let data = reply.data, reply.isSuccess else {
                return .failure(NetworkError.serverError(code: reply.statusCode, message: nil))
            }
            return .success(try JSONDecoder().decode(TNUserResponseBody.self, from: data))
        } catch let e as DecodingError {
            return .failure(NetworkError.decodingFailed(underlying: e))
        } catch {
            return .failure(NetworkError.serverError(code: -1, message: error.localizedDescription))
        }
    }
}

struct GenericResponseModel<DataType: Decodable>: Decodable {
    var message: String?
    var data: DataType?
    var errors: [String: [String]]?
}

struct EmptyResponse: Decodable {}
