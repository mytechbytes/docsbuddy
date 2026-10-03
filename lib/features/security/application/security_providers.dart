import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/l10n/language_controller.dart';
import '../../../core/providers/core_providers.dart';
import '../../auth/application/auth_providers.dart';
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

  /// Turns the app lock on or off. Turning it **on** first asks the person to
  /// authenticate once, so nobody locks themselves out behind a sensor that
  /// doesn't work: anything but [BiometricResult.success] leaves it off and is
  /// returned so the screen can say why. Turning it off needs no prompt.
  Future<BiometricResult> setAppLock(bool enabled) async {
    if (enabled) {
      final reason = ref.read(appLocalizationsProvider).lockPromptEnable;
      final result = await ref.read(biometricAuthenticatorProvider).authenticate(reason);
      if (!result.isSuccess) return result;
    }
    await _save(state.copyWith(appLock: enabled));
    return BiometricResult.success;
  }

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

/// Whether the app is locked behind fingerprint / Face ID (or the device PIN).
///
/// Locked on a cold start when the lock is on and there is a saved session;
/// locks again after the app was away longer than the auto-lock window (the
/// gate forwards lifecycle events). It has nothing to protect when nobody is
/// signed in, and signing in is itself authentication — so signing out, or
/// turning the lock off, unlocks.
class AppLockController extends Notifier<bool> {
  DateTime? _pausedAt;

  @override
  bool build() {
    ref.listen(authStateProvider, (_, signedIn) {
      if (signedIn.value == false) state = false;
    });
    ref.listen(securityPrefsProvider, (_, prefs) {
      if (!prefs.appLock) state = false;
    });
    return ref.read(securityPrefsProvider).appLock && ref.read(authRepositoryProvider).isSignedIn;
  }

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

  /// Runs the system prompt; unlocks on success. The result says why it did
  /// not, so the lock screen can respond (retry, wait, or offer a way out).
  Future<BiometricResult> unlock() async {
    final reason = ref.read(appLocalizationsProvider).lockPromptUnlock;
    final result = await ref.read(biometricAuthenticatorProvider).authenticate(reason);
    if (result.isSuccess) state = false;
    return result;
  }

  /// The way out when the device can no longer authenticate (its screen lock
  /// was removed): without it the app would be locked for good.
  Future<void> turnOffAppLock() => ref.read(securityPrefsProvider.notifier).setAppLock(false);
}

final appLockProvider = NotifierProvider<AppLockController, bool>(AppLockController.new);
