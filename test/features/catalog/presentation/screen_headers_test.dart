import 'package:docsbuddy/core/widgets/db_logo.dart';
import 'package:docsbuddy/features/catalog/presentation/appliance_picker_page.dart';
import 'package:docsbuddy/features/catalog/presentation/rooms_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

/// The screen name lives in the app bar, the same way on every screen.
void main() {
  Finder inAppBar(Finder matching) => find.descendant(of: find.byType(AppBar), matching: matching);

  testWidgets('Rooms names itself in the app bar, like Assets / Family / Settings', (tester) async {
    await tester.pumpWidget(testApp(const RoomsPage()));
    await settle(tester);

    expect(inAppBar(find.text('Rooms')), findsOneWidget);
    expect(inAppBar(find.byType(DbLogo)), findsNothing);
  });

  testWidgets('appliance picker puts its heading in the app bar, not the body', (tester) async {
    await tester.pumpWidget(testApp(const AppliancePickerPage()));
    await settle(tester);

    expect(inAppBar(find.text('Select Your Appliance')), findsOneWidget);
    expect(find.text('Select Your Appliance'), findsOneWidget);
  });
}
