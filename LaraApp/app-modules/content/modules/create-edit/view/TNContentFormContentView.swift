//
//  TNContentFormContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

import SwiftUI

struct TNContentFormContentView: View {
    @ObservedObject var viewModel: TNContentFormViewModel

    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(title: viewModel.screenTitle, leadingButtonAction: viewModel.onBackTapped)
            scrollableContent
            
        }
        .background(Color(.systemBackground))
        .onTapGesture { hideKeyboard() }
    }

    private var scrollableContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                TNTextField(title: "Title", placeholder: "Enter post title", text: $viewModel.title)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Body").font(.system(size: 14, weight: .medium)).foregroundColor(.secondary)
                    TextEditor(text: $viewModel.contentDescription)
                        .frame(minHeight: 160)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                
                TNCommonButton(
                    title: viewModel.isLoading ? "Saving…" : "Save",
//                    isEnabled: viewModel.isValidInput && !viewModel.isLoading
                ) {
                    Task { await viewModel.save() }
                }
                .padding(.horizontal, -20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
}

#Preview("Create") {
    TNContentFormContentView(viewModel: TNContentFormViewModel(mode: .create))
}

#Preview("Edit") {
    let mockContent = TNContentResponseBody(id: 1, userId: 1, title: "Sample Title", description: "Sample description text.", createdAt: nil, updatedAt: nil)
    return TNContentFormContentView(viewModel: TNContentFormViewModel(mode: .edit(content: mockContent)))
}
