import SwiftUI

struct TNRegisterContentView: View {
    @ObservedObject var viewModel: TNRegisterViewModel

    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(title: "Register", leadingButtonAction: viewModel.onBackTapped)
            scrollableContent
        }
        .background(Color(.systemBackground))
        .onTapGesture { hideKeyboard() }
    }

    private var scrollableContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                formSection
                if !viewModel.errorMessage.isEmpty { errorLabel }
                registerButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 64)).foregroundColor(.blue)
            Text("Create Account").font(.title2).fontWeight(.bold)
            Text("Sign up to get started").font(.subheadline).foregroundColor(.secondary)
        }
    }

    private var formSection: some View {
        VStack(spacing: 16) {
            TNTextField(title: "Full Name", placeholder: "Enter your name", text: $viewModel.name)
            TNTextField(title: "Email", placeholder: "Enter your email",
                        text: $viewModel.email, keyboardType: .emailAddress, autocapitalization: .never)
            TNSecureField(title: "Password", placeholder: "Min \(TNConstants.Auth.minimumPasswordLength) characters",
                          text: $viewModel.password)
        }
    }

    private var errorLabel: some View {
        Text(viewModel.errorMessage)
            .font(.subheadline).foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var registerButton: some View {
        TNCommonButton(
            title: viewModel.isLoading ? "Creating account…" : "Register",
            isEnabled: viewModel.isValidInput && !viewModel.isLoading
        ) {
            Task { await viewModel.register() }
        }
        .padding(.horizontal, -20)
    }
}
