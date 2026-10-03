import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/security_models.dart';
import '../domain/security_repository.dart';

/// `local_auth` adapter that turns every outcome into a value. It degrades to
/// "unavailable" on platforms without biometrics (desktop, tests) and maps
/// `local_auth` 3.x's [LocalAuthException]s — which is how it reports a person
/// backing out, a lockout, or a device with no screen lock — to a
/// [BiometricResult], so nothing ever escapes as an exception.
class LocalAuthBiometricAuthenticator implements BiometricAuthenticator {
  LocalAuthBiometricAuthenticator([LocalAuthentication? auth]) : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<T> _safe<T>(Future<T> Function() run, T fallback) async {
    try {
      return await run();
    } on LocalAuthException {
      return fallback;
    } on PlatformException {
      return fallback;
    } on MissingPluginException {
      return fallback;
    }
  }

  @override
  Future<bool> isAvailable() =>
      _safe(() async => await _auth.isDeviceSupported() || await _auth.canCheckBiometrics, false);

  @override
  Future<List<BiometricKind>> kinds() => _safe(() async {
        final types = await _auth.getAvailableBiometrics();
        return {
          if (types.contains(BiometricType.face)) BiometricKind.face,
          if (types.contains(BiometricType.fingerprint)) BiometricKind.fingerprint,
          if (types.contains(BiometricType.strong) || types.contains(BiometricType.weak)) BiometricKind.device,
        }.toList();
      }, const []);

  /// Biometric prompt with device-credential (PIN/pattern/passcode) fallback,
  /// so nobody is locked out of their documents by a sensor that stops working.
  @override
  Future<BiometricResult> authenticate(String reason) async {
    try {
      final recognised =
          await _auth.authenticate(localizedReason: reason, biometricOnly: false, persistAcrossBackgrounding: true);
      return recognised ? BiometricResult.success : BiometricResult.failed;
    } on LocalAuthException catch (e) {
      return _resultFor(e.code);
    } on PlatformException {
      return BiometricResult.unavailable;
    } on MissingPluginException {
      return BiometricResult.unavailable;
    }
  }

  static BiometricResult _resultFor(LocalAuthExceptionCode code) => switch (code) {
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled ||
        LocalAuthExceptionCode.userRequestedFallback ||
        LocalAuthExceptionCode.timeout ||
        LocalAuthExceptionCode.authInProgress =>
          BiometricResult.canceled,
        LocalAuthExceptionCode.temporaryLockout || LocalAuthExceptionCode.biometricLockout => BiometricResult.lockedOut,
        LocalAuthExceptionCode.noCredentialsSet ||
        LocalAuthExceptionCode.noBiometricsEnrolled ||
        LocalAuthExceptionCode.noBiometricHardware =>
          BiometricResult.unavailable,
        _ => BiometricResult.error,
      };
}

/// [SecurityPrefs] in SharedPreferences — per device by design.
class SharedPrefsSecurityPrefsStore implements SecurityPrefsStore {
  SharedPrefsSecurityPrefsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kAppLock = 'security_app_lock';
  static const _kAutoLock = 'security_auto_lock_minutes';

  /// The retired "Unlock with biometrics" switch. It never locked anything on
  /// its own — turning it on was asking for the app lock, which is what it
  /// becomes — and it is dropped the next time the prefs are saved.
  static const _kLegacyBiometric = 'security_biometric_unlock';

  @override
  SecurityPrefs load() => SecurityPrefs(
        appLock: (_prefs.getBool(_kAppLock) ?? false) || (_prefs.getBool(_kLegacyBiometric) ?? false),
        autoLockMinutes: _prefs.getInt(_kAutoLock) ?? 1,
      );

  @override
  Future<void> save(SecurityPrefs prefs) async {
    await _prefs.setBool(_kAppLock, prefs.appLock);
    await _prefs.setInt(_kAutoLock, prefs.autoLockMinutes);
    await _prefs.remove(_kLegacyBiometric);
  }
}
