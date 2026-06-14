//
//  TNDateWiseCategoriesContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/06/14.
//

import SwiftUI

struct TNDateWiseCategoriesContentView: View {
    @ObservedObject var viewModel: TNDateWiseCategoriesViewModel

    var body: some View {
        VStack(spacing: 0) {
            TNNavBar(title: "Date Wise Categories",
                     leadingButtonAction: viewModel.onBackTapped,
                     menuButtonAction: viewModel.onMenuTapped)

            dateRangeRow
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

            Divider()

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.2)
                Spacer()
            } else if viewModel.categories.isEmpty {
                Spacer()
                Text("No categories found")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.categories) { category in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(category.name ?? "")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            Text(category.remark ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(Color(.systemBackground))
        .onAppear { viewModel.loadCategories() }
    }

    private var dateRangeRow: some View {
        HStack(spacing: 0) {
            Button {
                viewModel.onPreviousWeekTapped()
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 44, height: 44)
                    .foregroundColor(.primary)
            }

            Button {
                // date range tap — future: open date picker sheet
            } label: {
                Text(viewModel.dateRangeDisplayText)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }

            Button {
                viewModel.onNextWeekTapped()
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 44, height: 44)
                    .foregroundColor(.primary)
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}
