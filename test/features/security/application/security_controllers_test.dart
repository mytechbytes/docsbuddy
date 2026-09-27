import 'package:docsbuddy/features/security/application/security_providers.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  late FakeBiometrics biometrics;
  late InMemorySecurityPrefsStore store;
  late DateTime now;

  ProviderContainer make({SecurityPrefs prefs = const SecurityPrefs()}) {
    store = InMemorySecurityPrefsStore(prefs);
    return makeContainer(
      overrides: testOverrides(biometrics: biometrics, securityPrefs: store, clock: () => now),
    );
  }

  setUp(() {
    biometrics = FakeBiometrics();
    now = DateTime(2026, 1, 1, 12);
  });

  group('SecurityPrefsController', () {
    test('enabling biometric unlock requires a successful prompt', () async {
      final c = make();
      biometrics.succeeds = false;
      expect(await c.read(securityPrefsProvider.notifier).setBiometricUnlock(true), isFalse);
      expect(c.read(securityPrefsProvider).biometricUnlock, isFalse);

      biometrics.succeeds = true;
      expect(await c.read(securityPrefsProvider.notifier).setBiometricUnlock(true), isTrue);
      expect(store.prefs.biometricUnlock, isTrue); // persisted
    });

    test('disabling does not prompt', () async {
      final c = make(prefs: const SecurityPrefs(biometricUnlock: true));
      await c.read(securityPrefsProvider.notifier).setBiometricUnlock(false);
      expect(biometrics.prompts, 0);
    });
  });

  group('AppLockController', () {
    test('starts locked when app lock is on', () {
      expect(make(prefs: const SecurityPrefs(appLock: true)).read(appLockProvider), isTrue);
      expect(make().read(appLockProvider), isFalse);
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

    test('a failed biometric prompt keeps it locked', () async {
      final c = make(prefs: const SecurityPrefs(appLock: true));
      biometrics.succeeds = false;
      await c.read(appLockProvider.notifier).unlock();
      expect(c.read(appLockProvider), isTrue);
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
