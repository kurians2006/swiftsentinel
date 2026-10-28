# SwiftSentinel 🛡️

> **The Intelligent Open-Source AI Agent Suite for iOS, Swift & SwiftUI Development, Security Auditing, and PR Review.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Swift: 6.0+](https://img.shields.io/badge/Swift-6.0%2B-orange.svg)](https://swift.org)
[![Platforms: iOS | macOS | watchOS | visionOS](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20visionOS-black.svg)](https://developer.apple.com)
[![Agent Skills Ready](https://img.shields.io/badge/Agent%20Skills-Compatible-success.svg)](https://skills.sh)

Generic LLMs struggle with the "Swift Problem": suggesting deprecated UIKit paradigms, bungling Swift 6 actor isolation, leaking memory through retain cycles in escaping closures, and overlooking Apple-specific security vulnerabilities.

**SwiftSentinel** solves this by providing curated, opinionated rules, specialized skills, and autonomous review agents built specifically for modern Apple platform engineering.

---

## 🌟 Key Capabilities

* **Modern Swift 6 & Concurrency**: Eliminates data races, enforces `Sendable` guarantees, validates `@MainActor` thread safety, and guides migration from older dispatch patterns.
* **SwiftUI Performance & Architecture**: Enforces clean state management using the iOS 17+ Observation framework (`@Observable`), eliminates render invalidation storms, and guarantees separation of concerns.
* **Apple Platform Security (OWASP MASVS)**: Audits Keychain accessibility, flags insecure `UserDefaults` usage, verifies App Transport Security (ATS), and protects biometric authentication logic.
* **Adversarial Threat Defense**: Detects runtime hooking/swizzling vectors (Frida/Cycript), enforces compiler devirtualization (`final`), and protects background screen snapshots in the iOS App Switcher.
* **Modern Swift Testing**: Enforces testing with Apple's modern `Swift Testing` framework (`@Test`, `#expect`, `@Suite`) over legacy `XCTestCase`.
* **Universal Agent Compatibility**: Installable via `npx skills`, usable across Antigravity, Cursor, Claude Code, and automated GitHub Actions.

---

## 🚀 Quick Start & Installation

### Option 1: Universal One-Line Install (`npx skills`)
Install directly into your agent environment using the open-source Agent Skills catalog:
```bash
# Add all skills to your project
npx skills add <your-github-username>/swiftsentinel --all
```

### Option 2: Use with Google Antigravity
Copy the skills from `packages/skills/` into your project's `.gemini/skills/` or your global Antigravity skills directory:
```bash
mkdir -p .gemini/skills
cp -r packages/skills/* .gemini/skills/
```

### Option 3: Use with Cursor
Copy the bundled rules into your `.cursorrules` or `.cursor/rules/`:
```bash
cat packages/rules/*.md > .cursorrules
```

### Option 4: Use with Claude Code
Import the skills directly into your project's `CLAUDE.md` or invoke them via local skill runners.

### Option 5: Automated GitHub Action (PR Code Review)
Add SwiftSentinel to your repository to automatically review every Pull Request:
```yaml
# .github/workflows/swiftsentinel-review.yml
name: "SwiftSentinel PR Review"

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - name: Run SwiftSentinel Review
        uses: ./packages/github-action
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
```

---

## 📁 Repository Structure

```text
swiftsentinel/
├── skills.json                  # Agent Skills catalog registry manifest
├── package.json                 # Node/npx metadata & test scripts
├── packages/
│   ├── rules/                   # Portable rules for all AI coding assistants
│   │   ├── swift6-concurrency.md
│   │   ├── swiftui-performance.md
│   │   ├── ios-security.md      # OWASP MASVS & Adversarial defense
│   │   └── swift-testing.md
│   ├── skills/                  # SKILL.md specs (Antigravity & Agent Skills format)
│   │   ├── ios-code-review/
│   │   ├── ios-security-audit/
│   │   └── swiftui-architect/
│   ├── agents/                  # Specialized subagent definitions
│   │   ├── ios-senior-reviewer.md
│   │   ├── ios-security-auditor.md
│   │   └── swiftui-architect.md
│   └── github-action/           # Automated PR review bot for CI/CD
│       ├── action.yml
│       └── src/review.js
└── examples/
    └── .cursorrules             # Ready-to-copy Cursor configuration
```

---

## 🛡️ Security & Quality Standards Enforced

SwiftSentinel audits against real-world Apple platform requirements:
1. **Concurrency**: Actor boundaries, `@MainActor` isolation, race conditions, Task cancellation handling.
2. **Memory Safety**: Escape closure retain cycle prevention (`[weak self]`), delegate weak references.
3. **Data Protection**: Strict Keychain access flags (`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`), prevention of logging sensitive credentials or tokens.
4. **Adversarial Resilience**: Static devirtualization, dynamic method swizzling protection, and App Switcher snapshot masking.
5. **SwiftUI State**: Prevention of expensive calculations in `body`, proper usage of `@State`, `@Binding`, `@Bindable`, and `@Query`.

---

## 🤝 Contributing

We welcome contributions! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) to learn how to add new rules, improve security heuristics, or extend support to new platforms.

## 📄 License

This project is open-source under the [MIT License](LICENSE).
