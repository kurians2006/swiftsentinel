# iOS Architectures & SOLID Principles Guide

This guide establishes standards and evaluation criteria for **SOLID Principles**, **MVVM**, **VIPER**, and **Clean Architecture** in iOS and Swift codebases.

---

## 1. SOLID Principles in Swift

### S — Single Responsibility Principle (SRP)
* Every class, struct, or actor should have one and only one reason to change.
* **Anti-Pattern**: A `ViewController` or SwiftUI `View` that formats dates, executes network requests, and updates database records.
* **Best Practice**: Separate into a View (presentation), ViewModel/Presenter (state transformation), and Repository/UseCase (domain/data logic).

### O — Open/Closed Principle (OCP)
* Software entities should be open for extension, but closed for modification.
* **Swift Idiom**: Use protocol-oriented design and polymorphic extensions rather than large `switch-case` statements across hardcoded types.

### L — Liskov Substitution Principle (LSP)
* Subtypes must be substitutable for their base types without altering system correctness.
* **Swift Idiom**: Ensure protocol conformances satisfy expected behavioral contracts without crashing or throwing unexpected unsupported errors.

### I — Interface Segregation Principle (ISP)
* Clients should not be forced to depend upon interfaces they do not use.
* **Anti-Pattern**: A monolithic `DataManagerProtocol` with 30 methods for authentication, analytics, shopping cart, and payments.
* **Best Practice**: Split into role-specific, focused protocols:
  ```swift
  protocol UserProfileReadable: Sendable {
      func fetchProfile(id: String) async throws -> UserProfile
  }
  
  protocol UserProfileWritable: Sendable {
      func updateProfile(_ profile: UserProfile) async throws
  }
  ```

### D — Dependency Inversion Principle (DIP)
* High-level modules should not depend on low-level modules; both should depend on abstractions (protocols).
* **Anti-Pattern**: Direct references to concrete singletons like `NetworkService.shared`.
* **Best Practice**: Inject protocol abstractions via initializers:
  ```swift
  final class OrderViewModel {
      private let paymentService: PaymentProcessing
      
      init(paymentService: PaymentProcessing) {
          self.paymentService = paymentService
      }
  }
  ```

---

## 2. Supported Architectural Patterns

### Pattern A: Modern MVVM (Model-View-ViewModel)
* **View**: SwiftUI Declarative View observing the ViewModel.
* **ViewModel**: `@Observable @MainActor final class` holding UI state, exposing user actions, and calling domain use cases.
* **Model**: Immutable, `Sendable` domain structures.

### Pattern B: Clean Architecture
* **Presentation Layer**: SwiftUI Views + ViewModels/Presenters.
* **Domain Layer (Core)**:
  * **Entities**: Pure business data models independent of frameworks.
  * **Use Cases (Interactors)**: Execute specific business transactions (e.g. `CheckoutCartUseCase`).
  * **Repository Protocols**: Abstract interfaces for data access.
* **Data Layer**:
  * **Repository Implementations**: Coordinates local cache (SwiftData/Keychain) and remote network APIs.
  * **Data Sources**: Low-level `URLSession` clients and database contexts.

### Pattern C: VIPER (View, Interactor, Presenter, Entity, Router)
Ideal for large, modularized enterprise codebases requiring strict team boundaries:
1. **View**: Passive interface displaying formatted data and delegating user input to the Presenter.
2. **Interactor**: Contains business logic, queries repositories, and emits responses back to the Presenter.
3. **Presenter**: Coordinates UI logic, transforms domain entities into view-ready models, and commands the Router for navigation.
4. **Entity**: Simple data models.
5. **Router (Wireframe)**: Owns navigation transitions, initializes module dependencies, and pushes/presents destinations.
