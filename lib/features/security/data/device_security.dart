import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/security_models.dart';
import '../domain/security_repository.dart';

/// `local_auth` adapter that degrades to "unavailable" on platforms without
/// biometrics (desktop, tests) instead of throwing.
class LocalAuthBiometricAuthenticator implements BiometricAuthenticator {
  LocalAuthBiometricAuthenticator([LocalAuthentication? auth]) : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<T> _safe<T>(Future<T> Function() run, T fallback) async {
    try {
      return await run();
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

  /// Biometric prompt with device-credential (PIN/pattern) fallback.
  @override
  Future<bool> authenticate(String reason) => _safe(
        () => _auth.authenticate(localizedReason: reason, biometricOnly: false, persistAcrossBackgrounding: true),
        false,
      );
}

/// [SecurityPrefs] in SharedPreferences — per device by design.
class SharedPrefsSecurityPrefsStore implements SecurityPrefsStore {
  SharedPrefsSecurityPrefsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kBiometric = 'security_biometric_unlock';
  static const _kAppLock = 'security_app_lock';
  static const _kAutoLock = 'security_auto_lock_minutes';

  @override
  SecurityPrefs load() => SecurityPrefs(
        biometricUnlock: _prefs.getBool(_kBiometric) ?? false,
        appLock: _prefs.getBool(_kAppLock) ?? false,
        autoLockMinutes: _prefs.getInt(_kAutoLock) ?? 1,
      );

  @override
  Future<void> save(SecurityPrefs prefs) async {
    await _prefs.setBool(_kBiometric, prefs.biometricUnlock);
    await _prefs.setBool(_kAppLock, prefs.appLock);
    await _prefs.setInt(_kAutoLock, prefs.autoLockMinutes);
  }
}
