import 'package:docsbuddy/features/catalog/application/reminder_filters.dart';
import 'package:docsbuddy/features/catalog/data/catalog_models.dart';
import 'package:docsbuddy/features/catalog/presentation/notifications_page.dart';
import 'package:flutter_test/flutter_test.dart';

Reminder _due(int days, {ReminderKind kind = ReminderKind.insurance, List<int> offsets = const [30, 7, 1]}) =>
    Reminder(
      id: 'r$days-${kind.name}',
      assetId: 'a1',
      assetName: 'Bike',
      kind: kind,
      label: kind.label,
      dueDate: DateTime.now().add(Duration(days: days)),
      notifyOffsets: offsets,
    );

void main() {
  test('stat-card filters segment reminders correctly', () {
    final list = [_due(-3), _due(0), _due(15), _due(45)];
    expect(filterReminders(list, ReminderFilter.active), hasLength(4));
    expect(filterReminders(list, ReminderFilter.expired).single.daysLeft, lessThan(0));
    expect(filterReminders(list, ReminderFilter.soon), hasLength(2)); // 0 and 15
    expect(filterReminders(list, ReminderFilter.secured).single.daysLeft, greaterThan(30));
  });

  test('kind filter narrows the upcoming list; empty set passes all', () {
    final list = [_due(5), _due(9, kind: ReminderKind.amc)];
    expect(filterByKinds(list, {}), hasLength(2));
    expect(filterByKinds(list, {ReminderKind.amc}).single.kind, ReminderKind.amc);
  });

  test('notification window follows each reminder’s own offsets', () {
    // 20 days out with a 30d offset → inside the window.
    expect(NotificationsPage.inAlertWindow(_due(20, offsets: const [30])), isTrue);
    // 20 days out with only a 7d offset → not yet.
    expect(NotificationsPage.inAlertWindow(_due(20, offsets: const [7])), isFalse);
    // Due today always alerts; overdue is its own section.
    expect(NotificationsPage.inAlertWindow(_due(0, offsets: const [7])), isTrue);
    expect(NotificationsPage.inAlertWindow(_due(-2)), isFalse);
  });
}
