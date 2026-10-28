import Foundation

/// Clean Architecture Use Case enforcing Single Responsibility Principle (SRP).
public protocol GetUserProfileUseCaseProtocol: Sendable {
    func execute(userId: String) async throws -> User
}

public final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    private let repository: UserReadableRepository

    public init(repository: UserReadableRepository) {
        self.repository = repository
    }

    public func execute(userId: String) async throws -> User {
        guard !userId.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw UserDomainError.invalidUserId
        }
        return try await repository.getUser(id: userId)
    }
}

public enum UserDomainError: Error, Equatable {
    case invalidUserId
    case userNotFound
}
