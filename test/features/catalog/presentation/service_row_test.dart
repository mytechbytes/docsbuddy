import 'package:docsbuddy/features/catalog/presentation/widgets/asset_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/catalog_fixtures.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets('a service with many reminder offsets fits a narrow phone without overflowing', (tester) async {
    // The row's text column only gets ~130px beside the icon, day pill and menu.
    tester.view
      ..physicalSize = const Size(360, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(testApp(Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ServiceRow(
            reminder: reminderDueIn(40, offsets: const [60, 30, 14, 7, 3, 1]),
            onTap: () {},
            onAction: (_) {},
          ),
        ],
      ),
    )));
    await settle(tester);

    // A RenderFlex overflow is reported as a framework exception.
    expect(tester.takeException(), isNull);
    expect(find.text('Insurance'), findsOneWidget);
  });
}
