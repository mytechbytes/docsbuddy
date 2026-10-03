import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:docsbuddy/features/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  late FakeBiometrics biometrics;
  late InMemorySecurityPrefsStore prefs;

  Future<void> pumpSettings(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(800, 3200)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    prefs = InMemorySecurityPrefsStore();
    // A fresh provider scope each time, so a different device is really a different device.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(testApp(
      const SettingsPage(),
      overrides: testOverrides(biometrics: biometrics, securityPrefs: prefs),
    ));
    await settle(tester);
  }

  Switch switchOf(WidgetTester tester, String title) => tester.widget<Switch>(find.descendant(
        of: find.ancestor(of: find.text(title), matching: find.byType(ListTile)),
        matching: find.byType(Switch),
      ));

  setUp(() => biometrics = FakeBiometrics()
    ..available = true
    ..availableKinds = const [BiometricKind.face, BiometricKind.fingerprint]);

  group('features that are not connected yet', () {
    testWidgets('push, email and WhatsApp are disabled, off, and say "Coming soon"', (tester) async {
      await pumpSettings(tester);

      for (final title in ['Push notifications', 'Email reminders', 'WhatsApp reminders']) {
        final toggle = switchOf(tester, title);
        expect(toggle.onChanged, isNull, reason: '$title must not be switchable');
        expect(toggle.value, isFalse, reason: title);
      }
      expect(find.text('Coming soon'), findsNWidgets(3));
    });

    testWidgets('the settings that do work are unaffected', (tester) async {
      await pumpSettings(tester);

      expect(find.text('Default offsets'), findsOneWidget);
      expect(find.text('Quiet hours'), findsOneWidget);
      expect(find.text('Send test notification'), findsOneWidget);
    });
  });

  group('the fingerprint / Face ID lock', () {
    testWidgets('is on the Settings screen, named for what the device has', (tester) async {
      await pumpSettings(tester);
      expect(find.text('Lock with Face ID or fingerprint'), findsOneWidget);

      biometrics.availableKinds = const [BiometricKind.fingerprint];
      await pumpSettings(tester);
      expect(find.text('Lock with fingerprint'), findsOneWidget);

      biometrics.availableKinds = const [BiometricKind.face];
      await pumpSettings(tester);
      expect(find.text('Lock with Face ID'), findsOneWidget);

      biometrics.availableKinds = const [];
      await pumpSettings(tester);
      expect(find.text('Lock with your screen lock'), findsOneWidget);
    });

    testWidgets('turning it on asks to authenticate once, then it sticks', (tester) async {
      await pumpSettings(tester);
      expect(switchOf(tester, 'Lock with Face ID or fingerprint').value, isFalse);

      await tester.tap(find.byWidget(switchOf(tester, 'Lock with Face ID or fingerprint')));
      await settle(tester);

      expect(biometrics.prompts, 1);
      expect(biometrics.lastReason, 'Confirm to turn on app lock');
      expect(switchOf(tester, 'Lock with Face ID or fingerprint').value, isTrue);
      expect(prefs.prefs.appLock, isTrue);
    });

    testWidgets('if the person is not recognised it stays off and says so', (tester) async {
      biometrics.result = BiometricResult.failed;
      await pumpSettings(tester);

      await tester.tap(find.byWidget(switchOf(tester, 'Lock with Face ID or fingerprint')));
      await settle(tester);

      expect(find.text('Not recognised. Try again.'), findsOneWidget);
      expect(switchOf(tester, 'Lock with Face ID or fingerprint').value, isFalse);
      expect(prefs.prefs.appLock, isFalse);
    });

    testWidgets('backing out of the prompt changes nothing and shows no error', (tester) async {
      biometrics.result = BiometricResult.canceled;
      await pumpSettings(tester);

      await tester.tap(find.byWidget(switchOf(tester, 'Lock with Face ID or fingerprint')));
      await settle(tester);

      expect(find.byType(SnackBar), findsNothing);
      expect(prefs.prefs.appLock, isFalse);
    });

    testWidgets('on a device with no screen lock it is disabled, with the reason', (tester) async {
      biometrics
        ..available = false
        ..availableKinds = const [];
      await pumpSettings(tester);

      expect(switchOf(tester, 'Lock with your screen lock').onChanged, isNull);
      expect(find.text('Set up a screen lock, fingerprint or face on this device to use app lock.'), findsOneWidget);
    });
  });
}
