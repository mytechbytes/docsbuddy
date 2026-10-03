# App lock — fingerprint and Face ID

**Settings → "Lock with Face ID / fingerprint"** (also on Security) makes the app
ask for a fingerprint or Face ID — or the device PIN, pattern or passcode as a
fallback — when it is opened and after it has been away for the **auto-lock**
time (1, 5 or 15 minutes). The setting is per device and never leaves it.

The toggle is worded for what the device has ("Lock with Face ID", "Lock with
fingerprint", "Lock with Face ID or fingerprint", "Lock with biometrics", or
"Lock with your screen lock" when there is only a PIN), and is disabled with the
reason on a device that has no screen lock at all.

## How it behaves

- **Turning it on** asks you to authenticate once first, so nobody locks themselves
  out behind a sensor that doesn't work. If that fails it stays off and says why.
- **It covers everything.** The gate sits above the whole app (`MaterialApp.builder`),
  so a screen pushed on top of the tabs is hidden too. The app underneath stays
  alive but isn't painted, focusable or readable by a screen reader — a half-filled
  form is still there after unlocking.
- **App switcher:** whenever the app isn't in front (and the lock is on), a plain
  logo screen covers it, so the recent-apps snapshot never shows documents.
- **Nothing to lock while signed out**, and signing in is itself authentication:
  signing out (or turning the lock off) unlocks, so the next sign-in isn't asked twice.
- **Cold start:** with a saved session and the lock on, the app opens locked and
  prompts at once.
- **No dead ends.** The lock screen reacts to what happened: *not recognised* and
  *too many attempts* say so; backing out of the prompt is not an error; and there
  is always **Sign out**. If the device no longer has any screen lock, it offers
  **Turn off app lock** — otherwise the app would be locked for good.

## Code

| | |
|---|---|
| `security/domain` | `BiometricResult` (success · failed · canceled · lockedOut · unavailable · error), `SecurityPrefs.appLock` |
| `security/data/device_security.dart` | `local_auth` adapter. `local_auth` 3.x *throws* `LocalAuthException` for cancel / lockout / no credentials; the adapter turns every outcome into a `BiometricResult` so nothing escapes |
| `security/application` | `SecurityPrefsController.setAppLock`, `AppLockController` (lock state, auto-lock, sign-in awareness) |
| `security/presentation` | `AppLockGate` (root cover + privacy cover), `LockScreen`, `AppLockToggleRow` (shared by Settings and Security) |

Platform setup is already in place: Android `USE_BIOMETRIC` (+ `USE_FINGERPRINT` merged
for API 24–27) and `FlutterFragmentActivity`; iOS `NSFaceIDUsageDescription`. The
system prompt's own text is localized through the app's language setting; its
button labels follow the device language (a `local_auth` limitation).

## Testing it

`flutter test test/features/security` covers the adapter, the controller and the gate.
On a device or emulator: set a screen lock (emulator: `adb shell locksettings set-pin 1234`),
switch the lock on in Settings, press Home, wait past the auto-lock time and reopen.
