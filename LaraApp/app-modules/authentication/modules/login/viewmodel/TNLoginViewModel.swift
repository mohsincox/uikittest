import Foundation
import Combine

final class TNLoginViewModel: TNViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    var isValidInput: Bool {
        !email.isEmpty && email.contains("@") && !password.isEmpty
    }

    private let apiService: TNAuthApiService

    init(apiService: TNAuthApiService = TNAuthApiService()) {
        self.apiService = apiService
        super.init()
    }

    func login() async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.login(requestBody: TNLoginRequestBody(email: email, password: password))
        await MainActor.run {
            isLoading = false
            handleResult(result)
        }
    }

    @MainActor
    private func handleResult(_ result: AppResult<TNAuthResponseBody>) {
        switch result {
        case .success(let response):
            guard let token = response.token else {
                errorMessage = "Login failed: no token received"
                return
            }
            saveSession(token: token, user: response.user)
            stepper.send(.mainTabRequired)
        case .failure(let error):
            errorMessage = error.errorMessage
        }
    }

    private func saveSession(token: String, user: TNUserResponseBody?) {
        KeychainStorageManager.shared.save(token, for: .accessToken)
        if let name = user?.name  { KeychainStorageManager.shared.save(name, for: .userName) }
        if let email = user?.email { KeychainStorageManager.shared.save(email, for: .userEmail) }
        if let id = user?.id       { KeychainStorageManager.shared.save(String(id), for: .userId) }
    }
}
