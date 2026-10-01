import 'package:docsbuddy/features/profile/presentation/profile_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  testWidgets('menu rows render without ListTile ancestor assertions', (tester) async {
    await tester.pumpWidget(testApp(const ProfilePage()));
    await settle(tester);

    // ListTile asserts (debug) if a decorated box sits between it and its
    // Material, which hides the row's background and ink splashes.
    expect(tester.takeException(), isNull);
    expect(find.text('Sign out'), findsOneWidget);
  });
}
