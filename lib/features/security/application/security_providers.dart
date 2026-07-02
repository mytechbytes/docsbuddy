import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../onboarding/application/onboarding_controller.dart' show sharedPreferencesProvider;
import '../data/security_repository.dart';

final securityRepositoryProvider = Provider<SecurityRepository>((ref) {
  if (Env.hasSupabase) {
    return SupabaseSecurityRepository(Supabase.instance.client);
  }
  return FakeSecurityRepository();
});

final securityStatusProvider = FutureProvider<SecurityStatus>((ref) {
  return ref.watch(securityRepositoryProvider).status();
});

/// True when the session must step up to AAL2 before using the app.
final mfaChallengeRequiredProvider = FutureProvider<bool>((ref) {
  return ref.watch(securityRepositoryProvider).needsMfaChallenge();
});

/// Thin `local_auth` wrapper that degrades to "unavailable" on platforms
/// without biometrics (desktop, tests) instead of throwing.
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> get isAvailable async {
    try {
      return await _auth.isDeviceSupported() || await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<List<BiometricType>> types() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }

  /// Biometric prompt with device-credential (PIN/pattern) fallback.
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}

final biometricServiceProvider = Provider<BiometricService>((ref) => BiometricService());

final biometricsAvailableProvider = FutureProvider<bool>((ref) {
  return ref.watch(biometricServiceProvider).isAvailable;
});

/// Device-local security switches (SharedPreferences — per device by design).
class SecurityPrefs {
  const SecurityPrefs({this.biometricUnlock = false, this.appLock = false, this.autoLockMinutes = 1});
  final bool biometricUnlock;
  final bool appLock;
  final int autoLockMinutes;

  SecurityPrefs copyWith({bool? biometricUnlock, bool? appLock, int? autoLockMinutes}) => SecurityPrefs(
        biometricUnlock: biometricUnlock ?? this.biometricUnlock,
        appLock: appLock ?? this.appLock,
        autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
      );
}

class SecurityPrefsController extends Notifier<SecurityPrefs> {
  static const _kBiometric = 'security_biometric_unlock';
  static const _kAppLock = 'security_app_lock';
  static const _kAutoLock = 'security_auto_lock_minutes';

  @override
  SecurityPrefs build() {
    final p = ref.watch(sharedPreferencesProvider);
    return SecurityPrefs(
      biometricUnlock: p.getBool(_kBiometric) ?? false,
      appLock: p.getBool(_kAppLock) ?? false,
      autoLockMinutes: p.getInt(_kAutoLock) ?? 1,
    );
  }

  Future<void> setBiometricUnlock(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(_kBiometric, value);
    state = state.copyWith(biometricUnlock: value);
  }

  Future<void> setAppLock(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(_kAppLock, value);
    state = state.copyWith(appLock: value);
  }

  Future<void> setAutoLockMinutes(int minutes) async {
    await ref.read(sharedPreferencesProvider).setInt(_kAutoLock, minutes);
    state = state.copyWith(autoLockMinutes: minutes);
  }
}

final securityPrefsProvider =
    NotifierProvider<SecurityPrefsController, SecurityPrefs>(SecurityPrefsController.new);
