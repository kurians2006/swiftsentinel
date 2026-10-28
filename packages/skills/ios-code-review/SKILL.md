---
name: ios-code-review
description: Audits and reviews iOS, Swift, and SwiftUI pull requests, git diffs, and source files. Detects Swift 6 concurrency race conditions, memory leaks, SwiftUI performance traps, and architectural anti-patterns.
---

# iOS Code Review Specialist

This skill guides a deep, production-grade code review of Apple platform codebases (iOS, iPadOS, macOS, watchOS, visionOS).

## When to Run This Skill
- When reviewing a Pull Request (PR) or `git diff` for an iOS/Swift project.
- When performing a pre-commit quality check on staged changes.
- When an engineer requests an architectural review of a Swift or SwiftUI component.

---

## Review Process & Methodology

### Step 1: Concurrency & Actor Isolation Verification
1. **ViewModel Annotation**: Ensure any class managing UI state is marked with `@MainActor` and `@Observable`.
2. **Cross-Actor Boundaries**: Ensure all data models passed across asynchronous task boundaries conform to `Sendable`.
3. **Structured Concurrency**: Ensure non-cooperative background tasks check `Task.isCancelled` or `try Task.checkCancellation()`.

### Step 2: Memory Leak & Retain Cycle Detection
1. **Escaping Closures**: Search for escaping closures, Combine subscriptions, or unmanaged `Task` blocks referencing `self`. Verify `[weak self]` capture.
2. **Delegate Patterns**: Verify that any `delegate` property on protocols is declared `weak`.
3. **Notifications & Observers**: Verify observers clean up properly or use modern async streams (`NotificationCenter.default.notifications(named:)`).

### Step 3: SwiftUI Performance & State Hygiene
1. **Body Purity**: Inspect `body` to ensure zero database fetches, network calls, sorting operations, or heavy date formatters occur inside view declarations.
2. **Lifecycle Handlers**: Ensure `.task(id:)` is preferred over `.onAppear` for asynchronous operations.
3. **Lazy Rendering**: Verify `LazyVStack` / `LazyHStack` is used within scrolling containers when items exceed 20 elements.

### Step 4: Architectural & SOLID Principles Validation
1. **Single Responsibility (SRP)**: Check that Views don't perform API calls or database operations directly.
2. **Dependency Inversion (DIP)**: Check that classes depend on protocol abstractions rather than concrete singletons (e.g. inject `APIClientProtocol` instead of calling `APIClient.shared`).
3. **Pattern Consistency**: Ensure consistency with the target architecture (MVVM, Clean Architecture, or VIPER) across all modified files.

### Step 5: Formatting the Output Report

Always format review feedback in standardized tiers:

```markdown
### 🚨 Critical / Blocker
- **Issue**: [Description of race condition, crash risk, or memory leak]
- **File & Line**: `Path/To/File.swift#L24`
- **Suggested Fix**:
  ```swift
  // Code snippet showing the recommended resolution
  ```

### ⚠️ Warning / Best Practice
- **Issue**: [SwiftUI state misuse or deprecated pattern]
- **Recommendation**: [Clear reasoning with modern Swift alternative]

### 💡 Optimization & Idiomatic Swift
- **Issue**: [Style, readability, or micro-optimization]
- **Recommendation**: [Modern Swift idiom, e.g., Swift Testing macro or if-let shorthand]
```
