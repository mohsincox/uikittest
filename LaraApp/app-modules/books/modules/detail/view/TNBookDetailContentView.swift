//
//  TNBookDetailContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/05.
//

import SwiftUI

struct TNBookDetailContentView: View {
    @ObservedObject var viewModel: TNBookDetailViewModel
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack {
            TNNavBar(title: "Book Detail",
                     leadingButtonAction: viewModel.onBackTapped,
                     trailingButtonTitle: "Edit",
                     trailingButtonAction: viewModel.onEditTapped)
            ScrollView {
                VStack(spacing: .zero) {
                    Text(viewModel.book.title ?? "")
                    Text(viewModel.book.author ?? "")
                    Button(action: { showDeleteAlert = true }) {
                        Text("Delete Book")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red, lineWidth: 1))
                    }
                }
                .background(Color(.systemBackground))
            }
        }
        .alert("Delete Post", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) { Task { await viewModel.deletePost() } }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this post?")
        }
    }
}
