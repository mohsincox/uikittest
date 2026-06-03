//
//  TNCategoryTabContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/06/03.
//

import SwiftUI

struct TNCategoryTabContentView: View {
    @ObservedObject var viewModel: TNCategoryTabViewModel

    var body: some View {
        VStack(spacing: 0) {
            TNNavBar(title: "Categories",
                     leadingButtonAction: viewModel.onBackTapped,
                     menuButtonAction: viewModel.onMenuTapped)

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            } else if viewModel.categories.isEmpty {
                Spacer()
                Text("No categories available")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(viewModel.categories.enumerated()), id: \.element.id) { index, category in
                                Button {
                                    viewModel.selectCategory(at: index)
                                } label: {
                                    Text(category.name ?? "")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(viewModel.selectedCategoryIndex == index ? .white : .primary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(viewModel.selectedCategoryIndex == index ? Color.blue : Color(.systemGray5))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(Color(.systemBackground))

                    Divider()

                    if viewModel.isLoadingProducts {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Spacer()
                    } else if viewModel.products.isEmpty {
                        Spacer()
                        Text("No products in this category")
                            .foregroundColor(.secondary)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.products) { product in
                                    TNProductCard(product: product)
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

struct TNProductCard: View {
    let product: TNProductResponseBody

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(product.name ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
                if let price = product.price {
                    Text("$\(price, specifier: "%.2f")")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                }
            }

            if let description = product.description, !description.isEmpty {
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            if let categoryName = product.category?.name {
                Text("Category: \(categoryName)")
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