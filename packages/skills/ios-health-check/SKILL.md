---
name: ios-health-check
description: >-
  Standardized technical investigation procedure for iOS apps (Swift/SwiftUI).
  Use to audit crash logs, memory leaks, concurrency races, view performance, and generate prioritized fix plans.
---

# iOS App Health Check Diagnostic Workflow

This skill guides SwiftSentinel through executing an introductory or retainer-level iOS App Health Check.

## Step 1: Scope Definition & Ingestion
1. Define the target scope:
   - Specific user flow (e.g. Onboarding, Payment flow, Feed scrolling, Background sync).
   - Problem statement (Crash on launch, Memory ballooning, UI stutter, Purple warnings).
2. Gather inputs:
   - Crash reports (MetricKit, Crashlytics stack trace, or `.ips` crash logs).
   - Target source code files (ViewModels, Views, Network/Repository layer).
   - Xcode diagnostics (Thread Sanitizer reports, Memory Graph exports).

## Step 2: 4-Pillar Technical Audit
Execute the audit across 4 dimensions:

### Pillar A: Crash Vectors & Thread Safety
- Audit async functions for non-main-thread UI mutations.
- Check forced unwraps (`!`) in decoders or network mapping.
- Verify Swift 6 strict concurrency checks if enabled.

### Pillar B: Memory & Lifecycle Integrity
- Inspect closures for missing `[weak self]` in escaping callbacks.
- Check `@StateObject` vs `@ObservedObject` initialization patterns.
- Check for deinitialization: verify `deinit { print("Deallocated") }` executes on view dismissal.

### Pillar C: Rendering Performance & UI Jank
- Evaluate SwiftUI view bodies for heavy calculations.
- Check `ForEach` identifier stability.
- Check image loading and caching mechanisms.

### Pillar D: Code Architecture & Maintainability
- Check separation of concerns (Business logic in View vs ViewModel/Service).
- Audit test coverage or testability of critical paths.

## Step 3: Synthesis & Fix Formulation
For every detected issue:
1. Assign priority:
   - **P0 - Critical**: Crashes, data loss, app store rejection risks.
   - **P1 - Major**: Memory leaks, noticeable frame drops (>16ms), battery drain.
   - **P2 - Moderate**: Non-blocking anti-patterns, deprecation warnings, missing unit tests.
2. Draft root-cause explanation.
3. Write production-ready Before & After code diff.
4. Document validation steps (Xcode Instruments steps or Unit test).

## Step 4: Deliverable Generation
Invoke `sentinel-report-generator` to compile the findings into the standardized Health Check report.
