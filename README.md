# SwiftSentinel 🛡️

> **The Universal Open-Source AI Agent Suite for iOS, Swift & SwiftUI Development, Security Auditing, and PR Review.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Swift: 6.0+](https://img.shields.io/badge/Swift-6.0%2B-orange.svg)](https://swift.org)
[![Platforms: iOS | macOS | watchOS | visionOS](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20visionOS-black.svg)](https://developer.apple.com)
[![Compatible With: Claude Code | Cursor | VS Code | Codex | Antigravity](https://img.shields.io/badge/Compatible%20With-Claude%20%7C%20Cursor%20%7C%20VS%20Code%20%7C%20Codex%20%7C%20Antigravity-purple.svg)](#-one-line-universal-installation)

Generic LLMs struggle with the "Swift Problem": suggesting deprecated UIKit paradigms, bungling Swift 6 actor isolation, leaking memory through retain cycles in escaping closures, and overlooking Apple-specific security vulnerabilities.

**SwiftSentinel** solves this by providing curated, opinionated rules, specialized skills, and autonomous review agents built specifically for modern Apple platform engineering across **any AI coding assistant**.

---

## ⚡ One-Line Universal Installation

Arm any iOS/Swift workspace in seconds:

### Option A: Universal Shell Installer (Recommended)
Installs configuration for **Claude Code, Cursor, VS Code Copilot, Windsurf, Codex, and Antigravity** in one shot:
```bash
curl -fsSL https://raw.githubusercontent.com/kurians2006/swiftsentinel/main/install.sh | bash
```

### Option B: Agent Skills Catalog (`npx skills`)
```bash
npx skills add kurians2006/swiftsentinel --all
```

---

## 💻 Platform Compatibility Matrix

| AI Assistant / IDE | How SwiftSentinel Integrates | Target Configuration |
| :--- | :--- | :--- |
| **Claude Code** (CLI) | Read automatically at root | `CLAUDE.md` & `skills.json` |
| **Claude (VS Code)** | Claude extension reads project instructions | `CLAUDE.md` |
| **Cursor** | Reads modern MDC & legacy rules | `.cursor/rules/*.mdc` & `.cursorrules` |
| **OpenAI Codex / Agents** | Universal open agent specification | `AGENTS.md` |
| **VS Code / GitHub Copilot** | Copilot project instructions | `.github/copilot-instructions.md` |
| **Windsurf (Cascade)** | Windsurf rules manifest | `.windsurfrules` |
| **Google Antigravity** | Native subagents and skills | `.gemini/skills/` & `.gemini/agents/` |
| **GitHub Actions / CI** | Automated PR review bot | `packages/github-action/action.yml` |

---

## 🌟 Key Capabilities

* **Modern Swift 6 & Strict Concurrency**: Eliminates data races, enforces `Sendable` guarantees, validates `@MainActor` thread safety, and guides migration from older dispatch patterns.
* **Architectures & SOLID Principles**: Enforces **Single Responsibility (SRP)**, **Interface Segregation (ISP)**, and **Dependency Inversion (DIP)**. Native support for **MVVM**, **Clean Architecture**, and **VIPER**.
* **SwiftUI Performance**: Enforces clean state management using the iOS 17+ Observation framework (`@Observable`), eliminates render invalidation storms, and guarantees separation of concerns.
* **Apple Platform Security (OWASP MASVS)**: Audits Keychain accessibility, flags insecure `UserDefaults` usage, verifies App Transport Security (ATS), and protects biometric authentication logic.
* **Adversarial Threat Defense**: Detects runtime hooking/swizzling vectors (Frida/Cycript), enforces compiler devirtualization (`final`), and protects background screen snapshots in the iOS App Switcher.
* **Modern Swift Testing**: Enforces testing with Apple's modern `Swift Testing` framework (`@Test`, `#expect`, `@Suite`) over legacy `XCTestCase`.

---

## 📁 Repository Structure

```text
swiftsentinel/
├── install.sh                   # Universal one-line installer script
├── CLAUDE.md                    # Claude Code & Claude VS Code manifest
├── AGENTS.md                    # OpenAI Codex & general agents manifest
├── .windsurfrules               # Windsurf Cascade configuration
├── skills.json                  # Agent Skills catalog registry manifest
├── package.json                 # Node/npx metadata & test scripts
├── .github/
│   └── copilot-instructions.md  # VS Code & GitHub Copilot instructions
├── .cursor/
│   └── rules/                   # Modern Cursor MDC rules
│       ├── swift6-concurrency.mdc
│       ├── swiftui-performance.mdc
│       ├── ios-security.mdc
│       └── ios-architectures-solid.mdc
├── packages/
│   ├── rules/                   # Portable rules documentation
│   ├── skills/                  # SKILL.md specs (Antigravity & Agent Skills)
│   ├── agents/                  # Subagent personas (Reviewer, Auditor, Architect)
│   └── github-action/           # Automated PR review bot for CI/CD
└── examples/
    ├── .cursorrules             # Legacy Cursor configuration
    └── sample-ios-app/          # Reference implementation (Clean Architecture, MVVM, VIPER)
```

---

## 🛡️ CI/CD: Automated GitHub Action (PR Review)

Add SwiftSentinel to your repository to automatically review every incoming Pull Request:

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

## 🤝 Contributing

We welcome contributions! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) to learn how to add new rules, improve security heuristics, or extend support to new platforms.

## 📄 License

This project is open-source under the [MIT License](LICENSE).
