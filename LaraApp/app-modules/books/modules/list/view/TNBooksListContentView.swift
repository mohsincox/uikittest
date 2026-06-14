//
//  TNBooksListContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/03.
//

import SwiftUI

struct TNBooksListContentView: View {
    @ObservedObject var viewModel: TNBooksListViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(title: "My Books",
                     trailingButtonTitle: "Add",
                     trailingButtonAction: viewModel.onCreateBookTapped,
                     menuButtonAction: viewModel.onMenuTapped)
            
            Button {
                viewModel.onBookTabTapped()
            } label: {
                Text("Book Tab Screen")
            }
            
            List {
                ForEach(viewModel.books) { b in
                    Button {
                        viewModel.onBookTapped(b)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(b.title ?? "").font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary).lineLimit(1)
                            Text(b.author ?? "").font(.subheadline)
                                .foregroundColor(.secondary).lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { i in
                        if let id = viewModel.books[i].id {
                            Task { await viewModel.deleteBook(id: id) }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .refreshable { await viewModel.loadBooks() }
        }
        .background(Color(.systemBackground))
    }
}
