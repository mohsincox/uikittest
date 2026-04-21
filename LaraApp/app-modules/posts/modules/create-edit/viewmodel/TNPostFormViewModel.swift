import Foundation

enum TNPostFormMode {
    case create
    case edit(post: TNPostResponseBody)
}

final class TNPostFormViewModel: TNViewModel {
    @Published var title: String = ""
    @Published var body: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    let mode: TNPostFormMode
    private let apiService: TNPostApiService

    var screenTitle: String {
        if case .create = mode { return "New Post" }
        return "Edit Post"
    }

    var isValidInput: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty &&
                             !body.trimmingCharacters(in: .whitespaces).isEmpty }

    init(mode: TNPostFormMode, apiService: TNPostApiService = TNPostApiService()) {
        self.mode = mode
        self.apiService = apiService
        super.init()
        if case .edit(let post) = mode {
            title = post.title ?? ""
            body = post.body ?? ""
        }
    }

    func save() async {
        switch mode {
        case .create: await createPost()
        case .edit(let post):
            if let id = post.id { await updatePost(id: id) }
        }
    }

    private func createPost() async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.createPost(requestBody: TNCreatePostRequestBody(title: title, body: body))
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }

    private func updatePost(id: Int) async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.updatePost(id: id, requestBody: TNUpdatePostRequestBody(title: title, body: body))
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
}
