import 'package:docsbuddy/core/l10n/app_language.dart';
import 'package:docsbuddy/features/auth/application/auth_providers.dart';
import 'package:docsbuddy/features/auth/data/fake_auth_repository.dart';
import 'package:docsbuddy/features/security/application/security_providers.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

/// Signed in from the first moment, like a cold start with a saved session.
class _SignedIn extends FakeAuthRepository {
  @override
  bool get isSignedIn => true;
}

void main() {
  late FakeBiometrics biometrics;
  late InMemorySecurityPrefsStore store;
  late DateTime now;

  ProviderContainer make({
    SecurityPrefs prefs = const SecurityPrefs(),
    FakeAuthRepository? auth,
    AppLanguage language = AppLanguage.english,
  }) {
    store = InMemorySecurityPrefsStore(prefs);
    return makeContainer(
      overrides: testOverrides(
        auth: auth ?? _SignedIn(),
        biometrics: biometrics,
        securityPrefs: store,
        clock: () => now,
        language: language,
      ),
    );
  }

  setUp(() {
    biometrics = FakeBiometrics();
    now = DateTime(2026, 1, 1, 12);
  });

  group('turning the app lock on and off', () {
    test('needs a successful prompt first, so nobody locks themselves out with a sensor that does not work', () async {
      final c = make();
      biometrics.result = BiometricResult.failed;
      expect(await c.read(securityPrefsProvider.notifier).setAppLock(true), BiometricResult.failed);
      expect(c.read(securityPrefsProvider).appLock, isFalse);
      expect(store.prefs.appLock, isFalse, reason: 'nothing persisted either');

      biometrics.result = BiometricResult.success;
      expect(await c.read(securityPrefsProvider.notifier).setAppLock(true), BiometricResult.success);
      expect(c.read(securityPrefsProvider).appLock, isTrue);
      expect(store.prefs.appLock, isTrue);
    });

    test('each way the prompt can end leaves the lock off and says why', () async {
      for (final result in [
        BiometricResult.canceled,
        BiometricResult.lockedOut,
        BiometricResult.unavailable,
        BiometricResult.error,
      ]) {
        final c = make();
        biometrics.result = result;
        expect(await c.read(securityPrefsProvider.notifier).setAppLock(true), result);
        expect(c.read(securityPrefsProvider).appLock, isFalse, reason: '$result');
      }
    });

    test('turning it off does not prompt', () async {
      final c = make(prefs: const SecurityPrefs(appLock: true));
      await c.read(securityPrefsProvider.notifier).setAppLock(false);
      expect(biometrics.prompts, 0);
      expect(c.read(securityPrefsProvider).appLock, isFalse);
    });

    test('the system prompt is worded in the language the app is in', () async {
      final c = make(language: AppLanguage.spanish);
      await c.read(securityPrefsProvider.notifier).setAppLock(true);
      expect(biometrics.lastReason, 'Confirma para activar el bloqueo de la app');
    });
  });

  group('AppLockController', () {
    test('a cold start with a saved session and the lock on starts locked', () {
      expect(make(prefs: const SecurityPrefs(appLock: true)).read(appLockProvider), isTrue);
      expect(make().read(appLockProvider), isFalse, reason: 'lock off');
    });

    test('nothing to lock while signed out — and signing in afterwards does not lock either', () async {
      final auth = FakeAuthRepository();
      final c = make(prefs: const SecurityPrefs(appLock: true), auth: auth);
      c.listen(authStateProvider, (_, _) {});
      expect(c.read(appLockProvider), isFalse);

      await auth.signInWithPassword(email: 'a@b.dev', password: 'secret123'); // signing in is itself authentication
      await pumpEventQueue();
      expect(c.read(appLockProvider), isFalse);
    });

    test('signing out clears the lock, so the next person to sign in is not asked twice', () async {
      final auth = _SignedIn();
      final c = make(prefs: const SecurityPrefs(appLock: true), auth: auth);
      c.listen(authStateProvider, (_, _) {});
      expect(c.read(appLockProvider), isTrue);

      await auth.signOut();
      await pumpEventQueue();

      expect(c.read(appLockProvider), isFalse);
    });

    test('unlocks on success and reports it', () async {
      final c = make(prefs: const SecurityPrefs(appLock: true));
      expect(await c.read(appLockProvider.notifier).unlock(), BiometricResult.success);
      expect(c.read(appLockProvider), isFalse);
      expect(biometrics.lastReason, 'Unlock DocsBuddy');
    });

    test('stays locked for every outcome that is not a success, and says which it was', () async {
      for (final result in [
        BiometricResult.failed,
        BiometricResult.canceled,
        BiometricResult.lockedOut,
        BiometricResult.unavailable,
        BiometricResult.error,
      ]) {
        final c = make(prefs: const SecurityPrefs(appLock: true));
        biometrics.result = result;
        expect(await c.read(appLockProvider.notifier).unlock(), result);
        expect(c.read(appLockProvider), isTrue, reason: '$result must not unlock');
      }
    });

    test('re-locks after the auto-lock window, not before', () async {
      final c = make(prefs: const SecurityPrefs(appLock: true, autoLockMinutes: 5));
      final lock = c.read(appLockProvider.notifier);
      await lock.unlock();
      expect(c.read(appLockProvider), isFalse);

      lock.appPaused();
      now = now.add(const Duration(minutes: 2));
      lock.appResumed();
      expect(c.read(appLockProvider), isFalse);

      lock.appPaused();
      now = now.add(const Duration(minutes: 5));
      lock.appResumed();
      expect(c.read(appLockProvider), isTrue);
    });

    test('does not lock at all when the lock is off', () {
      final c = make(prefs: const SecurityPrefs(autoLockMinutes: 1));
      final lock = c.read(appLockProvider.notifier);
      lock.appPaused();
      now = now.add(const Duration(hours: 3));
      lock.appResumed();
      expect(c.read(appLockProvider), isFalse);
    });

    test('turning the lock off while it is locked unlocks (the escape when the device has no screen lock)', () async {
      final c = make(prefs: const SecurityPrefs(appLock: true));
      biometrics.result = BiometricResult.unavailable;
      expect(await c.read(appLockProvider.notifier).unlock(), BiometricResult.unavailable);
      expect(c.read(appLockProvider), isTrue);

      await c.read(appLockProvider.notifier).turnOffAppLock();

      expect(c.read(appLockProvider), isFalse);
      expect(c.read(securityPrefsProvider).appLock, isFalse);
      expect(store.prefs.appLock, isFalse, reason: 'and it stays off after a restart');
    });
  });

  test('SecurityActions refreshes the 2FA status after confirming', () async {
    final c = make();
    c.listen(securityStatusProvider, (_, _) {});
    expect((await c.read(securityStatusProvider.future)).totpEnabled, isFalse);

    final actions = c.read(securityActionsProvider);
    final enrollment = await actions.startTotpEnrollment();
    await actions.confirmTotp(enrollment, '123456');
    expect((await c.read(securityStatusProvider.future)).totpEnabled, isTrue);

    await actions.disableTotp();
    expect((await c.read(securityStatusProvider.future)).totpEnabled, isFalse);
  });
}
