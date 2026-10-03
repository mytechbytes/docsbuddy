import 'security_models.dart';

/// Account security: TOTP 2FA (GoTrue MFA) and session control. Every method
/// throws an `AppFailure` on error.
abstract interface class SecurityRepository {
  Future<SecurityStatus> status();
  Future<TotpEnrollment> enrollTotp();
  Future<void> verifyTotp({required String factorId, required String code});
  Future<void> disableTotp(String factorId);

  /// True when a verified TOTP factor exists but the current session is
  /// still AAL1 — the sign-in must step up before using the app.
  Future<bool> needsMfaChallenge();

  /// Verifies a TOTP code against the enrolled factor, elevating to AAL2.
  Future<void> verifyMfaChallenge(String code);

  Future<SessionInfo> currentSession();
  Future<void> signOutOtherDevices();
}

/// Platform biometrics (Face ID / fingerprint, with device-credential
/// fallback). Never throws — every outcome is a value: unavailable is
/// false/empty, and [authenticate] reports why it didn't succeed.
abstract interface class BiometricAuthenticator {
  /// Whether the device can authenticate at all (biometrics, or a screen lock
  /// to fall back to).
  Future<bool> isAvailable();

  /// Which biometrics are enrolled (may be empty even when [isAvailable]:
  /// a device with only a PIN).
  Future<List<BiometricKind>> kinds();

  /// Shows the system prompt with [reason] as its explanation.
  Future<BiometricResult> authenticate(String reason);
}

/// Persistence for [SecurityPrefs] (device-local).
abstract interface class SecurityPrefsStore {
  SecurityPrefs load();
  Future<void> save(SecurityPrefs prefs);
}
