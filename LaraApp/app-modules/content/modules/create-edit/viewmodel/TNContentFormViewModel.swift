//
//  TNContentFormViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

import Foundation

enum TNContentFormMode {
    case create
    case edit(content: TNContentResponseBody)
}

final class TNContentFormViewModel: TNViewModel {
    @Published var title: String = ""
    @Published var contentDescription: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    let mode: TNContentFormMode
    private let apiService: TNContentApiService

    var screenTitle: String {
        if case .create = mode { return "New Content" }
        return "Edit Content"
    }
    
    init(mode: TNContentFormMode, apiService: TNContentApiService = TNContentApiService()) {
        self.mode = mode
        self.apiService = apiService
        super.init()
        if case .edit(let post) = mode {
            title = post.title ?? ""
            contentDescription = post.description ?? ""
        }
    }
    
    func save() async {
//        await createContent()
        switch mode {
        case .create: await createContent()
        case .edit(let post):
            if let id = post.id { await updateContent(id: id) }
        }
    }
    
    private func createContent() async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.createContent(requestBody: TNCreateContentRequestBody(title: title, description: contentDescription))
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
    
    private func updateContent(id: Int) async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        let result = await apiService.updateContent(id: id, requestBody: TNUpdateContentRequestBody(title: title, description: contentDescription))
        await MainActor.run {
            isLoading = false
            switch result {
            case .success: stepper.send(.popRequired)
            case .failure(let error): errorMessage = error.errorMessage
            }
        }
    }
}
