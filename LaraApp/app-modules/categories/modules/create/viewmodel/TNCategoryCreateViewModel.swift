//
//  TNCategoryCreateViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/18.
//

import Foundation

final class TNCategoryCreateViewModel: TNViewModel {
    @Published var name: String = ""
    @Published var remark: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let apiService: TNCategoryApiService
    
    init(name: String, remark: String, isLoading: Bool, errorMessage: String, apiService: TNCategoryApiService) {
        self.name = name
        self.remark = remark
        self.isLoading = isLoading
        self.errorMessage = errorMessage
        self.apiService = apiService
    }
    
    func createCategory() async {
        await MainActor.run { isLoading = true; errorMessage = ""}
        let result = await apiService.createCategory(requestBody: TNCreateCategoryRequestBody(name: name, remark: remark))
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
            
        }
    }
}
