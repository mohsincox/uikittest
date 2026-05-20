//
//  TNBookEditContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/11.
//

import SwiftUI

struct TNBookEditContentView: View {
    @ObservedObject var viewModel: TNBookEditViewModel
    
    var body: some View {
        VStack {
            TNNavBar(title: viewModel.screenTitle, leadingButtonAction: viewModel.onBackTapped)
            ScrollView {
                TNTextField(title: "Title", placeholder: "Enter Book title", text: $viewModel.title)
                TNTextField(title: "Author", placeholder: "Enter Book Author", text: $viewModel.author)
                TNCommonButton(
                    title: viewModel.isLoading ? "Updating…" : "Update",
//                    isEnabled: viewModel.isValidInput && !viewModel.isLoading
                ) {
                    Task { await viewModel.update() }
                }
                .padding(.horizontal, -20)
            }
        }
    }
}

#Preview {
    TNBookEditContentView(viewModel: TNBookEditViewModel(id: 44, title: "jjj", author: "KKK", apiService: TNBookApiService()))
}
    
