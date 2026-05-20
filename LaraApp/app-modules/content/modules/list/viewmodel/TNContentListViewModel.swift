//
//  TNContentListViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

import Foundation
import Combine

final class TNContentListViewModel: TNViewModel {
    @Published var contents: [TNContentResponseBody] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let apiService: TNContentApiService

    init(apiService: TNContentApiService = TNContentApiService()) {
        self.apiService = apiService
        super.init()
        bindLifecycle()
    }

    private func bindLifecycle() {
        lifeCycle.didAppearSubject
            .sink { [weak self] _ in Task { await self?.loadContents() } }
            .store(in: &cancellables)
    }

    func loadContents() async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.getContents()
        await MainActor.run {
            isLoading = false
            switch result {
            case .success(let contents): self.contents = contents
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }

    func deleteContent(id: Int) async {
        let result = await apiService.deleteContent(id: id)
        await MainActor.run {
            switch result {
            case .success: contents.removeAll { $0.id == id }
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }

    func onContentTapped(_ post: TNContentResponseBody) {
        stepper.send(.contentDetailRequired(content: post))
    }

    func onCreateContentTapped() {
        stepper.send(.createContentRequired)
    }
}
