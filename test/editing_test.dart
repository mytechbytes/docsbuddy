import 'package:docsbuddy/features/catalog/data/catalog_models.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('updateAsset rewrites fields and keeps reminder rows in sync', () async {
    final repo = FakeCatalogRepository();
    final bike = (await repo.assets()).firstWhere((a) => a.name.contains('Royal Enfield'));

    final updated = await repo.updateAsset(
      bike.id,
      name: 'RE Classic 350 (2023)',
      brand: 'Royal Enfield',
      model: 'Classic 350',
      serialNo: 'TN 09 XY 9999',
      purchasePrice: 210000,
      locationName: 'Basement',
    );
    expect(updated.name, 'RE Classic 350 (2023)');
    expect(updated.serialNo, 'TN 09 XY 9999');
    expect(updated.locationName, 'Basement');

    // The new room was find-or-created and reminders carry the new name.
    expect((await repo.locations()).any((l) => l.name == 'Basement'), isTrue);
    final rs = await repo.remindersFor(bike.id);
    expect(rs.every((r) => r.assetName == 'RE Classic 350 (2023)'), isTrue);
  });

  test('deleteAsset removes the asset and its services', () async {
    final repo = FakeCatalogRepository();
    final bike = (await repo.assets()).firstWhere((a) => a.name.contains('Royal Enfield'));
    expect(await repo.remindersFor(bike.id), isNotEmpty);

    await repo.deleteAsset(bike.id);
    expect((await repo.assets()).where((a) => a.id == bike.id), isEmpty);
    expect(await repo.remindersFor(bike.id), isEmpty);
  });

  test('updateReminder rewrites the service (kind, schedule, cost)', () async {
    final repo = FakeCatalogRepository();
    final bike = (await repo.assets()).first;
    final insurance = (await repo.remindersFor(bike.id)).firstWhere((r) => r.kind == ReminderKind.insurance);

    final due = DateTime.now().add(const Duration(days: 200));
    final updated = await repo.updateReminder(
      insurance.id,
      kind: ReminderKind.insurance,
      label: 'Comprehensive Insurance',
      dueDate: due,
      recurrence: Recurrence.yearly,
      notifyOffsets: const [45, 10],
      provider: 'HDFC Ergo',
      policyNo: 'HDFC-2W-777',
      cost: 5100,
      notes: null,
    );
    expect(updated.label, 'Comprehensive Insurance');
    expect(updated.notifyOffsets, [45, 10]);
    expect(updated.cost, 5100);
    expect(updated.provider, 'HDFC Ergo');

    final reread = (await repo.remindersFor(bike.id)).firstWhere((r) => r.id == insurance.id);
    expect(reread.label, 'Comprehensive Insurance');
  });

  test('deleteReminder removes only that service', () async {
    final repo = FakeCatalogRepository();
    final bike = (await repo.assets()).first;
    final before = await repo.remindersFor(bike.id);
    expect(before.length, greaterThan(1));

    await repo.deleteReminder(before.first.id);
    final after = await repo.remindersFor(bike.id);
    expect(after.length, before.length - 1);
    expect(after.where((r) => r.id == before.first.id), isEmpty);
  });
}
