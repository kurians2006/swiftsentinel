---
name: swiftui-architect
description: Guides the design, implementation, and refactoring of modern iOS architectures including MVVM, VIPER, Clean Architecture, and SOLID principles using Swift 6, SwiftUI, SwiftData, and NavigationStack.
---

# SwiftUI & iOS Architecture Specialist

This skill guides the scaffolding, evaluation, and refactoring of maintainable, high-performance iOS architectures adhering to SOLID principles.

## Supported Architectural Paradigms

1. **Modern MVVM (Model-View-ViewModel)**:
   - Thin declarative SwiftUI Views.
   - `@Observable @MainActor` ViewModels managing presentation state.
   - Decoupled repositories and domain services injected via initializers.

2. **Clean Architecture**:
   - **Domain Layer**: Framework-independent Entities, pure UseCases/Interactors, and abstract repository contracts.
   - **Data Layer**: Concrete repository implementations coordinating remote network and local cache.
   - **Presentation Layer**: Thin views driven by UseCases via ViewModels.

3. **VIPER (View, Interactor, Presenter, Entity, Router)**:
   - Strict separation for large enterprise apps: View delegates user intent to Presenter; Presenter invokes Interactor; Interactor returns domain models; Presenter delegates navigation to Router.

4. **SOLID Principles Enforcement**:
   - **Single Responsibility (SRP)**: View bodies only describe UI layout; business logic lives in UseCases/Interactors.
   - **Interface Segregation (ISP)**: Segregated, role-specific protocols.
   - **Dependency Inversion (DIP)**: No concrete singleton dependencies; all external services injected via protocols.

1. **State Isolation**:
   - Keep views thin and declarative.
   - Use `@Observable` classes marked with `@MainActor` for feature view models.
   - Use `@State` strictly for local view-ephemeral state (e.g. `isSheetPresented`, animation flags).
   - Use `@Bindable` when creating two-way bindings to properties of an `@Observable` model.

2. **Data Flow**:
   - For persistence, prefer **SwiftData** (`@Model`, `@Query`, `ModelContainer`) over raw Core Data when targeting iOS 17+.
   - Keep query logic decoupled; provide mock model contexts for SwiftUI previews.

3. **Modern Navigation**:
   - Always use `NavigationStack(path:)` for stack-based navigation.
   - Make all route models conform to `Hashable` and `Codable` for deep-linking support.
   - Attach `.navigationDestination(for: Route.self)` at the root container level.

4. **Testing Architecture**:
   - Ensure ViewModels accept protocol-based or struct-based dependencies (e.g., API clients, persistence services).
   - Author corresponding unit tests using the modern **Swift Testing** framework (`@Suite`, `@Test`, `#expect`).
