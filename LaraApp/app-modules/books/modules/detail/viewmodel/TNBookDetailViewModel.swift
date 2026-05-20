//
//  TNBookDetailViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/05.
//

import Foundation

final class TNBookDetailViewModel: TNViewModel {
    @Published var book: TNBookResponseBody
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let apiService: TNBookApiService
    
    init(book: TNBookResponseBody, apiService: TNBookApiService = TNBookApiService()) {
        self.book = book
        self.apiService = apiService
        super.init()
        bindLifecycle()
    }
    
    func deletePost() async {
        guard let id = book.id else { return }
        await MainActor.run { isLoading = true }
        let result = await apiService.deleteBook(id: id)
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
    
    func onEditTapped() {
        stepper.send(.editBookRequired(book: book))
    }
    
    func bindLifecycle() {
        lifeCycle.didAppearSubject
            .sink { [weak self] _ in Task { await self?.reloadBook() } }
            .store(in: &cancellables)
    }

    private func reloadBook() async {
        guard let id = book.id else { return }
        let result = await apiService.getBook(id: id)
        await MainActor.run {
            switch result {
            case .success(let updated): self.book = updated
            case .failure: break
            }
        }
    }
}
