import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:docsbuddy/features/security/presentation/security_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  late FakeBiometrics biometrics;
  late InMemorySecurityPrefsStore prefs;

  Future<void> pumpPage(WidgetTester tester, {SecurityPrefs initial = const SecurityPrefs()}) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    prefs = InMemorySecurityPrefsStore(initial);
    await tester.pumpWidget(testApp(
      const SecurityPage(),
      overrides: testOverrides(biometrics: biometrics, securityPrefs: prefs),
    ));
    await settle(tester);
  }

  setUp(() => biometrics = FakeBiometrics()
    ..available = true
    ..availableKinds = const [BiometricKind.face, BiometricKind.fingerprint]);

  testWidgets('has one app-lock switch — the old pair ("unlock with biometrics" + "app lock") is gone', (tester) async {
    await pumpPage(tester);

    expect(find.text('APP LOCK'), findsOneWidget, reason: 'the section heading (section labels are upper-case)');
    expect(find.text('Lock with Face ID or fingerprint'), findsOneWidget);
    expect(find.text('Unlock with biometrics'), findsNothing);
    expect(find.text('Require unlock when reopening the app'), findsOneWidget);
    expect(find.text('Available: Face ID · Fingerprint'), findsOneWidget);
  });

  testWidgets('auto-lock only applies while the lock is on', (tester) async {
    await pumpPage(tester);
    expect(tester.widget<Opacity>(find.ancestor(of: find.text('Auto-lock after'), matching: find.byType(Opacity)).first).opacity,
        lessThan(1));
    await tester.tap(find.text('Auto-lock after'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('5 min'), findsNothing, reason: 'the picker must not open while the lock is off');
  });

  testWidgets('with the lock on, auto-lock is live and opens its picker', (tester) async {
    await pumpPage(tester, initial: const SecurityPrefs(appLock: true, autoLockMinutes: 5));

    expect(tester.widget<Opacity>(find.ancestor(of: find.text('Auto-lock after'), matching: find.byType(Opacity)).first).opacity,
        1);
    await tester.tap(find.text('Auto-lock after'));
    await tester.pumpAndSettle();
    expect(find.text('15 minutes'), findsOneWidget);
  });

  testWidgets('turning the lock on here uses the same prompt and the same saved setting as Settings', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byType(Switch).first);
    await settle(tester);

    expect(biometrics.prompts, 1);
    expect(prefs.prefs.appLock, isTrue);
  });
}
