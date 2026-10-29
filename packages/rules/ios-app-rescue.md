# iOS App Rescue & Health Check Rules (SwiftSentinel)

When auditing, debugging, or performing an App Health Check on an iOS (Swift/SwiftUI/ObjC) codebase, strictly adhere to the following inspection protocol:

## 1. Concurrency & Thread Safety Rules
- **Swift 6 & Concurrency Isolation:** Audit for data races across actor boundaries. Verify that all UI-mutating state changes (`@Published`, `@Observable`, `@State`) occur strictly on `@MainActor`.
- **Task Management:** Ensure un-awaited `Task {}` instances are cancelled when the enclosing view disappears (`.task` lifecycle modifier preferred over `onAppear { Task { ... } }`).
- **Throwing Errors:** Ensure async calls are properly wrapped with structured `try-catch` blocks; unhandled errors must never lead to fatal crashes or frozen loading spinners.

## 2. Memory & Retain Cycle Elimination
- **Closure Captures:** All escaping closures (`@escaping`) referencing `self` inside ViewModels, Coordinators, and Services must explicitly declare `[weak self]` unless lifetime is 100% deterministic.
- **SwiftUI State Retention:** Ensure `@StateObject` is initialized ONLY once at view hierarchy creation (never instantiated dynamically inside computed property bodies).
- **Instruments Target:** Recommend Profiling with `Product > Profile > Leaks & Allocations` for any flow where view models or hosting controllers persist after navigation pop.

## 3. SwiftUI Performance & Jank Prevention
- **View Body Purity:** `var body: some View` must contain purely declarative layout code. Heavy math, JSON decoding, sorting, and regex parsing must be moved to ViewModels or background actors.
- **Re-render Scope:** Avoid monolithic observable objects where a single rapid variable change (e.g. scroll offset, countdown timer) invalidates the entire screen. Split into localized `@Observable` models.
- **Stable Identifiers:** For `List` and `ForEach`, require models to conform to `Identifiable` with persistent, unique IDs (avoid `id: \.self` on mutable arrays).

## 4. Crash Prevention & Defensive Coding
- **Zero Force-Unwraps:** Eliminate `!` and `as!`. Replace with `guard let`, `if let`, `as?`, or default values with telemetry warnings.
- **Symbolication Readiness:** Verify that CI/CD produces and uploads dSYM files to Crashlytics / Sentry / App Store Connect.
- **Jetsam & Background Exits:** Check background tasks and memory footprints during high-resolution image loading; enforce downsampling (e.g. via ImageIO or Kingfisher/Nuke downsampling options).
