# SwiftSentinel Agent Manifest

This repository and projects using SwiftSentinel adhere to the following standards across all AI agents (Codex, Claude, Cursor, Antigravity):

## Tech Stack & Targets
- **Language**: Swift 6.0+ (Strict Concurrency enabled)
- **Frameworks**: SwiftUI (iOS 17+), SwiftData, Swift Testing (`import Testing`)
- **Architectures**: SOLID principles, MVVM, Clean Architecture, VIPER
- **Security Standard**: OWASP Mobile Application Security Verification Standard (MASVS)

## Coding Standards

### Concurrency
- All UI-bound models must be isolated with `@MainActor` and marked `@Observable`.
- Use `Sendable` value types across async tasks; no unsynchronized mutable classes.
- Honor task cancellation cooperatively with `Task.isCancelled` or `try Task.checkCancellation()`.
- Use `[weak self]` in escaping closures and notifications to avoid retain cycles.

### SwiftUI
- Keep `body` pure and declarative; avoid expensive calculations or side-effects inside view bodies.
- Use `.task(id:)` instead of `.onAppear`.
- Use type-safe `NavigationStack` with `navigationDestination(for:)`.

### Security
- Store tokens, passwords, and sensitive keys strictly in Keychain (`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`).
- Do not disable App Transport Security (`NSAllowsArbitraryLoads`).
- Do not output credentials in `print()` statements; use `os.Logger` with `privacy: .private`.
- Devirtualize sensitive methods (`final`) to prevent dynamic runtime swizzling.

### Testing
- Author test suites using `@Suite` and `@Test` from Apple's modern Swift Testing framework.
- Use `#expect` for non-halting checks and `try #require` for preconditions.
