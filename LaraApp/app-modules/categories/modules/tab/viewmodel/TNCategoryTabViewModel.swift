//
//  TNCategoryTabViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/06/03.
//

import Combine

final class TNCategoryTabViewModel: TNViewModel {
    @Published var categories: [TNCategoryResponseBody] = []
    @Published var products: [TNProductResponseBody] = []
    @Published var selectedCategoryIndex: Int = 0
    @Published var isLoading: Bool = false
    @Published var isLoadingProducts: Bool = false
    @Published var errorMessage: String = ""

    private let categoryApiService: TNCategoryApiService
    private let productApiService: TNProductApiService

    init(categoryApiService: TNCategoryApiService = TNCategoryApiService(),
         productApiService: TNProductApiService = TNProductApiService()) {
        self.categoryApiService = categoryApiService
        self.productApiService = productApiService
        super.init()
        bindLifeCycle()
    }

    private func bindLifeCycle() {
        lifeCycle.didAppearSubject
            .sink { [weak self] _ in Task { await self?.loadCategories() }}
            .store(in: &cancellables)
    }

    func loadCategories() async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        let result = await categoryApiService.getCategories()
        await MainActor.run {
            self.isLoading = false
            switch result {
            case .success(let categories):
                self.categories = categories
                if !categories.isEmpty {
                    self.selectedCategoryIndex = 0
                    Task {
                        await self.loadProductsForSelectedCategory()
                    }
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func selectCategory(at index: Int) {
        guard index >= 0 && index < categories.count else { return }
        selectedCategoryIndex = index
        Task {
            await loadProductsForSelectedCategory()
        }
    }

    private func loadProductsForSelectedCategory() async {
        guard selectedCategoryIndex < categories.count,
              let categoryId = categories[selectedCategoryIndex].id else { return }

        await MainActor.run {
            isLoadingProducts = true
        }

        let result = await productApiService.getProducts(categoryId: categoryId)

        await MainActor.run {
            self.isLoadingProducts = false
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}