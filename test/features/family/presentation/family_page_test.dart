import 'package:docsbuddy/features/family/presentation/family_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  testWidgets('shows the empty state when not in a family', (tester) async {
    await tester.pumpWidget(testApp(const FamilyPage()));
    await settle(tester);

    expect(find.text("You're not in a family yet"), findsOneWidget);
    expect(find.text('Create a family'), findsOneWidget);
    expect(find.text('Join with a code'), findsOneWidget);
  });

  testWidgets('create a family, then invite shows members and a code', (tester) async {
    await tester.pumpWidget(testApp(const FamilyPage()));
    await settle(tester);

    await tester.tap(find.text('Create a family'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Kumar Family');
    await tester.tap(find.text('Create'));
    await settle(tester);

    expect(find.text('Kumar Family'), findsOneWidget);
    expect(find.text('You'), findsOneWidget);
    expect(find.text('+91 98123 45678'), findsOneWidget);
    expect(find.text('Owner'), findsOneWidget);

    await tester.tap(find.text('Invite member'));
    await settle(tester);
    expect(find.text('Invite a member'), findsOneWidget);
    expect(find.text('Copy code'), findsOneWidget);
  });
}
