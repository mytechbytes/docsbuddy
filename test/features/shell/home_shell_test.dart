import 'package:docsbuddy/features/shell/presentation/home_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('route transitions over the shell do not trip duplicate-hero asserts', (tester) async {
    await tester.pumpWidget(testApp(const HomeShell()));
    await settle(tester);

    // The tabs share one IndexedStack, so every tab's floating button is in the
    // tree at once; a route transition collects all heroes in the subtree.
    final context = tester.element(find.byType(HomeShell));
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('PUSHED'))));
    await tester.pumpAndSettle();
    expect(find.text('PUSHED'), findsOneWidget);

    Navigator.of(context).pop();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
