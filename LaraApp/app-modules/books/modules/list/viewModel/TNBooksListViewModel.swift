//
//  TNBooksListViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/03.
//

import Foundation
import Combine

final class TNBooksListViewModel: TNViewModel {
    @Published var books: [TNBookResponseBody] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let apiService: TNBookApiService

    init(apiService: TNBookApiService = TNBookApiService()) {
        self.apiService = apiService
        super.init()
        bindLifecycle()
    }

    private func bindLifecycle() {
        lifeCycle.didAppearSubject
            .sink { [weak self] _ in Task { await self?.loadBooks() } }
            .store(in: &cancellables)
    }

    func loadBooks() async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.getBooks()
        await MainActor.run {
            isLoading = false
            switch result {
            case .success(let posts): self.books = posts
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
    
    func onBookTapped(_ book: TNBookResponseBody) {
        stepper.send(.bookDetailRequired(book: book))
    }
    
    func deleteBook(id: Int) async {
        let result = await apiService.deleteBook(id: id)
        await MainActor.run {
            switch result {
            case .success: books.removeAll { $0.id == id }
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
    
    func onCreateBookTapped() {
        stepper.send(.createBookRequired)
    }
    
    func onBookTabTapped() {
        stepper.send(.bookTabRequired)
    }
    
    func onDateWiseBooksTapped() {
        stepper.send(.dateWiseBooksRequired)
    }
}
