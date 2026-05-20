//
//  TNCategoryEditContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/19.
//

import SwiftUI

struct TNCategoryEditContentView: View {
    @ObservedObject var viewModel: TNCategoryEditViewModel
    
    var body: some View {
        VStack {
            TNNavBar(title: "Edit Category", leadingButtonAction: viewModel.onBackTapped)
            ScrollView {
                TNTextField(title: "Category Name", placeholder: "Enter Category Name", text: $viewModel.name)
                TNTextField(title: "Category Remark", placeholder: "Enter Category Remark", text: $viewModel.remark)
                TNCommonButton(title: viewModel.isLoading ? "Updating…" : "Update") {
                    Task {
                        await viewModel.updateCategory(id: viewModel.id)
                    }
                }
            }
            
        }
    }
}
