# Swift 6 Concurrency & Actor Isolation Rules

This guide outlines mandatory rules for developing and reviewing Swift 6 code to prevent data races, actor isolation violations, and concurrency bugs.

---

## 1. Actor Isolation & `@MainActor`

### Rule: UI Updates & ViewModels MUST be `@MainActor`
* **Why**: Any state changes affecting SwiftUI views must occur on the main actor to prevent rendering artifacts or main-thread assertion failures.
* **Bad**:
  ```swift
  // ❌ Unisolated ViewModel can mutate state on background cooperative threads
  class UserProfileViewModel {
      var username: String = ""
      
      func fetchProfile() async {
          let user = await api.getUser()
          self.username = user.name // Race condition or background thread mutation!
      }
  }
  ```
* **Good**:
  ```swift
  // ✅ Explicitly isolated to MainActor
  @Observable
  @MainActor
  final class UserProfileViewModel {
      var username: String = ""
      
      func fetchProfile() async {
          let user = await api.getUser()
          self.username = user.name
      }
  }
  ```

---

## 2. `Sendable` Conformance & Data Boundaries

### Rule: Types passing across concurrency domains MUST be `Sendable`
* **Why**: Passing mutable reference types between actors or tasks leads to data races.
* **Bad**:
  ```swift
  // ❌ Mutable class passing across actor boundaries
  class OrderPayload {
      var items: [String] = []
  }
  
  actor OrderProcessor {
      func process(payload: OrderPayload) { ... }
  }
  ```
* **Good**:
  ```swift
  // ✅ Prefer immutable structs for cross-actor transfer
  struct OrderPayload: Sendable {
      let items: [String]
  }
  
  // ✅ If reference semantics are required, protect state with an Actor or unchecked Sendable with OSAllocatedUnfairLock
  actor OrderProcessor {
      func process(payload: OrderPayload) { ... }
  }
  ```

---

## 3. Structured Concurrency & Task Cancellation

### Rule: Cooperative Task Cancellation MUST be Checked
* **Why**: Long-running loops or tasks must honor cooperative cancellation (`Task.isCancelled` or `try Task.checkCancellation()`).
* **Bad**:
  ```swift
  // ❌ Ignores cancellation, keeps running even after user navigates away
  func processImages(_ images: [UIImage]) async -> [Data] {
      var results: [Data] = []
      for img in images {
          results.append(heavyCompression(img))
      }
      return results
  }
  ```
* **Good**:
  ```swift
  // ✅ Checks cancellation cooperatively
  func processImages(_ images: [UIImage]) async throws -> [Data] {
      var results: [Data] = []
      for img in images {
          try Task.checkCancellation()
          results.append(heavyCompression(img))
      }
      return results
  }
  ```

---

## 4. Retain Cycles in Async Tasks

### Rule: Capture `[weak self]` in Escaping Tasks or View Closures
* **Why**: Asynchronous tasks outliving views or controllers retain `self` until task completion, causing memory leaks.
* **Bad**:
  ```swift
  // ❌ Retains self indefinitely if network hangs
  Task {
      let data = try await networkService.download()
      self.items = data
  }
  ```
* **Good**:
  ```swift
  // ✅ Weak capture or scoped to .task(id:) in SwiftUI
  Task { [weak self] in
      guard let self else { return }
      let data = try? await networkService.download()
      self.items = data ?? []
  }
  ```
