import 'package:docsbuddy/features/catalog/presentation/add_asset_page.dart';
import 'package:docsbuddy/features/catalog/presentation/assets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  testWidgets('assets page lists seeded assets and filters by search', (tester) async {
    await tester.pumpWidget(testApp(const AssetsPage()));
    await settle(tester);

    expect(find.text('Samsung 340L Fridge'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('Add asset'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'fridge');
    await settle(tester);
    expect(find.text('Samsung 340L Fridge'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsNothing);
  });

  testWidgets('saving an asset without a name shows the validation message', (tester) async {
    await tester.pumpWidget(testApp(const AddAssetPage()));
    await settle(tester);

    // Category → type (skip) → details.
    await tester.tap(find.text('Vehicle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save asset'));
    await settle(tester);

    expect(find.text('Please enter a name.'), findsOneWidget);
  });
}
