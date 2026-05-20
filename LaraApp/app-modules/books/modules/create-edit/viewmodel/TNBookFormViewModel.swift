//
//  TNBookFormViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/07.
//

import Foundation

final class TNBookFormViewModel: TNViewModel {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let apiService: TNBookApiService
    
    init(title: String, author: String, isLoading: Bool, errorMessage: String, apiService: TNBookApiService) {
        self.title = title
        self.author = author
        self.isLoading = isLoading
        self.errorMessage = errorMessage
        self.apiService = apiService
    }
    
    var screenTitle: String {
        "Book Form"
    }
    
    func save() async {
      await createPost()
    }

    private func createPost() async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.createBook(requestBody: TNCreateBookRequestBody(title: title, author: author))
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
}
