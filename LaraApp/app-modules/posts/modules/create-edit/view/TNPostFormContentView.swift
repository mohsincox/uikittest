import SwiftUI

struct TNPostFormContentView: View {
    @ObservedObject var viewModel: TNPostFormViewModel

    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(title: viewModel.screenTitle, leadingButtonAction: viewModel.onBackTapped)
            scrollableContent
        }
        .background(Color(.systemBackground))
        .onTapGesture { hideKeyboard() }
    }

    private var scrollableContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                TNTextField(title: "Title", placeholder: "Enter post title", text: $viewModel.title)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Body").font(.system(size: 14, weight: .medium)).foregroundColor(.secondary)
                    TextEditor(text: $viewModel.body)
                        .frame(minHeight: 160)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.subheadline).foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                TNCommonButton(
                    title: viewModel.isLoading ? "Saving…" : "Save",
                    isEnabled: viewModel.isValidInput && !viewModel.isLoading
                ) {
                    Task { await viewModel.save() }
                }
                .padding(.horizontal, -20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}
