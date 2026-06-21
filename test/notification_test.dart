import 'package:docsbuddy/core/notifications/reminder_schedule.dart';
import 'package:docsbuddy/features/catalog/data/catalog_models.dart';
import 'package:flutter_test/flutter_test.dart';

Reminder _due(int days) => Reminder(
      id: 'r$days',
      assetId: 'a1',
      assetName: 'Bike',
      kind: ReminderKind.insurance,
      label: 'Insurance',
      dueDate: DateTime(2026, 1, 1).add(Duration(days: days)),
    );

void main() {
  final now = DateTime(2026, 1, 1, 12);

  test('schedules only future thresholds', () {
    // Due in 10 days → 30-day threshold is past; 7/1/0 are future.
    final alerts = buildAlerts([_due(10)], now: now);
    expect(alerts, hasLength(3));
    expect(alerts.every((a) => a.when.isAfter(now)), isTrue);
    expect(alerts.first.when.isBefore(alerts.last.when), isTrue); // sorted
  });

  test('past reminders produce no alerts', () {
    expect(buildAlerts([_due(-5)], now: now), isEmpty);
  });

  test('alert ids are stable and deterministic', () {
    expect(stableAlertId('r1', 7), stableAlertId('r1', 7));
    expect(stableAlertId('r1', 7), isNot(stableAlertId('r1', 1)));
  });

  test('honours the cap', () {
    final many = [for (var i = 1; i <= 40; i++) _due(i + 1)];
    expect(buildAlerts(many, now: now, cap: 60).length, lessThanOrEqualTo(60));
  });
}
