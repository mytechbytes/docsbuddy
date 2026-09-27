import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/catalog/domain/reminder_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/catalog_fixtures.dart';

void main() {
  test('stat-card filters segment reminders correctly', () {
    final list = [reminderDueIn(-3), reminderDueIn(0), reminderDueIn(15), reminderDueIn(45)];
    expect(filterReminders(list, ReminderFilter.active), hasLength(4));
    expect(filterReminders(list, ReminderFilter.expired).single.daysLeft, lessThan(0));
    expect(filterReminders(list, ReminderFilter.soon), hasLength(2)); // 0 and 15
    expect(filterReminders(list, ReminderFilter.secured).single.daysLeft, greaterThan(30));
  });

  test('kind filter narrows the list; empty set passes all', () {
    final list = [reminderDueIn(5), reminderDueIn(9, kind: ReminderKind.amc)];
    expect(filterByKinds(list, {}), hasLength(2));
    expect(filterByKinds(list, {ReminderKind.amc}).single.kind, ReminderKind.amc);
  });

  test('alert window follows each reminder’s own offsets', () {
    expect(inAlertWindow(reminderDueIn(20, offsets: const [30])), isTrue);
    expect(inAlertWindow(reminderDueIn(20, offsets: const [7])), isFalse);
    // Due today always alerts; overdue is its own section.
    expect(inAlertWindow(reminderDueIn(0, offsets: const [7])), isTrue);
    expect(inAlertWindow(reminderDueIn(-2)), isFalse);
    expect(isOverdue(reminderDueIn(-2)), isTrue);
  });

  test('urgency ordering, soonest and per-asset grouping', () {
    final a = reminderDueIn(10, assetId: 'a');
    final b = reminderDueIn(-1, assetId: 'b');
    final c = reminderDueIn(3, assetId: 'a');
    final sorted = sortedByUrgency([a, b, c]);
    expect(sorted.map((r) => r.id), [b.id, c.id, a.id]);
    expect(soonest([a, b, c]), b);
    expect(soonest(const []), isNull);
    expect(remindersForAsset('a', [a, b, c]), [c, a]);

    final groups = groupByAsset(sorted);
    expect(groups.map((g) => g.first.assetId), ['b', 'a']); // ordered by soonest
    expect(groups[1], [c, a]);
  });

  test('ReminderFilter.fromName falls back to active', () {
    expect(ReminderFilter.fromName('expired'), ReminderFilter.expired);
    expect(ReminderFilter.fromName('nope'), ReminderFilter.active);
  });
}
