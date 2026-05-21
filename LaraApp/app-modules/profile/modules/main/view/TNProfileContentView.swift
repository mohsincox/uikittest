import SwiftUI

struct TNProfileContentView: View {
    @ObservedObject var viewModel: TNProfileViewModel
    @State private var showLogoutAlert = false

    var body: some View {
        VStack(spacing: .zero) {
            TNNavBar(title: "Profile",
                     menuButtonAction: viewModel.onMenuTapped)
            content
        }
        .background(Color(.systemBackground))
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Logout", role: .destructive) { Task { await viewModel.logout() } }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to logout?")
        }
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: 24) {
                avatarSection
                userInfoSection
                Spacer(minLength: 32)
                logoutButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
        }
    }

    private var avatarSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            if !viewModel.userName.isEmpty {
                Text(viewModel.userName).font(.title2).fontWeight(.bold)
            }
            if !viewModel.userEmail.isEmpty {
                Text(viewModel.userEmail).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }

    private var userInfoSection: some View {
        VStack(spacing: 0) {
            infoRow(icon: "person", label: "Name", value: viewModel.userName)
            Divider().padding(.leading, 48)
            infoRow(icon: "envelope", label: "Email", value: viewModel.userEmail)
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundColor(.blue).frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.caption).foregroundColor(.secondary)
                Text(value.isEmpty ? "—" : value).font(.body)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var logoutButton: some View {
        Button(action: { showLogoutAlert = true }) {
            Text("Logout")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity).frame(height: 52)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red, lineWidth: 1))
        }
        .padding(.horizontal, 20)
    }
}
