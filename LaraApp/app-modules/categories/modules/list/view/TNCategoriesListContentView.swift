//
//  TNCategoriesListContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/11.
//

import SwiftUI

struct TNCategoriesListContentView: View {
    @ObservedObject var viewModel: TNCategoriesListViewModel
    
    var body: some View {
        VStack {
            TNNavBar(title: "Categories",
                                 trailingButtonTitle: "Add",
                     trailingButtonAction: viewModel.onCreateCategoryTapped,
                     menuButtonAction: viewModel.onMenuTapped)
            
            Button {
                viewModel.onCategoryTabTapped()
            } label: {
                Text("Category Tab Screen")
            }

            Button {
                viewModel.onDateWiseCategoriesTapped()
            } label: {
                Text("Date wise Categories")
            }
            
            List {
                            ForEach(viewModel.categories) { b in
                                Button {
                                    viewModel.onCategoryTapped(b)
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(b.name ?? "").font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.primary).lineLimit(1)
                                        Text(b.remark ?? "").font(.subheadline)
                                            .foregroundColor(.secondary).lineLimit(2)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .onDelete { indexSet in
                                indexSet.forEach { i in
                                    if let id = viewModel.categories[i].id {
                                        Task { await viewModel.deleteCategory(id: id) }
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .refreshable { await viewModel.loadCategories() }        }
        .background(Color(.systemBackground))
        
    }
}
