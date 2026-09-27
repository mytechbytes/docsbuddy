import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/catalog/domain/default_reminders.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/catalog_fixtures.dart';

void main() {
  final now = DateTime(2026, 7, 1);

  test('expands defaults relative to the purchase date', () {
    final seeds = expandDefaultReminders(acCategory, purchaseDate: DateTime(2026, 6, 1), now: now);
    expect(seeds, hasLength(3));
    final amc = seeds.firstWhere((s) => s.kind == ReminderKind.amc);
    expect(amc.dueDate, DateTime(2027, 6, 1));
    expect(amc.recurrence, Recurrence.yearly);
  });

  test('past recurring dues roll forward; expired one-offs are skipped', () {
    // Bought 2 years ago: the 12m warranty is gone; the 6-monthly service
    // must land in the future, not the past.
    final seeds = expandDefaultReminders(acCategory, purchaseDate: DateTime(2024, 7, 1), now: now);
    expect(seeds.where((s) => s.kind == ReminderKind.warranty), isEmpty);
    expect(seeds.firstWhere((s) => s.kind == ReminderKind.service).dueDate.isAfter(now), isTrue);
  });

  test('amcDate overrides the AMC default and creates one when absent', () {
    final amcDate = DateTime(2027, 1, 15);
    final seeds = expandDefaultReminders(acCategory, purchaseDate: DateTime(2026, 6, 1), amcDate: amcDate, now: now);
    expect(seeds.firstWhere((s) => s.kind == ReminderKind.amc).dueDate, amcDate);

    final none = expandDefaultReminders(null, amcDate: amcDate, now: now);
    expect(none.single.kind, ReminderKind.amc);
    expect(none.single.recurrence, Recurrence.yearly);
  });

  test('no category and no amcDate seeds nothing', () {
    expect(expandDefaultReminders(null, now: now), isEmpty);
  });
}
