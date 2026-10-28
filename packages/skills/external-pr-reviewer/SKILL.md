---
name: external-pr-reviewer
description: Reviews external GitHub Pull Requests (PRs), GitLab Merge Requests (MRs), and remote Git repositories. Fetches diffs, audits security, architecture (MVVM/VIPER/Clean/SOLID), Swift 6 concurrency, and SwiftLint rules.
---

# External PR & Repository Reviewer

This skill enables reviewing any external or third-party pull request, merge request, or remote repository without needing local project setup.

## Workflow for Reviewing a PR or MR URL

When a user provides a PR or MR URL (e.g. `https://github.com/owner/repo/pull/123` or `https://gitlab.com/owner/repo/-/merge_requests/42`):

### 1. Extract and Parse PR Metadata
- Parse repository owner, name, and pull request number.
- Fetch the PR diff using GitHub API or standard `.diff` / `.patch` format:
  ```bash
  curl -sSL "https://github.com/{owner}/{repo}/pull/{prNumber}.diff"
  ```
- Or using GitHub CLI if authenticated:
  ```bash
  gh pr diff {prNumber} --repo {owner}/{repo}
  ```

### 2. Multi-Dimensional Audit
Analyze every changed file against the four SwiftSentinel pillars:
1. **Swift 6 Concurrency**:
   - Check every ViewModel for `@MainActor`.
   - Check modified structs/classes for `Sendable` conformance.
   - Look for task isolation violations or missing `Task.isCancelled` checks.
2. **Memory Safety**:
   - Search for missing `[weak self]` in escaping asynchronous closures.
3. **Security (OWASP MASVS)**:
   - Search for `UserDefaults` used with credentials or tokens.
   - Inspect `Info.plist` changes for `NSAppTransportSecurity` exceptions.
   - Check for hardcoded API keys or unmasked logs.
4. **Architecture & SOLID**:
   - Check if view layer is contaminated with networking or business logic (violating SRP).
   - Check if concrete singletons are directly called instead of protocol injection (violating DIP).
   - Check consistency with target architecture (MVVM, Clean Architecture, or VIPER).
5. **SwiftLint Quality**:
   - Force unwraps (`!`), type body length, and trailing whitespace.

### 3. Generate High-Impact Review Report
Present the review in standard structured markdown:
- **PR Summary**: Short summary of what the PR accomplishes and files affected.
- **🚨 Critical Issues**: Concurrency data races, memory leaks, crash potentials, and security vulnerabilities.
- **⚠️ Warnings**: SOLID violations, state mismanagement, missing cancellation.
- **💡 Suggested Optimizations**: SwiftLint cleanup, modern Swift idioms, and test coverage recommendations.
- **Verdict**: `APPROVE`, `REQUEST_CHANGES`, or `COMMENT`.
