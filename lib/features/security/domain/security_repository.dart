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
/// fallback). Never throws — unavailable means false/empty.
abstract interface class BiometricAuthenticator {
  Future<bool> isAvailable();
  Future<List<BiometricKind>> kinds();
  Future<bool> authenticate(String reason);
}

/// Persistence for [SecurityPrefs] (device-local).
abstract interface class SecurityPrefsStore {
  SecurityPrefs load();
  Future<void> save(SecurityPrefs prefs);
}
