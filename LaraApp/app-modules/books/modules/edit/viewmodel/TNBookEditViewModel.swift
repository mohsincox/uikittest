//
//  TNBookEditViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/11.
//

import Foundation

final class TNBookEditViewModel: TNViewModel {
    var screenTitle: String = "Book Edit Form"
    
    @Published var id: Int = 0
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let apiService: TNBookApiService
    
    init(id: Int, title: String, author: String, apiService: TNBookApiService) {
        self.id = id
        self.title = title
        self.author = author
        self.apiService = apiService
    }
    
    func update() async {
        await updateBook(id: id)
    }

    private func updateBook(id: Int) async {
        print("jjjjjjjjjjjjjjjjjjjjjjj------------------")
        print(id)
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.updateBook(id: id, requestBody: TNUpdateBookRequestBody(title: title, author: author))
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
}
