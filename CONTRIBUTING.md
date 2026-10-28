# Contributing to SwiftSentinel

Thank you for your interest in making **SwiftSentinel** the standard open-source AI agent suite for iOS and Apple platform developers!

---

## Areas You Can Contribute

1. **Rule Packages (`packages/rules/`)**:
   - Add new Swift 6 patterns, SwiftData optimizations, or VisionOS-specific rules.
   - Provide concrete **Bad** (anti-pattern) and **Good** (recommended) code examples.
2. **Skills (`packages/skills/`)**:
   - Enhance the review checklists for specialized frameworks (e.g. HealthKit, CoreBluetooth, StoreKit 2).
3. **GitHub Action (`packages/github-action/`)**:
   - Improve PR inline comment diff matching and multi-provider LLM support.
4. **Benchmarks (`examples/`)**:
   - Add sample projects with deliberate anti-patterns to verify that the agent catches them accurately.

---

## Rule Guidelines

When writing or updating a rule:
* Ground recommendations in **official Apple documentation** and **Swift Evolution proposals**.
* Keep explanations concise, unambiguous, and immediately actionable.
* Ensure code snippets compile with the latest Swift toolchain.

---

## Submitting Pull Requests

1. Fork the repository and create your feature branch:
   ```bash
   git checkout -b feature/new-rule
   ```
2. Commit your changes with descriptive messages:
   ```bash
   git commit -m "feat(rules): add StoreKit 2 transaction verification rules"
   ```
3. Push to your branch and open a Pull Request.
