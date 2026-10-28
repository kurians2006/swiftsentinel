---
name: ios-security-audit
description: Audits iOS applications for security vulnerabilities, OWASP Mobile Top 10 risks, insecure Keychain usage, ATS exceptions, biometric bypasses, and adversarial tampering vectors.
---

# iOS Security & Privacy Auditor

This skill performs rigorous static analysis and security auditing of iOS projects against the **OWASP Mobile Application Security Verification Standard (MASVS)** and adversarial mobile threat vectors.

## Audit Workflow

### Step 1: Storage & Credential Verification (MASVS-STORAGE)
1. Search codebase for `UserDefaults.standard` usage.
   - 🛑 Flag if credentials, JWTs, OAuth tokens, API secrets, or PII are stored here.
   - Enforce Keychain migration (`kSecClassGenericPassword` with `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`).
2. Search for embedded hardcoded secrets (`API_KEY = "..."`, private keys, AWS tokens).

### Step 2: Network & ATS Security (MASVS-NETWORK)
1. Inspect `Info.plist` for `NSAppTransportSecurity`:
   - 🛑 Flag `NSAllowsArbitraryLoads = true` as a Critical vulnerability.
   - Flag insecure exception domains (`NSTemporaryExceptionAllowsInsecureHTTPLoads`).
2. Verify SSL/TLS Certificate Pinning configurations if the app deals with banking or sensitive personal data.

### Step 3: Biometrics & Secure Enclave (MASVS-AUTH)
1. Verify `LocalAuthentication` implementations:
   - 🛑 Flag client-side boolean checks (`if success { unlock() }`) on sensitive operations.
   - Enforce Keychain item access control flags (`kSecAttrAccessControl`) with `.biometryAny` or `.devicePasscode`.
2. Inspect encryption algorithms:
   - Flag outdated ciphers (DES, 3DES, MD5, SHA1 for signatures).
   - Enforce Apple's `CryptoKit` (AES-GCM, ChaChaPoly, SHA256/SHA512).

### Step 4: Adversarial Defense & Anti-Tamper (MASVS-RESILIENCE)
1. **Dynamic Swizzling Checks**: Search for `@objc dynamic` modifiers on security-critical classes (auth checks, jailbreak checks, licensing checks). Recommend `final` Swift classes with static dispatch.
2. **Background Screen Protection**: Verify that views containing sensitive PII (credit cards, medical data, financial balances) implement background snapshot masking upon `UIApplication.willResignActiveNotification`.
3. **URL Scheme Validation**: Inspect custom URL scheme handlers (`onOpenURL`) to prevent unauthorized cross-app parameter injection.

### Step 5: Telemetry & Logging (MASVS-PRIVACY)
1. Search for `print()`, `NSLog()`, or public `os_log` statements containing sensitive payload strings.
2. Enforce `Logger` from `os` with explicit privacy redaction:
   ```swift
   logger.info("Session token created for user: \(user.id, privacy: .private(mask: .hash))")
   ```

### Step 6: Generate Security Audit Matrix
Format the audit output clearly:
- **Vulnerability ID & OWASP Category** (e.g. `MASVS-AUTH-2`, `MASVS-RESILIENCE-1`)
- **Severity**: Critical, High, Medium, Low
- **Location**: Specific file and line reference
- **Remediation**: Drop-in secure code sample
