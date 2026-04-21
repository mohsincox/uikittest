import Foundation

final class TNPostDetailViewModel: TNViewModel {
    @Published var post: TNPostResponseBody
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let apiService: TNPostApiService

    init(post: TNPostResponseBody, apiService: TNPostApiService = TNPostApiService()) {
        self.post = post
        self.apiService = apiService
        super.init()
    }

    func onEditTapped() {
        stepper.send(.editPostRequired(post: post))
    }

    func deletePost() async {
        guard let id = post.id else { return }
        await MainActor.run { isLoading = true }
        let result = await apiService.deletePost(id: id)
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
}
