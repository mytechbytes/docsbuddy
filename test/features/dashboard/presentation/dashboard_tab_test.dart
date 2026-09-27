import 'package:docsbuddy/features/dashboard/presentation/dashboard_tab.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  testWidgets('dashboard lists seeded upcoming reminders', (tester) async {
    await tester.pumpWidget(testApp(const DashboardTab()));
    await settle(tester);

    expect(find.text('Upcoming Expirations'), findsOneWidget);
    expect(find.textContaining('Royal Enfield Classic'), findsWidgets);
    expect(find.text('Overdue'), findsWidgets); // the seeded AppleCare reminder
  });
}
