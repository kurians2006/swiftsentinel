# GitHub Copilot Instructions for iOS & Swift

You are configured with the **SwiftSentinel** ruleset for Apple platform development.

## Guidelines
1. **Swift 6 Concurrency**: Enforce `@MainActor`, `Sendable`, and `@Observable` on all view models and UI state holders. Check for cooperative task cancellation.
2. **SwiftUI Performance**: Do not perform I/O, heavy transformations, or queries in view `body`. Use `.task(id:)` instead of `.onAppear`.
3. **Architecture**: Adhere to SOLID principles. Favor dependency injection with protocols over concrete singletons. Support MVVM, Clean Architecture, and VIPER.
4. **Security**: Require Keychain (`kSecClassGenericPassword`) for auth tokens. Flag any `UserDefaults` usage for secrets. Enforce `os.Logger` with `privacy: .private`.
5. **Swift Testing**: Use `@Suite`, `@Test`, `#expect`, and `#require` instead of legacy `XCTestCase`.
