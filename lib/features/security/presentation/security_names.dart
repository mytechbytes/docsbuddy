import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/security_models.dart';

extension BiometricKindName on BiometricKind {
  String displayName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      BiometricKind.face => l.biometricFace,
      BiometricKind.fingerprint => l.biometricFingerprint,
      BiometricKind.device => l.biometricDevice,
    };
  }
}

/// How the app lock is described and drawn for what this device offers: "Lock
/// with Face ID", "Lock with fingerprint", or — when there are no biometrics,
/// only a PIN or pattern — "Lock with your screen lock".
extension AppLockMethod on List<BiometricKind> {
  bool get _hasFace => contains(BiometricKind.face);
  bool get _hasFingerprint => contains(BiometricKind.fingerprint);

  String lockTitle(BuildContext context) {
    final l = context.l10n;
    if (_hasFace && _hasFingerprint) return l.lockToggleFaceOrFingerprint;
    if (_hasFace) return l.lockToggleFace;
    if (_hasFingerprint) return l.lockToggleFingerprint;
    return contains(BiometricKind.device) ? l.lockToggleBiometrics : l.lockToggleDevice;
  }

  IconData get lockIcon {
    if (_hasFingerprint) return Icons.fingerprint;
    if (_hasFace) return Icons.face_unlock_outlined;
    return isEmpty ? Icons.lock_outline : Icons.fingerprint;
  }
}

extension BiometricResultText on BiometricResult {
  /// What to tell the person when an attempt didn't unlock. Null when there is
  /// nothing to say — a success, or someone simply backing out of the prompt.
  String? message(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      BiometricResult.success || BiometricResult.canceled => null,
      BiometricResult.failed => l.lockFailed,
      BiometricResult.lockedOut => l.lockTooManyAttempts,
      BiometricResult.unavailable => l.lockNeedsScreenLock,
      BiometricResult.error => l.lockError,
    };
  }
}
