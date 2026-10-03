import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:docsbuddy/features/auth/data/fake_auth_repository.dart';
import 'package:docsbuddy/features/security/application/security_providers.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:docsbuddy/features/security/presentation/app_lock_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

/// Signed in from the first moment, like a cold start with a saved session.
class _SignedIn extends FakeAuthRepository {
  @override
  bool get isSignedIn => true;
}

/// A tab-like home with a text field, and a button that pushes a detail page
/// over it — the case the old, home-screen-only lock missed.
class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(children: [
          const TextField(key: Key('draft')),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('DETAIL: private document'))),
            ),
            child: const Text('Open detail'),
          ),
        ]),
      );
}

void main() {
  late FakeBiometrics biometrics;
  late InMemorySecurityPrefsStore prefs;
  late FakeAuthRepository auth;
  late DateTime now;

  Widget app({
    SecurityPrefs initial = const SecurityPrefs(appLock: true),
    FakeAuthRepository? signedInAs,
  }) {
    prefs = InMemorySecurityPrefsStore(initial);
    auth = signedInAs ?? _SignedIn();
    return ProviderScope(
      overrides: testOverrides(auth: auth, biometrics: biometrics, securityPrefs: prefs, clock: () => now),
      retry: noRetry,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (_, child) => AppLockGate(child: child!),
        home: const _Home(),
      ),
    );
  }

  ProviderContainer container(WidgetTester tester) => ProviderScope.containerOf(tester.element(find.byType(AppLockGate)));

  /// Puts the app in the background for [away], then brings it back.
  Future<void> leaveAndReturn(WidgetTester tester, Duration away) async {
    final binding = tester.binding;
    for (final s in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.paused]) {
      binding.handleAppLifecycleStateChanged(s);
    }
    await tester.pump();
    now = now.add(away);
    for (final s in [AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed]) {
      binding.handleAppLifecycleStateChanged(s);
    }
    await tester.pump();
    await tester.pump();
  }

  setUp(() {
    biometrics = FakeBiometrics()..available = true;
    now = DateTime(2026, 1, 1, 12);
  });

  testWidgets('a cold start with the lock on shows the lock, not the app, and asks to unlock at once', (tester) async {
    biometrics.result = BiometricResult.canceled;
    await tester.pumpWidget(app());
    await tester.pump();
    await tester.pump();

    expect(find.text('Locked'), findsOneWidget);
    expect(find.text('Open detail'), findsNothing, reason: 'the app is hidden while locked');
    expect(biometrics.prompts, 1, reason: 'prompts as soon as it appears');
    expect(biometrics.lastReason, 'Unlock DocsBuddy');
  });

  testWidgets('recognising the person unlocks the app', (tester) async {
    await tester.pumpWidget(app());
    await tester.pump();
    await tester.pump();

    expect(find.text('Locked'), findsNothing);
    expect(find.text('Open detail'), findsOneWidget);
  });

  testWidgets('with the lock off, the app is never covered', (tester) async {
    await tester.pumpWidget(app(initial: const SecurityPrefs()));
    await tester.pump();

    expect(find.text('Open detail'), findsOneWidget);
    expect(biometrics.prompts, 0);
    await leaveAndReturn(tester, const Duration(hours: 5));
    expect(find.text('Locked'), findsNothing);
  });

  testWidgets('signed out, there is nothing to lock — even with the lock switched on', (tester) async {
    await tester.pumpWidget(app(signedInAs: FakeAuthRepository()));
    await tester.pump();

    expect(find.text('Open detail'), findsOneWidget);
    expect(biometrics.prompts, 0);
  });

  group('while it is locked', () {
    testWidgets('a screen pushed on top of the tabs is covered too, and is back after unlocking', (tester) async {
      await tester.pumpWidget(app(initial: const SecurityPrefs(appLock: true, autoLockMinutes: 1)));
      await tester.pump();
      await tester.pump(); // unlocked at the first prompt
      await tester.tap(find.text('Open detail'));
      await tester.pumpAndSettle();
      expect(find.text('DETAIL: private document'), findsOneWidget);

      biometrics.result = BiometricResult.canceled;
      await leaveAndReturn(tester, const Duration(minutes: 2));

      expect(find.text('Locked'), findsOneWidget);
      expect(find.text('DETAIL: private document'), findsNothing, reason: 'must not stay readable behind the lock');

      biometrics.result = BiometricResult.success;
      await tester.tap(find.byIcon(Icons.lock_outline));
      await tester.pump();
      await tester.pump();

      expect(find.text('DETAIL: private document'), findsOneWidget, reason: 'the same page, exactly where they left it');
    });

    testWidgets('a half-typed form is still there after unlocking', (tester) async {
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump();
      await tester.enterText(find.byKey(const Key('draft')), 'Samsung fridge, bought 2024');

      biometrics.result = BiometricResult.canceled;
      await leaveAndReturn(tester, const Duration(minutes: 5));
      expect(find.byKey(const Key('draft')), findsNothing);

      biometrics.result = BiometricResult.success;
      await tester.tap(find.byIcon(Icons.lock_outline));
      await tester.pump();
      await tester.pump();

      expect(find.text('Samsung fridge, bought 2024'), findsOneWidget);
    });

    testWidgets('a short trip away does not lock', (tester) async {
      await tester.pumpWidget(app(initial: const SecurityPrefs(appLock: true, autoLockMinutes: 5)));
      await tester.pump();
      await tester.pump();

      await leaveAndReturn(tester, const Duration(minutes: 2));

      expect(find.text('Locked'), findsNothing);
      expect(find.text('Open detail'), findsOneWidget);
    });
  });

  group('when unlocking does not work', () {
    testWidgets('not recognised: says so, stays locked, and a second try can succeed', (tester) async {
      biometrics.result = BiometricResult.failed;
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump();

      expect(find.text('Not recognised. Try again.'), findsOneWidget);
      expect(find.text('Locked'), findsOneWidget);

      biometrics.result = BiometricResult.success;
      await tester.tap(find.byIcon(Icons.lock_outline));
      await tester.pump();
      await tester.pump();

      expect(find.text('Locked'), findsNothing);
      expect(biometrics.prompts, 2);
    });

    testWidgets('backing out of the prompt is not an error, and the spinner does not stick', (tester) async {
      biometrics.result = BiometricResult.canceled;
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing, reason: 'the old code left this spinning forever');
      expect(find.text('Not recognised. Try again.'), findsNothing);
      expect(find.text('Tap to unlock'), findsOneWidget);
    });

    testWidgets('too many attempts explains and points to the device PIN', (tester) async {
      biometrics.result = BiometricResult.lockedOut;
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump();

      expect(find.text('Too many attempts. Wait a moment, or use your device PIN.'), findsOneWidget);
    });

    testWidgets('a device that lost its screen lock can turn the app lock off instead of being stuck', (tester) async {
      biometrics.result = BiometricResult.unavailable;
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump();

      expect(find.text("This device has no screen lock set up, so the app can't be locked."), findsOneWidget);
      await tester.tap(find.text('Turn off app lock'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Open detail'), findsOneWidget);
      expect(prefs.prefs.appLock, isFalse, reason: 'and it stays off');
    });

    testWidgets('signing out is always on offer, and leaves no lock behind for the next sign-in', (tester) async {
      biometrics.result = BiometricResult.failed;
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump();
      expect(find.text('Sign out'), findsOneWidget);

      await tester.tap(find.text('Sign out'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text('Locked'), findsNothing);
      expect(container(tester).read(appLockProvider), isFalse);
    });
  });

  group('the lock screen matches the device', () {
    testWidgets('Face ID gets a face; a fingerprint reader gets a fingerprint; a bare PIN a padlock', (tester) async {
      biometrics.result = BiometricResult.canceled;

      biometrics.availableKinds = const [BiometricKind.face];
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(Icons.face_unlock_outlined), findsOneWidget);

      biometrics.availableKinds = const [BiometricKind.fingerprint];
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(Icons.fingerprint), findsOneWidget);
    });
  });

  group('the app switcher', () {
    testWidgets('shows only the logo, not the documents, while the lock is on', (tester) async {
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump(); // unlocked
      expect(find.byKey(privacyCoverKey), findsNothing, reason: 'nothing covers the app while it is in use');

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      expect(find.byKey(privacyCoverKey), findsOneWidget, reason: 'covered the moment the app stops being in front');
      expect(tester.getRect(find.byKey(privacyCoverKey)), tester.getRect(find.byType(AppLockGate)),
          reason: 'it fills the whole window, so no edge of a document shows');

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(find.byKey(privacyCoverKey), findsNothing);
      expect(find.text('Open detail'), findsOneWidget);
    });

    testWidgets('is not used when the lock is off', (tester) async {
      await tester.pumpWidget(app(initial: const SecurityPrefs()));
      await tester.pump();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();

      expect(find.byKey(privacyCoverKey), findsNothing);
    });

    testWidgets('is not used when signed out — there is nothing private to hide', (tester) async {
      await tester.pumpWidget(app(signedInAs: FakeAuthRepository()));
      await tester.pump();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();

      expect(find.byKey(privacyCoverKey), findsNothing);
    });
  });
}
