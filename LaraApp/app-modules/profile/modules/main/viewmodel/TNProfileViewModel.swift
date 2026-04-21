import Foundation
import Combine

final class TNProfileViewModel: TNViewModel {
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let apiService: TNAuthApiService

    init(apiService: TNAuthApiService = TNAuthApiService()) {
        self.apiService = apiService
        super.init()
        loadCachedUser()
        bindLifecycle()
    }

    private func loadCachedUser() {
        userName = KeychainStorageManager.shared.get(.userName) ?? ""
        userEmail = KeychainStorageManager.shared.get(.userEmail) ?? ""
    }

    private func bindLifecycle() {
        lifeCycle.didAppearSubject
            .first()
            .sink { [weak self] _ in Task { await self?.fetchMe() } }
            .store(in: &cancellables)
    }

    func fetchMe() async {
        let result = await apiService.getMe()
        await MainActor.run {
            switch result {
            case .success(let user):
                userName = user.name ?? userName
                userEmail = user.email ?? userEmail
            case .failure(let error):
                errorMessage = error.errorMessage
            }
        }
    }

    func logout() async {
        await MainActor.run { isLoading = true }
        _ = await apiService.logout()
        await MainActor.run {
            isLoading = false
            KeychainStorageManager.shared.clearAll()
            stepper.send(.loginRequired)
        }
    }
}
