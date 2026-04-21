import SwiftUI

struct TNTodosListContentView: View {
    @ObservedObject var viewModel: TNTodosListViewModel
    @State private var editMode: EditMode = .inactive

    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(
                title: "Todos",
                trailingButtonTitle: editMode == .active ? "Done" : "Edit",
                trailingButtonAction: { editMode = editMode == .active ? .inactive : .active }
            )
            addTodoSection
            content
        }
        .background(Color(.systemBackground))
        .environment(\.editMode, $editMode)
    }

    private var addTodoSection: some View {
        HStack(spacing: 10) {
            TextField("New todo (min 3 chars)…", text: $viewModel.newTodoTitle)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            Button {
                Task { await viewModel.addTodo() }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(viewModel.canAddTodo ? .blue : .gray)
            }
            .disabled(!viewModel.canAddTodo)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .overlay(Rectangle().frame(height: 0.5).foregroundColor(Color(.separator)), alignment: .bottom)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.todos.isEmpty {
            Spacer(); ProgressView(); Spacer()
        } else if viewModel.todos.isEmpty {
            emptyState
        } else {
            todosList
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "checklist").font(.system(size: 48)).foregroundColor(.secondary)
            Text("No todos yet").font(.title3).foregroundColor(.secondary)
            Spacer()
        }
    }

    private var todosList: some View {
        List {
            ForEach(viewModel.todos) { todo in
                TNTodoRowView(todo: todo) { Task { await viewModel.toggleTodo(todo) } }
            }
            .onDelete { indexSet in
                indexSet.forEach { i in
                    if let id = viewModel.todos[i].id {
                        Task { await viewModel.deleteTodo(id: id) }
                    }
                }
            }
            .onMove(perform: viewModel.moveTodo)
        }
        .listStyle(.plain)
        .refreshable { await viewModel.loadTodos() }
    }
}

struct TNTodoRowView: View {
    let todo: TNTodoResponseBody
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted == true ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(todo.isCompleted == true ? .green : .secondary)
            }
            .buttonStyle(.plain)
            Text(todo.title ?? "")
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .strikethrough(todo.isCompleted == true)
        }
        .padding(.vertical, 4)
    }
}
