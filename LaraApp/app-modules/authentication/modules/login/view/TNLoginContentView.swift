import SwiftUI

struct TNLoginContentView: View {
    @ObservedObject var viewModel: TNLoginViewModel

    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(title: "Login")
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
                loginButton
                registerButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            Text("Welcome Back")
                .font(.title2).fontWeight(.bold)
            Text("Sign in to your account")
                .font(.subheadline).foregroundColor(.secondary)
        }
    }

    private var formSection: some View {
        VStack(spacing: 16) {
            TNTextField(title: "Email", placeholder: "Enter your email",
                        text: $viewModel.email, keyboardType: .emailAddress,
                        autocapitalization: .never)
            TNSecureField(title: "Password", placeholder: "Enter your password",
                          text: $viewModel.password)
        }
    }

    private var errorLabel: some View {
        Text(viewModel.errorMessage)
            .font(.subheadline).foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var loginButton: some View {
        TNCommonButton(
            title: viewModel.isLoading ? "Signing in…" : "Login",
            isEnabled: viewModel.isValidInput && !viewModel.isLoading
        ) {
            Task { await viewModel.login() }
        }
        .padding(.horizontal, -20)
    }

    private var registerButton: some View {
        Button("Don't have an account? Register") {
            viewModel.stepper.send(.registerRequired)
        }
        .font(.subheadline).foregroundColor(.blue)
    }
}
