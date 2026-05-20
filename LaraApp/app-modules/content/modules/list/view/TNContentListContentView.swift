//
//  TNContentListContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//


import SwiftUI

struct TNContentListContentView: View {
    @ObservedObject var viewModel: TNContentListViewModel

    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(title: "My Contents",
                     trailingButtonTitle: "Add"
                     ,
                     trailingButtonAction: viewModel.onCreateContentTapped
            )
            content
        }
        .background(Color(.systemBackground))
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.contents.isEmpty {
            Spacer(); ProgressView(); Spacer()
        } else if viewModel.contents.isEmpty {
            emptyState
        } else {
            contentsList
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "doc.text").font(.system(size: 48)).foregroundColor(.secondary)
            Text("No content yet").font(.title3).foregroundColor(.secondary)
            Text("Tap Add to create your first content").font(.subheadline).foregroundColor(.secondary)
            Spacer()
        }
    }

    private var contentsList: some View {
        List {
            ForEach(viewModel.contents) { post in
                TNContentRowView(content: post) {
                    viewModel.onContentTapped(post)
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { i in
                    if let id = viewModel.contents[i].id {
                        Task { await viewModel.deleteContent(id: id) }
                    }
                }
            }
        }
        .listStyle(.plain)
//        .refreshable { await viewModel.loadPosts() }
    }
}

struct TNContentRowView: View {
    let content: TNContentResponseBody
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                Text(content.title ?? "").font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary).lineLimit(1)
                Text(content.description ?? "").font(.subheadline)
                    .foregroundColor(.secondary).lineLimit(2)
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview("Empty State") {
    TNContentListContentView(viewModel: TNContentListViewModel())
}

#Preview("With Contents") {
    let vm = TNContentListViewModel()
    vm.contents = [
        TNContentResponseBody(id: 1, userId: 1, title: "First Content", description: "This is the first content description.", createdAt: nil, updatedAt: nil),
        TNContentResponseBody(id: 2, userId: 1, title: "Second Content", description: "Another content item with a longer description text here.", createdAt: nil, updatedAt: nil),
        TNContentResponseBody(id: 3, userId: 1, title: "Third Content", description: "Short desc.", createdAt: nil, updatedAt: nil)
    ]
    return TNContentListContentView(viewModel: vm)
}
