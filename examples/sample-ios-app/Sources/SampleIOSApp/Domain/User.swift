import Foundation

/// Domain Entity conforming to Sendable for Swift 6 Concurrency safety
public struct User: Sendable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let email: String
    public let isVerified: Bool

    public init(id: String, name: String, email: String, isVerified: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.isVerified = isVerified
    }
}
