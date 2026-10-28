import SwiftUI

/// Clean SwiftUI View: Declarative, body is pure presentation, no direct network calls.
public struct UserProfileView: View {
    @State private var viewModel: UserProfileViewModel
    private let userId: String

    public init(viewModel: UserProfileViewModel, userId: String) {
        _viewModel = State(initialValue: viewModel)
        self.userId = userId
    }

    public var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView("Loading Profile...")
            } else if let user = viewModel.user {
                VStack(spacing: 8) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if user.isVerified {
                        Label("Verified Account", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    }
                }
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .task(id: userId) {
            await viewModel.loadProfile(userId: userId)
        }
    }
}
