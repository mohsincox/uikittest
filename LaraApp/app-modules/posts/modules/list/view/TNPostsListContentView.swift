import SwiftUI

struct TNPostsListContentView: View {
    @ObservedObject var viewModel: TNPostsListViewModel

    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(title: "My Posts",
                     trailingButtonTitle: "Add",
                     trailingButtonAction: viewModel.onCreatePostTapped,
                     menuButtonAction: viewModel.onMenuTapped)
            content
        }
        .background(Color(.systemBackground))
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.posts.isEmpty {
            Spacer(); ProgressView(); Spacer()
        } else if viewModel.posts.isEmpty {
            emptyState
        } else {
            postsList
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "doc.text").font(.system(size: 48)).foregroundColor(.secondary)
            Text("No posts yet").font(.title3).foregroundColor(.secondary)
            Text("Tap Add to create your first post").font(.subheadline).foregroundColor(.secondary)
            Spacer()
        }
    }

    private var postsList: some View {
        List {
            ForEach(viewModel.posts) { post in
                TNPostRowView(post: post) { viewModel.onPostTapped(post) }
            }
            .onDelete { indexSet in
                indexSet.forEach { i in
                    if let id = viewModel.posts[i].id {
                        Task { await viewModel.deletePost(id: id) }
                    }
                }
            }
        }
        .listStyle(.plain)
        .refreshable { await viewModel.loadPosts() }
    }
}

struct TNPostRowView: View {
    let post: TNPostResponseBody
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                Text(post.title ?? "").font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary).lineLimit(1)
                Text(post.body ?? "").font(.subheadline)
                    .foregroundColor(.secondary).lineLimit(2)
            }
            .padding(.vertical, 4)
        }
    }
}
