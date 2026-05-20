//
//  TNCategoryDetailViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/14.
//

import Foundation

final class TNCategoryDetailViewModel: TNViewModel {
    @Published var category: TNCategoryResponseBody
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let apiService: TNCategoryApiService
    
    
    
    init(category: TNCategoryResponseBody, apiService: TNCategoryApiService = TNCategoryApiService()) {
        self.category = category
        self.apiService = apiService
    }
    
    func deleteCategory() async {
        guard let id = category.id else { return }
        print(id)
        await MainActor.run { isLoading = true }
        let result = await apiService.deleteCategory(id: id)
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func onEditTapped() {
        stepper.send(.editCategoryRequired(category: category))
    }
}
