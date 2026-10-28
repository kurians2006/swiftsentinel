import Foundation

/// Interface Segregation Principle (ISP) & Dependency Inversion Principle (DIP):
/// Segregated, thread-safe protocol abstraction for User data operations.
public protocol UserReadableRepository: Sendable {
    func getUser(id: String) async throws -> User
}

public protocol UserWritableRepository: Sendable {
    func saveUser(_ user: User) async throws
}
