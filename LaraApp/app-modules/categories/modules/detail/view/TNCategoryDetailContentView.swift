//
//  TNCategoryDetailContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/14.
//

import SwiftUI

struct TNCategoryDetailContentView: View {
    @ObservedObject var viewModel: TNCategoryDetailViewModel
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        VStack {
            TNNavBar(title: "Category Detail",
                                 leadingButtonAction: viewModel.onBackTapped,
                                 trailingButtonTitle: "Edit",
                                 trailingButtonAction: viewModel.onEditTapped
            )
            ScrollView{
                VStack {
                    Text(viewModel.category.name ?? "")
                    Text(viewModel.category.remark ?? "")
                    Button(action: { showDeleteAlert = true }) {
                        Text("Delete Category")
                    }
                }
            }
        }
        .alert("Delete Category", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) { Task { await self.viewModel.deleteCategory() }}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this category?")
        }
    }
}
