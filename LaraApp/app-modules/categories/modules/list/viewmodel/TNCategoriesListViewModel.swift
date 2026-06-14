//
//  TNCategoriesListViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/11.
//

import Combine

final class TNCategoriesListViewModel: TNViewModel {
    @Published var categories: [TNCategoryResponseBody] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let apiService: TNCategoryApiService
    
    init(apiService: TNCategoryApiService = TNCategoryApiService()) {
        self.apiService = apiService
        super.init()
        bindLifeCycle()
    }
    
    private func bindLifeCycle() {
        lifeCycle.didAppearSubject
            .sink { [weak self] _ in Task { await self?.loadCategories()}}
            .store(in: &cancellables)
    }
    
    func loadCategories() async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        let result = await apiService.getCategories()
        await MainActor.run {
            self.isLoading = false
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func onCategoryTapped(_ category: TNCategoryResponseBody) {
        stepper.send(.categoryDetailRequired(category: category))
    }
    
    func onCreateCategoryTapped() {
        stepper.send(.createCategoryRequired)
    }

    func onCategoryTabTapped() {
        stepper.send(.categoryTabRequired)
    }

    func onDateWiseCategoriesTapped() {
        stepper.send(.dateWiseCategoriesRequired)
    }

    func deleteCategory(id: Int) async {
        let result = await apiService.deleteCategory(id: id)
        await MainActor.run {
            switch result {
            case .success: categories.removeAll { $0.id == id }
            case .failure(let error):
                errorMessage = error.errorMessage
            }
        }
    }
}
