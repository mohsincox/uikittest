import Foundation
import Combine

final class TNTodosListViewModel: TNViewModel {
    @Published var todos: [TNTodoResponseBody] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var newTodoTitle: String = ""

    var canAddTodo: Bool { newTodoTitle.count >= TNConstants.Auth.minimumTodoTitleLength }

    private let apiService: TNTodoApiService

    init(apiService: TNTodoApiService = TNTodoApiService()) {
        self.apiService = apiService
        super.init()
        bindLifecycle()
    }

    private func bindLifecycle() {
        lifeCycle.didAppearSubject
            .first()
            .sink { [weak self] _ in Task { await self?.loadTodos() } }
            .store(in: &cancellables)
    }

    func loadTodos() async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.getTodos()
        await MainActor.run {
            isLoading = false
            switch result {
            case .success(let todos): self.todos = todos
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }

    func addTodo() async {
        guard canAddTodo else { return }
        let title = newTodoTitle
        let requestBody = TNCreateTodoRequestBody(title: title, isCompleted: false)
        let result = await apiService.createTodo(requestBody: requestBody)
        await MainActor.run {
            switch result {
            case .success(let todo):
                todos.append(todo)
                newTodoTitle = ""
            case .failure(let error):
                errorMessage = error.errorMessage
            }
        }
    }

    func toggleTodo(_ todo: TNTodoResponseBody) async {
        guard let id = todo.id else { return }
        let requestBody = TNUpdateTodoRequestBody(title: todo.title, isCompleted: !(todo.isCompleted ?? false))
        let result = await apiService.updateTodo(id: id, requestBody: requestBody)
        await MainActor.run {
            switch result {
            case .success(let updated):
                if let idx = todos.firstIndex(where: { $0.id == id }) {
                    todos[idx] = updated
                }
            case .failure(let error):
                errorMessage = error.errorMessage
            }
        }
    }

    func deleteTodo(id: String) async {
        let result = await apiService.deleteTodo(id: id)
        await MainActor.run {
            switch result {
            case .success: todos.removeAll { $0.id == id }
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }

    func moveTodo(from source: IndexSet, to destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
        let orderedIds = todos.compactMap { $0.id }
        Task {
            _ = await apiService.reorderTodos(requestBody: TNReorderTodosRequestBody(orderedIds: orderedIds))
        }
    }
}
