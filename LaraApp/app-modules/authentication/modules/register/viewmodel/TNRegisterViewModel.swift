import Foundation
import Combine

final class TNRegisterViewModel: TNViewModel {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    var isValidInput: Bool {
        !name.isEmpty && !email.isEmpty && email.contains("@") &&
        password.count >= TNConstants.Auth.minimumPasswordLength
    }

    private let apiService: TNAuthApiService

    init(apiService: TNAuthApiService = TNAuthApiService()) {
        self.apiService = apiService
        super.init()
    }

    func register() async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let requestBody = TNRegisterRequestBody(name: name, email: email, password: password)
        let result = await apiService.register(requestBody: requestBody)
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
                errorMessage = "Registration failed: no token received"
                return
            }
            KeychainStorageManager.shared.save(token, for: .accessToken)
            if let name = response.user?.name   { KeychainStorageManager.shared.save(name, for: .userName) }
            if let email = response.user?.email { KeychainStorageManager.shared.save(email, for: .userEmail) }
            if let id = response.user?.id       { KeychainStorageManager.shared.save(String(id), for: .userId) }
            stepper.send(.mainTabRequired)
        case .failure(let error):
            errorMessage = error.errorMessage
        }
    }
}
