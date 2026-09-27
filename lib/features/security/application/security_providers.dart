import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/security_models.dart';
import '../domain/security_repository.dart';

// ── Bindings (overridden at the composition root) ──

final securityRepositoryProvider = Provider<SecurityRepository>(
  (ref) => throw UnimplementedError('securityRepositoryProvider must be overridden'),
);

final biometricAuthenticatorProvider = Provider<BiometricAuthenticator>(
  (ref) => throw UnimplementedError('biometricAuthenticatorProvider must be overridden'),
);

final securityPrefsStoreProvider = Provider<SecurityPrefsStore>(
  (ref) => throw UnimplementedError('securityPrefsStoreProvider must be overridden'),
);

// ── Queries ──

final securityStatusProvider = FutureProvider<SecurityStatus>((ref) {
  return ref.watch(securityRepositoryProvider).status();
});

/// True when the session must step up to AAL2 before using the app.
final mfaChallengeRequiredProvider = FutureProvider<bool>((ref) {
  return ref.watch(securityRepositoryProvider).needsMfaChallenge();
});

final biometricsAvailableProvider = FutureProvider<bool>((ref) {
  return ref.watch(biometricAuthenticatorProvider).isAvailable();
});

final biometricKindsProvider = FutureProvider<List<BiometricKind>>((ref) {
  return ref.watch(biometricAuthenticatorProvider).kinds();
});

// ── Device-local switches ──

class SecurityPrefsController extends Notifier<SecurityPrefs> {
  SecurityPrefsStore get _store => ref.read(securityPrefsStoreProvider);

  @override
  SecurityPrefs build() => ref.watch(securityPrefsStoreProvider).load();

  Future<void> _save(SecurityPrefs next) async {
    await _store.save(next);
    state = next;
  }

  /// Turning biometric unlock on requires a successful biometric check
  /// first; returns false (and changes nothing) when it's declined.
  Future<bool> setBiometricUnlock(bool enabled) async {
    if (enabled) {
      final ok = await ref.read(biometricAuthenticatorProvider).authenticate('Confirm to enable biometric unlock');
      if (!ok) return false;
    }
    await _save(state.copyWith(biometricUnlock: enabled));
    return true;
  }

  Future<void> setAppLock(bool enabled) => _save(state.copyWith(appLock: enabled));

  Future<void> setAutoLockMinutes(int minutes) => _save(state.copyWith(autoLockMinutes: minutes));
}

final securityPrefsProvider = NotifierProvider<SecurityPrefsController, SecurityPrefs>(SecurityPrefsController.new);

// ── Account security actions ──

/// TOTP and session actions from the Security screen. Methods throw
/// [AppFailure]; the 2FA status is refreshed after changes.
class SecurityActions {
  SecurityActions(this._ref);
  final Ref _ref;

  SecurityRepository get _repo => _ref.read(securityRepositoryProvider);

  Future<TotpEnrollment> startTotpEnrollment() => _repo.enrollTotp();

  Future<void> confirmTotp(TotpEnrollment enrollment, String code) async {
    await _repo.verifyTotp(factorId: enrollment.factorId, code: code);
    _ref.invalidate(securityStatusProvider);
  }

  /// Call when the enrollment sheet closes (verified or not).
  void enrollmentFinished() => _ref.invalidate(securityStatusProvider);

  Future<void> disableTotp() async {
    final factorId = _ref.read(securityStatusProvider).value?.totpFactorId;
    if (factorId == null) return;
    try {
      await _repo.disableTotp(factorId);
    } finally {
      _ref.invalidate(securityStatusProvider);
    }
  }

  Future<SessionInfo> currentSession() => _repo.currentSession();

  Future<void> signOutOtherDevices() => _repo.signOutOtherDevices();

  /// AAL2 step-up for the current session.
  Future<void> verifyMfaChallenge(String code) async {
    await _repo.verifyMfaChallenge(code);
    _ref.invalidate(mfaChallengeRequiredProvider);
  }
}

final securityActionsProvider = Provider<SecurityActions>((ref) => SecurityActions(ref));

// ── App lock ──

/// Whether the signed-in shell is locked. Starts locked when app lock is on
/// (a fresh launch); re-locks after the app was away longer than the
/// auto-lock window. The shell forwards lifecycle events.
class AppLockController extends Notifier<bool> {
  DateTime? _pausedAt;

  @override
  bool build() => ref.read(securityPrefsProvider).appLock;

  void appPaused() {
    if (!ref.read(securityPrefsProvider).appLock) return;
    _pausedAt ??= ref.read(clockProvider)();
  }

  void appResumed() {
    final prefs = ref.read(securityPrefsProvider);
    final pausedAt = _pausedAt;
    _pausedAt = null;
    if (!prefs.appLock || pausedAt == null) return;
    if (shouldAutoLock(pausedAt: pausedAt, resumedAt: ref.read(clockProvider)(), autoLockMinutes: prefs.autoLockMinutes)) {
      state = true;
    }
  }

  /// Runs the biometric prompt; unlocks on success.
  Future<void> unlock() async {
    if (await ref.read(biometricAuthenticatorProvider).authenticate('Unlock DocsBuddy')) state = false;
  }
}

final appLockProvider = NotifierProvider<AppLockController, bool>(AppLockController.new);
