import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_models.freezed.dart';

/// A pending TOTP enrollment — show the QR/secret, then verify a code.
@freezed
abstract class TotpEnrollment with _$TotpEnrollment {
  const factory TotpEnrollment({
    required String factorId,
    required String secret,

    /// `otpauth://` URI for the authenticator-app QR.
    required String uri,
  }) = _TotpEnrollment;
}

@freezed
abstract class SecurityStatus with _$SecurityStatus {
  const SecurityStatus._();

  const factory SecurityStatus({String? totpFactorId, DateTime? enrolledAt}) = _SecurityStatus;

  bool get totpEnabled => totpFactorId != null;
}

@freezed
abstract class SessionInfo with _$SessionInfo {
  const factory SessionInfo({required String device, DateTime? lastSignIn}) = _SessionInfo;
}

/// Device-local security switches (per device by design).
@freezed
abstract class SecurityPrefs with _$SecurityPrefs {
  const factory SecurityPrefs({
    /// Ask for fingerprint / Face ID (or the device PIN) when the app opens.
    @Default(false) bool appLock,

    /// How long the app can be away before it locks again.
    @Default(1) int autoLockMinutes,
  }) = _SecurityPrefs;
}

/// Auto-lock choices offered in Security.
const autoLockOptions = [1, 5, 15];

/// How an attempt to authenticate the user ended. Only [success] unlocks;
/// the rest say why not, so the screen can respond sensibly instead of
/// showing a generic failure (or hanging).
enum BiometricResult {
  success,

  /// Ran, and the person wasn't recognised. Try again.
  failed,

  /// The person backed out (or the system interrupted the prompt). Not an error.
  canceled,

  /// Too many wrong attempts; biometrics are locked for a while.
  lockedOut,

  /// This device can't authenticate at all — no screen lock, fingerprint or
  /// face set up (or no biometric support on this platform).
  unavailable,

  /// Something unexpected went wrong.
  error;

  bool get isSuccess => this == success;
}

enum BiometricKind {
  face('Face ID'),
  fingerprint('Fingerprint'),
  device('Device biometrics');

  const BiometricKind(this.label);
  final String label;
}

/// Pure app-lock rule: lock when the app was away at least the auto-lock
/// window.
bool shouldAutoLock({required DateTime pausedAt, required DateTime resumedAt, required int autoLockMinutes}) =>
    resumedAt.difference(pausedAt) >= Duration(minutes: autoLockMinutes);
