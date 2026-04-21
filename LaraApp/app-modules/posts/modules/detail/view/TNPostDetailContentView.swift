import SwiftUI

struct TNPostDetailContentView: View {
    @ObservedObject var viewModel: TNPostDetailViewModel
    @State private var showDeleteAlert = false

    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(title: "Post Detail",
                     leadingButtonAction: viewModel.onBackTapped,
                     trailingButtonTitle: "Edit",
                     trailingButtonAction: viewModel.onEditTapped)
            content
        }
        .background(Color(.systemBackground))
        .alert("Delete Post", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) { Task { await viewModel.deletePost() } }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this post?")
        }
    }

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.post.title ?? "")
                    .font(.title2).fontWeight(.bold)
                Divider()
                Text(viewModel.post.body ?? "")
                    .font(.body).foregroundColor(.secondary)
                Spacer(minLength: 32)

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.subheadline).foregroundColor(.red)
                }

                Button(action: { showDeleteAlert = true }) {
                    Text("Delete Post")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity).frame(height: 52)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red, lineWidth: 1))
                }
            }
            .padding(20)
        }
    }
}
