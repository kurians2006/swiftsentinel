# Modern Swift Testing Rules

This guide outlines standards for writing unit, integration, and UI tests using Apple's modern **Swift Testing** framework (introduced in Xcode 16 / Swift 6), replacing legacy `XCTest`.

---

## 1. Test Declaration & Structure

### Rule: Use `@Suite` and `@Test` instead of `XCTestCase`
* **Why**: The modern Swift Testing framework provides fine-grained test reporting, concurrency-safe parallel test execution, and macro-based assertions that display expressive diagnostics.
* **Bad**:
  ```swift
  // ❌ Legacy XCTestCase boilerplate
  import XCTest
  @testable import MyApp

  class OrderTests: XCTestCase {
      func testOrderCalculation() {
          let order = Order(price: 100, tax: 0.1)
          XCTAssertEqual(order.total, 110)
      }
  }
  ```
* **Good**:
  ```swift
  // ✅ Modern Swift Testing
  import Testing
  @testable import MyApp

  @Suite("Order Processing Suite")
  struct OrderTests {
      @Test("Calculates total order with sales tax")
      func orderCalculation() {
          let order = Order(price: 100, tax: 0.1)
          #expect(order.total == 110)
      }
  }
  ```

---

## 2. Assertions: `#expect` vs `#require`

### Rule: Use `#expect` for continuing assertions; use `try #require` for preconditions
* **Why**: `#expect` records a failure and continues test execution to capture all diagnostics. `#require` unwraps optionals and halts the current test immediately if a precondition is not met.
* **Example**:
  ```swift
  @Test func processPaymentPayload() throws {
      let response = try APIClient.mockResponse()
      
      // ✅ Halts if token is nil; unwraps securely
      let token = try #require(response.authToken)
      
      // ✅ Evaluates expectations without aborting early
      #expect(!token.isEmpty)
      #expect(response.status == .success)
  }
  ```

---

## 3. Parameterized Testing

### Rule: Prefer `@Test(arguments:)` over manual `for` loops
* **Why**: Parameterized tests run each argument as an independent test case, allowing individual retries and granular failure reporting.
* **Bad**:
  ```swift
  // ❌ Fails on the first item and stops testing the rest
  for input in ["user@test.com", "invalid-email", "admin@domain.org"] {
      XCTAssertTrue(isValid(input))
  }
  ```
* **Good**:
  ```swift
  // ✅ Each test case executes and reports independently
  @Test("Validates email patterns", arguments: [
      ("user@test.com", true),
      ("invalid-email", false),
      ("admin@domain.org", true)
  ])
  func emailValidation(email: String, expected: Bool) {
      #expect(isValid(email) == expected)
  }
  ```
