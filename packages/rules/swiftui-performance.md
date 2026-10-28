# SwiftUI Architecture & Performance Rules

This guide outlines performance and architectural standards for modern SwiftUI applications (iOS 17+, macOS 14+).

---

## 1. Observation Framework (`@Observable`) vs Legacy `ObservableObject`

### Rule: Prefer `@Observable` over `ObservableObject`
* **Why**: The iOS 17+ Observation framework tracks property access granularly at the property level rather than re-evaluating the entire view hierarchy on any `@Published` change.
* **Bad**:
  ```swift
  // ❌ Inefficient re-renders of the whole view tree on any mutation
  class AppModel: ObservableObject {
      @Published var title: String = ""
      @Published var count: Int = 0
  }
  ```
* **Good**:
  ```swift
  // ✅ Precise, per-property dependency tracking
  @Observable
  @MainActor
  final class AppModel {
      var title: String = ""
      var count: Int = 0
  }
  ```

---

## 2. SwiftUI View Body Hygiene

### Rule: NEVER perform side-effects, network requests, or expensive computations in `body`
* **Why**: The SwiftUI runtime may evaluate the `body` property 60–120 times per second during animations or scrolling. Side-effects here cause CPU thrashing, battery drain, and visual glitches.
* **Bad**:
  ```swift
  struct ProductListView: View {
      var products: [Product]
      
      var body: some View {
          // ❌ Sorting or computing in body
          let sorted = products.sorted { $0.price < $1.price }
          
          List(sorted) { item in
              Text(item.name)
          }
      }
  }
  ```
* **Good**:
  ```swift
  struct ProductListView: View {
      var sortedProducts: [Product] // Pre-sorted in ViewModel or cached
      
      var body: some View {
          List(sortedProducts) { item in
              Text(item.name)
          }
      }
  }
  ```

---

## 3. Asynchronous Lifecycle with `.task`

### Rule: Use `.task(id:)` instead of `onAppear` for async loading
* **Why**: `.task` automatically handles cancellation when the view leaves the hierarchy, preventing orphaned background work.
* **Bad**:
  ```swift
  // ❌ onAppear requires manual task management and cancellation
  .onAppear {
      Task {
          await viewModel.fetch()
      }
  }
  ```
* **Good**:
  ```swift
  // ✅ Automatically cancelled when the view is dismissed
  .task(id: viewModel.selectedFilter) {
      await viewModel.fetch()
  }
  ```

---

## 4. Navigation Architecture

### Rule: Use `NavigationStack` with type-safe `navigationDestination(for:)`
* **Why**: Avoid deprecated `NavigationLink(destination:)` which instantiates destination views eagerly even before the user navigates.
* **Bad**:
  ```swift
  // ❌ Destination view is instantiated immediately in memory
  NavigationLink(destination: DetailView(id: item.id)) {
      Text(item.title)
  }
  ```
* **Good**:
  ```swift
  // ✅ Value-driven navigation destination instantiated lazily on tap
  NavigationLink(value: item) {
      Text(item.title)
  }
  .navigationDestination(for: Product.self) { product in
      DetailView(product: product)
  }
  ```
