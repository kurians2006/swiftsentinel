# SwiftLint & Semantic Linting Standards

This guide explains how **SwiftSentinel** works alongside **SwiftLint** to provide complete coverage: from syntax formatting to deep semantic architecture and security validation.

---

## 1. Static Linting (SwiftLint) vs Semantic Auditing (SwiftSentinel)

| Capability | SwiftLint (AST / Regex) | SwiftSentinel (AI Agent Engine) |
| :--- | :---: | :---: |
| Syntax formatting & line length | ✅ Native | ✅ Supported |
| Force unwrap detection (`!`) | ✅ Native | ✅ Native with contextual unwrapping advice |
| Unused imports detection | ✅ Native | ✅ Native |
| **Swift 6 Actor Isolation & Data Races** | ❌ Cannot infer cross-actor task bounds | ✅ Semantic analysis across types & tasks |
| **SwiftUI Render Re-evaluation Loops** | ❌ Cannot detect view dependency graphs | ✅ Detects state invalidation storms |
| **Memory Retain Cycles (`[weak self]`)** | ⚠️ Partial regex matching only | ✅ Deep closure lifetime analysis |
| **OWASP MASVS & Adversarial Defense** | ⚠️ Basic regex flags | ✅ Comprehensive threat modeling |
| **SOLID & Architectural Conformity** | ❌ Cannot evaluate design patterns | ✅ Validates MVVM, Clean Architecture & VIPER |

---

## 2. Integrated Rules Matrix

When reviewing Pull Requests, SwiftSentinel automatically runs a dual-pass evaluation:

### Pass 1: Syntax & Code Conventions
* Enforces `.swiftlint.yml` rules (no force unwraps, function complexity limits, type length limits).
* Cleans redundant parentheses, unused declarations, and trailing closures.

### Pass 2: Semantic Integrity Pass
* **Concurrency**: Validates that `@Observable` view models are `@MainActor`, verifies `Sendable` conformance on transferred payloads, and checks cooperative cancellation.
* **Security (OWASP MASVS)**: Audits Keychain accessibility flags, detects hardcoded API secrets, and checks for ATS exceptions.
* **Architecture**: Verifies Single Responsibility (SRP) and Dependency Inversion (DIP) with protocol injection.
