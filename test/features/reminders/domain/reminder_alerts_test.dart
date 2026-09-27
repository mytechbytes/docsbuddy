import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/reminders/domain/reminder_alerts.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/catalog_fixtures.dart';

void main() {
  final now = DateTime(2026, 1, 1, 12);
  Reminder due(int days, {List<int> offsets = const [30, 7, 1]}) =>
      reminderDueIn(days, base: DateTime(2026, 1, 1), offsets: offsets);

  test('schedules only future thresholds, sorted', () {
    // Due in 10 days → the 30-day threshold is past; 7/1/0 are future.
    final alerts = buildReminderAlerts([due(10)], now: now);
    expect(alerts, hasLength(3));
    expect(alerts.every((a) => a.when.isAfter(now)), isTrue);
    expect(alerts.first.when.isBefore(alerts.last.when), isTrue);
  });

  test('past reminders produce no alerts', () {
    expect(buildReminderAlerts([due(-5)], now: now), isEmpty);
  });

  test('honours the cap', () {
    final many = [for (var i = 1; i <= 40; i++) due(i + 1)];
    expect(buildReminderAlerts(many, now: now, cap: 10), hasLength(10));
  });

  test('uses each reminder’s own notify offsets', () {
    // 60d before is in the past; 14d-before and due-day remain.
    expect(buildReminderAlerts([due(59, offsets: const [60, 14])], now: now), hasLength(2));
  });

  test('shifts alert times out of the quiet window', () {
    final alerts =
        buildReminderAlerts([due(9, offsets: const [7])], now: now, hour: 6, quietStart: '22:00', quietEnd: '07:00');
    expect(alerts.every((a) => a.when.hour == 7), isTrue);
  });

  test('alert copy names the asset and the countdown', () {
    final alert = buildReminderAlerts([due(10, offsets: const [7])], now: now).first;
    expect(alert.title, 'Bike — Insurance');
    expect(alert.body, 'Due in 7 days');
    expect(alert.payload, 'asset/a1');
  });
}
