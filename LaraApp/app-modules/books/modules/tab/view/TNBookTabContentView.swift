//
//  TNBookTabContentView.swift
//  LaraApp
//
//  Created by TN-LAP-0134 on 10/6/26.
//

import SwiftUI

struct TNBookTabContentView: View {
    @ObservedObject var viewModel: TNBookTabViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            TNNavBar(title: "Books",
                     leadingButtonAction: viewModel.onBackTapped,
                     menuButtonAction: viewModel.onMenuTapped)
            
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            } else if viewModel.books.isEmpty {
                Spacer()
                Text("No books available")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(viewModel.books.enumerated()), id: \.element.id) { index, category in
                                Button {
                                    viewModel.selectBook(at: index)
                                } label: {
                                    Text(category.title ?? "")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(viewModel.selectedBookIndex == index ? .white : .primary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(viewModel.selectedBookIndex == index ? Color.blue : Color(.systemGray5))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(Color(.systemBackground))
                    
                    Divider()
                    
                    if viewModel.isLoadingChapters {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Spacer()
                    } else if viewModel.chapters.isEmpty {
                        Spacer()
                        Text("No chapter in this book")
                            .foregroundColor(.secondary)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.chapters) { product in
                                    TNChapterCard(product: product)
                                }
                            }
                            .padding(16)
                        }
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

struct TNChapterCard: View {
    let product: TNChapterResponseBody

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(product.name ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
               
            }

            if let description = product.content, !description.isEmpty {
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            if let categoryName = product.book?.title {
                Text("Book: \(categoryName)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}
