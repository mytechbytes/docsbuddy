import 'package:docsbuddy/features/catalog/presentation/assets_page.dart';
import 'package:docsbuddy/features/dashboard/presentation/dashboard_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => ProviderScope(child: MaterialApp(home: child));

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1)); // elapse the fake repo delay
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('dashboard lists seeded upcoming reminders', (tester) async {
    await tester.pumpWidget(_wrap(const DashboardTab()));
    await _settle(tester);

    expect(find.text('UPCOMING'), findsOneWidget);
    expect(find.textContaining('Royal Enfield Classic'), findsWidgets);
    expect(find.text('Overdue'), findsWidgets); // the seeded AppleCare reminder
  });

  testWidgets('assets page lists seeded assets and the add CTA', (tester) async {
    await tester.pumpWidget(_wrap(const AssetsPage()));
    await _settle(tester);

    expect(find.text('Samsung 340L Fridge'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('Add asset'), findsOneWidget);
  });
}
