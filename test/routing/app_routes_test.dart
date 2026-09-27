import 'package:docsbuddy/features/catalog/domain/reminder_filters.dart';
import 'package:docsbuddy/routing/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parameterised locations', () {
    expect(AppRoutes.asset('a1'), '/asset/a1');
    expect(AppRoutes.addReminder('a1'), '/asset/a1/add-reminder');
    expect(AppRoutes.room('l1'), '/room/l1');
    expect(AppRoutes.reminders(ReminderFilter.expired), '/reminders/expired');
  });

  test('query parameters are encoded and omitted when empty', () {
    expect(AppRoutes.appliancePicker(), '/appliance-picker');
    expect(AppRoutes.appliancePicker(location: ''), '/appliance-picker');
    expect(AppRoutes.appliancePicker(location: 'Living Room'), '/appliance-picker?location=Living+Room');
    expect(AppRoutes.verifyOtp('a+b@x.dev'), '/verify-otp?email=a%2Bb%40x.dev');
    expect(Uri.parse(AppRoutes.assetNew(location: 'Kids & Guests')).queryParameters['location'], 'Kids & Guests');
  });

  test('auth routes are the signed-out allowlist', () {
    expect(AppRoutes.authRoutes, contains(AppRoutes.signIn));
    expect(AppRoutes.authRoutes, isNot(contains(AppRoutes.dashboard)));
  });
}
