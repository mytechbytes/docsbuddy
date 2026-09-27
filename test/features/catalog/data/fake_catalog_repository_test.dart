import 'dart:typed_data';

import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_inputs.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:flutter_test/flutter_test.dart';

/// The in-memory repository backs local dev and every widget test, so it
/// must honour the same contract as the real one.
void main() {
  late FakeCatalogRepository repo;
  setUp(() => repo = FakeCatalogRepository(latency: Duration.zero));

  Future<Asset> bike() async => (await repo.assets()).firstWhere((a) => a.name.contains('Royal Enfield'));

  group('assets', () {
    test('a built-in type maps to its kind group and name', () async {
      final ac = (await repo.categories()).firstWhere((c) => c.slug == 'appliance-ac');
      final a = await repo.addAsset(AssetInput(
          name: 'Bedroom AC',
          category: AssetCategoryKind.other,
          categoryId: ac.id,
          properties: const {'Tonnage': '1.5 ton'}));
      expect(a.category, AssetCategoryKind.appliance);
      expect(a.typeLabel, 'Air Conditioner');
      expect(a.properties['Tonnage'], '1.5 ton');
    });

    test('custom "Others" type and properties are stored', () async {
      final a = await repo.addAsset(const AssetInput(
          name: 'Bosch Dishwasher',
          category: AssetCategoryKind.appliance,
          typeName: 'Dishwasher',
          properties: {'Place settings': '13'}));
      expect(a.typeLabel, 'Dishwasher');
      final updated = await repo.updateAsset(
          a.id,
          const AssetInput(
              name: 'Bosch Dishwasher',
              category: AssetCategoryKind.appliance,
              typeName: 'Dishwasher',
              properties: {'Place settings': '14'}));
      expect(updated.properties, {'Place settings': '14'});
    });

    test('updateAsset rewrites fields and keeps reminder rows in sync', () async {
      final b = await bike();
      final updated = await repo.updateAsset(
          b.id,
          AssetInput(
            name: 'RE Classic 350 (2023)',
            category: b.category,
            serialNo: 'TN 09 XY 9999',
            purchasePrice: 210000,
            locationName: 'Basement',
          ));
      expect(updated.serialNo, 'TN 09 XY 9999');
      expect(updated.locationName, 'Basement');
      expect((await repo.locations()).any((l) => l.name == 'Basement'), isTrue);
      expect((await repo.remindersFor(b.id)).every((r) => r.assetName == 'RE Classic 350 (2023)'), isTrue);
    });

    test('deleteAsset removes the asset and its services', () async {
      final b = await bike();
      await repo.deleteAsset(b.id);
      expect((await repo.assets()).where((a) => a.id == b.id), isEmpty);
      expect(await repo.remindersFor(b.id), isEmpty);
    });

    test('setAssetImage stores a reference; only URLs resolve offline', () async {
      final b = await bike();
      final updated =
          await repo.setAssetImage(b.id, bytes: Uint8List.fromList([1]), fileName: 'bike.jpg', mimeType: 'image/jpeg');
      expect((await repo.asset(b.id)).imageUrl, updated.imageUrl);
      expect(await repo.resolveImageUrl(updated.imageUrl), isNull);
      expect(await repo.resolveImageUrl('https://example.com/x.jpg'), 'https://example.com/x.jpg');
    });
  });

  group('services', () {
    test('addReminder stores the service fields', () async {
      final r = await repo.addReminder(
          (await bike()).id,
          ReminderInput(
            kind: ReminderKind.insurance,
            label: 'Insurance',
            dueDate: DateTime.now().add(const Duration(days: 90)),
            recurrence: Recurrence.yearly,
            notifyOffsets: const [60, 14, 1],
            provider: 'Acko General',
            cost: 4200,
          ));
      expect(r.offsetsLabel, '60 · 14 · 1d');
      expect(r.cost, 4200);
    });

    test('updateReminder rewrites the service', () async {
      final b = await bike();
      final insurance = (await repo.remindersFor(b.id)).firstWhere((r) => r.kind == ReminderKind.insurance);
      final updated = await repo.updateReminder(
          insurance.id,
          ReminderInput(
            kind: ReminderKind.insurance,
            label: 'Comprehensive Insurance',
            dueDate: DateTime.now().add(const Duration(days: 200)),
            recurrence: Recurrence.yearly,
            notifyOffsets: const [45, 10],
            provider: 'HDFC Ergo',
          ));
      expect(updated.notifyOffsets, [45, 10]);
      expect((await repo.remindersFor(b.id)).firstWhere((r) => r.id == insurance.id).label, 'Comprehensive Insurance');
    });

    test('completing a recurring service rolls it forward; one-offs disappear', () async {
      final b = await bike();
      final due = DateTime.now().add(const Duration(days: 10));
      final recurring = await repo.addReminder(
          b.id,
          ReminderInput(
              kind: ReminderKind.pollution,
              label: 'PUC',
              dueDate: due,
              recurrence: Recurrence.halfYearly,
              provider: 'RTO'));
      final oneOff = await repo.addReminder(b.id, ReminderInput(kind: ReminderKind.warranty, label: 'Ext', dueDate: due));

      await repo.completeReminder(recurring.id);
      await repo.completeReminder(oneOff.id);

      final left = await repo.remindersFor(b.id);
      final rolled = left.firstWhere((r) => r.id == recurring.id);
      expect(rolled.dueDate.month, DateTime(due.year, due.month + 6, due.day).month);
      expect(rolled.provider, 'RTO');
      expect(left.where((r) => r.id == oneOff.id), isEmpty);
    });

    test('deleteReminder removes only that service', () async {
      final b = await bike();
      final before = await repo.remindersFor(b.id);
      await repo.deleteReminder(before.first.id);
      expect(await repo.remindersFor(b.id), hasLength(before.length - 1));
    });
  });

  group('rooms', () {
    test('createLocation reuses an existing name case-insensitively', () async {
      final room = await repo.createLocation('Study');
      expect((await repo.createLocation('study')).id, room.id);
    });

    test('renaming keeps assets attached', () async {
      final kitchen = (await repo.locations()).firstWhere((l) => l.name == 'Kitchen');
      await repo.updateLocation(kitchen.id, name: 'Modular Kitchen');
      final renamed = (await repo.locations()).firstWhere((l) => l.id == kitchen.id);
      expect(renamed.assetCount, 1);
      expect((await repo.assets()).firstWhere((a) => a.name.contains('Fridge')).locationName, 'Modular Kitchen');
    });

    test('reorderLocations persists the new order', () async {
      final reversed = (await repo.locations()).reversed.map((l) => l.id).toList();
      await repo.reorderLocations(reversed);
      expect([for (final l in await repo.locations()) l.id], reversed);
    });

    test('asset counts group by room case-insensitively', () async {
      await repo.addAsset(const AssetInput(name: 'Mixer', category: AssetCategoryKind.appliance, locationName: 'kitchen'));
      expect((await repo.locations()).firstWhere((l) => l.name == 'Kitchen').assetCount, 2);
    });
  });
}
