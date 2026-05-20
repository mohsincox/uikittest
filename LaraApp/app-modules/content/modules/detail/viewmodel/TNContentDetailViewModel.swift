//
//  TNContentDetailViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

import Foundation

final class TNContentDetailViewModel: TNViewModel {
    @Published var content: TNContentResponseBody
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let apiService: TNContentApiService

    init(content: TNContentResponseBody, apiService: TNContentApiService = TNContentApiService()) {
        self.content = content
        self.apiService = apiService
        super.init()
        bindLifecycle()
    }

    private func bindLifecycle() {
        lifeCycle.didAppearSubject
            .sink { [weak self] _ in Task { await self?.reloadContent() } }
            .store(in: &cancellables)
    }

    func reloadContent() async {
        guard let id = content.id else { return }
        let result = await apiService.getContent(id: id)
        await MainActor.run {
            switch result {
            case .success(let updated): self.content = updated
            case .failure: break
            }
        }
    }

    func onEditTapped() {
        stepper.send(.editContentRequired(content: content))
    }

    func deleteContent() async {
        guard let id = content.id else { return }
        await MainActor.run { isLoading = true }
        let result = await apiService.deleteContent(id: id)
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
}
