import 'package:docsbuddy/features/catalog/application/default_reminders.dart';
import 'package:docsbuddy/features/catalog/data/catalog_models.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

const _ac = AssetCategory(id: 'c1', slug: 'appliance-ac', name: 'Air Conditioner', defaults: [
  DefaultReminder(kind: ReminderKind.amc, label: 'AMC', startMonths: 12, recurrence: Recurrence.yearly),
  DefaultReminder(kind: ReminderKind.service, label: 'Wet Service', startMonths: 6, recurrence: Recurrence.halfYearly),
  DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 12),
]);

void main() {
  final now = DateTime(2026, 7, 1);

  test('expands defaults relative to the purchase date', () {
    final seeds = expandDefaultReminders(_ac, purchaseDate: DateTime(2026, 6, 1), now: now);
    expect(seeds, hasLength(3));
    final amc = seeds.firstWhere((s) => s.kind == ReminderKind.amc);
    expect(amc.dueDate, DateTime(2027, 6, 1));
    expect(amc.recurrence, Recurrence.yearly);
  });

  test('past recurring dues roll forward; expired one-offs are skipped', () {
    // Bought 2 years ago: warranty (12m one-off) is long gone; the 6-monthly
    // service must land in the future, not the past.
    final seeds = expandDefaultReminders(_ac, purchaseDate: DateTime(2024, 7, 1), now: now);
    expect(seeds.where((s) => s.kind == ReminderKind.warranty), isEmpty);
    final service = seeds.firstWhere((s) => s.kind == ReminderKind.service);
    expect(service.dueDate.isAfter(now), isTrue);
  });

  test('amcDate overrides the AMC default and creates one when absent', () {
    final amcDate = DateTime(2027, 1, 15);
    final seeds = expandDefaultReminders(_ac, purchaseDate: DateTime(2026, 6, 1), amcDate: amcDate, now: now);
    expect(seeds.firstWhere((s) => s.kind == ReminderKind.amc).dueDate, amcDate);

    final none = expandDefaultReminders(null, amcDate: amcDate, now: now);
    expect(none.single.kind, ReminderKind.amc);
    expect(none.single.recurrence, Recurrence.yearly);
  });

  test('no category and no amcDate seeds nothing', () {
    expect(expandDefaultReminders(null, now: now), isEmpty);
  });

  test('fake repo exposes the catalog and links assets to a type', () async {
    final repo = FakeCatalogRepository();
    final cats = await repo.categories();
    expect(cats, isNotEmpty);

    final ac = cats.firstWhere((c) => c.slug == 'appliance-ac');
    final asset = await repo.addAsset(name: 'LG 1.5T', category: AssetCategoryKind.other, categoryId: ac.id);
    expect(asset.categoryName, 'Air Conditioner');
    expect(asset.category, AssetCategoryKind.appliance); // group from the type
    expect(asset.typeLabel, 'Air Conditioner');
  });
}
