import 'package:docsbuddy/features/family/presentation/family_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness() => const ProviderScope(
      child: MaterialApp(home: FamilyPage()),
    );

/// Elapses the fake repository's delays (which are timers, not frames) and
/// settles any animations.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the empty state when not in a family', (tester) async {
    await tester.pumpWidget(_harness());
    await _settle(tester);

    expect(find.text("You're not in a family yet"), findsOneWidget);
    expect(find.text('Create a family'), findsOneWidget);
    expect(find.text('Join with a code'), findsOneWidget);
  });

  testWidgets('create a family, then invite shows members and a code', (tester) async {
    await tester.pumpWidget(_harness());
    await _settle(tester);

    // Open the create dialog and submit a name.
    await tester.tap(find.text('Create a family'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Kumar Family');
    await tester.tap(find.text('Create'));
    await _settle(tester);

    // Family view with the owner listed.
    expect(find.text('Kumar Family'), findsOneWidget);
    expect(find.text('You'), findsOneWidget);
    expect(find.text('Owner'), findsOneWidget);

    // Invite flow surfaces a shareable code sheet.
    await tester.tap(find.text('Invite member'));
    await _settle(tester);
    expect(find.text('Invite a member'), findsOneWidget);
    expect(find.text('Copy code'), findsOneWidget);
  });
}
