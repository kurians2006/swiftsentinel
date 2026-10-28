import Testing
@testable import SampleIOSApp

// Mock repository satisfying Sendable & DIP
final class MockUserRepository: UserReadableRepository, @unchecked Sendable {
    var stubbedUser: User?
    var shouldFail: Bool = false

    func getUser(id: String) async throws -> User {
        if shouldFail {
            throw UserDomainError.userNotFound
        }
        guard let stubbedUser else {
            throw UserDomainError.userNotFound
        }
        return stubbedUser
    }
}

@Suite("User Profile Domain & MVVM Suite")
struct UserProfileTests {

    @Test("Clean Architecture UseCase returns user successfully")
    func getUserProfileSuccess() async throws {
        let repo = MockUserRepository()
        let expectedUser = User(id: "usr_123", name: "Naeem", email: "naeem@example.com", isVerified: true)
        repo.stubbedUser = expectedUser

        let useCase = GetUserProfileUseCase(repository: repo)
        let result = try await useCase.execute(userId: "usr_123")

        #expect(result.id == "usr_123")
        #expect(result.name == "Naeem")
        #expect(result.isVerified == true)
    }

    @Test("Clean Architecture UseCase throws error for empty ID")
    func getUserProfileEmptyIdThrows() async {
        let repo = MockUserRepository()
        let useCase = GetUserProfileUseCase(repository: repo)

        await #expect(throws: UserDomainError.invalidUserId) {
            try await useCase.execute(userId: "   ")
        }
    }

    @Test("MVVM ViewModel loads user and updates state on @MainActor")
    @MainActor
    func viewModelLoadsState() async {
        let repo = MockUserRepository()
        let expectedUser = User(id: "usr_456", name: "Paracha", email: "paracha@example.com", isVerified: false)
        repo.stubbedUser = expectedUser

        let useCase = GetUserProfileUseCase(repository: repo)
        let viewModel = UserProfileViewModel(getUserUseCase: useCase)

        await viewModel.loadProfile(userId: "usr_456")

        #expect(viewModel.user?.name == "Paracha")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
}
