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
    @Default(false) bool biometricUnlock,
    @Default(false) bool appLock,
    @Default(1) int autoLockMinutes,
  }) = _SecurityPrefs;
}

/// Auto-lock choices offered in Security.
const autoLockOptions = [1, 5, 15];

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
