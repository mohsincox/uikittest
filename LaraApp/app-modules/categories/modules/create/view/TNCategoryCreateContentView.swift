//
//  TNCategoryCreateContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/18.
//

import SwiftUI

struct TNCategoryCreateContentView: View {
    @ObservedObject var viewModel: TNCategoryCreateViewModel
    
    var body: some View {
        VStack {
            TNNavBar(title: "Create Category", leadingButtonAction: viewModel.onBackTapped)
            ScrollView {
                TNTextField(title: "Name", placeholder: "Enter Category name", text: $viewModel.name)
                TNTextField(title: "Remark", placeholder: "Enter Category name", text: $viewModel.remark)
                TNCommonButton(title: viewModel.isLoading ? "Saving…" : "Save") {
                    Task { await viewModel.createCategory() }
                }
                
//                TNCommonButton(
//                                    title: viewModel.isLoading ? "Saving…" : "Save",
//                //                    isEnabled: viewModel.isValidInput && !viewModel.isLoading
//                                ) {
//                                    Task { await viewModel.createCategory() }
//                                }
            }
        }
    }
}
