//
//  TNBookFormContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/07.
//

import SwiftUI

struct TNBookFormContentView: View {
    @ObservedObject var viewModel: TNBookFormViewModel
    
    var body: some View {
        VStack {
            TNNavBar(title: viewModel.screenTitle, leadingButtonAction: viewModel.onBackTapped)
            ScrollView {
                TNTextField(title: "Title", placeholder: "Enter Book title", text: $viewModel.title)
                TNTextField(title: "Author", placeholder: "Enter Book Author", text: $viewModel.author)
                TNCommonButton(
                    title: viewModel.isLoading ? "Saving…" : "Save",
//                    isEnabled: viewModel.isValidInput && !viewModel.isLoading
                ) {
                    Task { await viewModel.save() }
                }
                .padding(.horizontal, -20)
            }
        }
    }
}

#Preview {
    TNBookFormContentView(viewModel: TNBookFormViewModel(title: "", author: "", isLoading: false, errorMessage: "", apiService: TNBookApiService()))
}
