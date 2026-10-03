import 'package:docsbuddy/core/features/app_feature.dart';
import 'package:docsbuddy/core/widgets/settings_list.dart';
import 'package:docsbuddy/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  test('nothing unfinished is on in a normal build — each feature opts in with its own flag', () {
    for (final feature in AppFeature.values) {
      expect(feature.live, isFalse, reason: '${feature.name} must be off until its backend is ready');
    }
  });

  test('social sign-in buttons follow the same switch; Google, already set up, is always on', () {
    expect(SocialProvider.google.enabled, isTrue);
    expect(SocialProvider.apple.enabled, AppFeature.appleSignIn.live);
    expect(SocialProvider.microsoft.enabled, AppFeature.microsoftSignIn.live);
  });

  group('FeatureToggleRow', () {
    Future<List<bool>> pumpRow(WidgetTester tester, {required bool live, bool value = true}) async {
      final changes = <bool>[];
      await tester.pumpWidget(testApp(Scaffold(
        body: FeatureToggleRow(
          live: live,
          icon: Icons.mail_outline,
          title: 'Email reminders',
          value: value,
          onChanged: changes.add,
        ),
      )));
      await tester.pumpAndSettle();
      return changes;
    }

    testWidgets('while the feature is not live it is off, disabled and says "Coming soon"', (tester) async {
      final changes = await pumpRow(tester, live: false, value: true);

      expect(find.text('Coming soon'), findsOneWidget);
      final toggle = tester.widget<Switch>(find.byType(Switch));
      expect(toggle.onChanged, isNull, reason: 'cannot be flipped');
      expect(toggle.value, isFalse, reason: 'a stored "on" is not shown as active when nothing will be sent');

      await tester.tap(find.byType(Switch), warnIfMissed: false);
      await tester.pump();
      expect(changes, isEmpty);
    });

    testWidgets('once live it is an ordinary switch showing the stored choice', (tester) async {
      final changes = await pumpRow(tester, live: true, value: true);

      expect(find.text('Coming soon'), findsNothing);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(changes, [false]);
    });
  });
}
