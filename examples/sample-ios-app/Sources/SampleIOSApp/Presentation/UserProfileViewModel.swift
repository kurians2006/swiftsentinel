import SwiftUI

/// MVVM ViewModel: Isolated to @MainActor, using the iOS 17+ Observation framework.
@Observable
@MainActor
public final class UserProfileViewModel {
    public var user: User?
    public var errorMessage: String?
    public var isLoading: Bool = false

    private let getUserUseCase: GetUserProfileUseCaseProtocol

    public init(getUserUseCase: GetUserProfileUseCaseProtocol) {
        self.getUserUseCase = getUserUseCase
    }

    public func loadProfile(userId: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            self.user = try await getUserUseCase.execute(userId: userId)
        } catch {
            self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
        }
    }
}
