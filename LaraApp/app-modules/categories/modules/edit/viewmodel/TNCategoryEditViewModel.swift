//
//  TNCategoryEditViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/19.
//

import Foundation

final class TNCategoryEditViewModel: TNViewModel {
    @Published var id: Int = 0
    @Published var name: String = ""
    @Published var remark: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = ""
    
    private let apiService: TNCategoryApiService
    
    init(id: Int, name: String, remark: String, apiService: TNCategoryApiService) {
        self.id = id
        self.name = name
        self.remark = remark
        self.apiService = apiService
    }
    
    func updateCategory(id: Int) async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        let result = await apiService.updateCategory(id: id, requestBody: TNUpdateCategoryRequestBody(name: name, remark: remark))
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
