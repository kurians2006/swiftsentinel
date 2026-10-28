# iOS Security & Privacy Auditing Rules (OWASP MASVS & Adversarial Defense)

This guide enforces platform-specific security best practices for iOS applications, aligning with the **OWASP Mobile Application Security Verification Standard (MASVS)** and adversarial defense against mobile surveillance/tampering vectors.

---

## 1. Secure Credential Storage (MASVS-STORAGE)

### Rule: Auth tokens, passwords, and private keys MUST be stored in Keychain
* **Why**: `UserDefaults`, property lists (`.plist`), and unencrypted SQLite/Core Data databases are stored in plaintext on disk and are easily extracted from unencrypted device backups or compromised file systems.
* **Bad**:
  ```swift
  // ❌ Storing JWT or API tokens in UserDefaults
  UserDefaults.standard.set(authToken, forKey: "user_auth_token")
  ```
* **Good**:
  ```swift
  // ✅ Storing in Keychain with strict accessibility attributes
  let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: "authToken",
      kSecValueData as String: tokenData,
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
  ]
  SecItemAdd(query as CFDictionary, nil)
  ```

---

## 2. App Transport Security (ATS) & Network Communication (MASVS-NETWORK)

### Rule: NEVER disable ATS globally; enforce TLS 1.3
* **Why**: Setting `NSAllowsArbitraryLoads` to `true` disables mandatory TLS encryption across the entire app.
* **Bad**:
  ```xml
  <!-- ❌ Disables TLS security checks for all endpoints -->
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
  </dict>
  ```
* **Good**:
  ```xml
  <!-- ✅ Restrict exceptions strictly to specific local or internal domains if unavoidable -->
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSExceptionDomains</key>
      <dict>
          <key>api.internal.example.com</key>
          <dict>
              <key>NSIncludesSubdomains</key>
              <true/>
              <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
              <false/>
          </dict>
      </dict>
  </dict>
  ```

---

## 3. Biometric Authentication & Cryptographic Binding (MASVS-AUTH)

### Rule: NEVER use client-side Boolean checks as the sole authorization gate
* **Why**: Adversarial surveillance tools and runtime hooking frameworks (e.g. Frida, Cycript) intercept `evaluatePolicy` callbacks and force `success = true`. Sensitive operations must be cryptographically locked to the Secure Enclave.
* **Bad**:
  ```swift
  // ❌ Vulnerable to simple runtime method hooking
  context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
      if success {
          self.grantAccessToVault()
      }
  }
  ```
* **Good**:
  ```swift
  // ✅ Cryptographically bind sensitive keys to Keychain protected by Secure Enclave AccessControl
  var error: Unmanaged<CFError>?
  guard let accessControl = SecAccessControlCreateWithFlags(
      kCFAllocatorDefault,
      kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
      [.biometryAny, .or, .devicePasscode],
      &error
  ) else { return }

  let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: "secretVaultKey",
      kSecValueData as String: secretData,
      kSecAttrAccessControl as String: accessControl
  ]
  SecItemAdd(query as CFDictionary, nil)
  ```

---

## 4. Adversarial Defense: Anti-Hooking & Devirtualization (MASVS-RESILIENCE)

### Rule: Sensitive Security Handlers MUST be Devirtualized (`final` and Swift-native)
* **Why**: Dynamic Objective-C dispatch (`@objc dynamic`) allows attackers to swizzle critical authorization checks at runtime. Static Swift dispatch prevents runtime method swizzling.
* **Bad**:
  ```swift
  // ❌ Dynamic dispatch allows easy runtime swizzling via Frida / Cycript
  class AuthenticationManager: NSObject {
      @objc dynamic func isUserAuthorized() -> Bool {
          return self.sessionToken != nil
      }
  }
  ```
* **Good**:
  ```swift
  // ✅ Marked final with static dispatch, compiler-inlined where possible
  final class AuthenticationManager {
      func isUserAuthorized() -> Bool {
          return self.sessionToken != nil
      }
  }
  ```

---

## 5. Privacy, Screen Masking & Telemetry (MASVS-PRIVACY)

### Rule: Mask Sensitive Screens in the App Switcher
* **Why**: iOS captures automatic snapshot images of the active screen when the app transitions to the background. Unmasked screens leak account balances, credit cards, and PII into unencrypted disk caches.
* **Good Pattern**:
  ```swift
  // In your SceneDelegate / App lifecycle:
  .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
      privacyOverlayVisible = true
  }
  .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
      privacyOverlayVisible = false
  }
  ```

### Rule: NEVER output PII or Auth Tokens in Logs
* **Why**: Logs can be dumped by unauthorized tools via sysdiagnose or Mac Console.
* **Good**: Use Apple Unified Logging (`os.Logger`) with `.private(mask: .hash)`.
