import Foundation
import Combine

final class TNPostsListViewModel: TNViewModel {
    @Published var posts: [TNPostResponseBody] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let apiService: TNPostApiService

    init(apiService: TNPostApiService = TNPostApiService()) {
        self.apiService = apiService
        super.init()
        bindLifecycle()
    }

    private func bindLifecycle() {
        lifeCycle.didAppearSubject
            .sink { [weak self] _ in Task { await self?.loadPosts() } }
            .store(in: &cancellables)
    }

    func loadPosts() async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.getPosts()
        await MainActor.run {
            isLoading = false
            switch result {
            case .success(let posts): self.posts = posts
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }

    func deletePost(id: Int) async {
        let result = await apiService.deletePost(id: id)
        await MainActor.run {
            switch result {
            case .success: posts.removeAll { $0.id == id }
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }

    func onPostTapped(_ post: TNPostResponseBody) {
        stepper.send(.postDetailRequired(post: post))
    }

    func onCreatePostTapped() {
        stepper.send(.createPostRequired)
    }
}
