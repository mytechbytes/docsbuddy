import 'dart:typed_data';

import 'package:docsbuddy/features/catalog/data/catalog_models.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('addReminder stores the service fields', () async {
    final repo = FakeCatalogRepository();
    final asset = (await repo.assets()).first;

    final r = await repo.addReminder(
      assetId: asset.id,
      kind: ReminderKind.insurance,
      label: 'Insurance',
      dueDate: DateTime.now().add(const Duration(days: 90)),
      recurrence: Recurrence.yearly,
      notifyOffsets: const [60, 14, 1],
      provider: 'Acko General',
      policyNo: 'ACKO-123',
      cost: 4200,
      notes: 'Zero-dep add-on',
    );

    expect(r.notifyOffsets, [60, 14, 1]);
    expect(r.provider, 'Acko General');
    expect(r.policyNo, 'ACKO-123');
    expect(r.cost, 4200);
    expect(r.offsetsLabel, '60 · 14 · 1d');
  });

  test('completing a recurring service rolls its due date forward', () async {
    final repo = FakeCatalogRepository();
    final asset = (await repo.assets()).first;
    final due = DateTime.now().add(const Duration(days: 10));

    final r = await repo.addReminder(
      assetId: asset.id,
      kind: ReminderKind.pollution,
      label: 'PUC check',
      dueDate: due,
      recurrence: Recurrence.halfYearly,
      provider: 'RTO Center',
    );
    await repo.completeReminder(r.id);

    final rolled = (await repo.remindersFor(asset.id)).firstWhere((x) => x.id == r.id);
    expect(rolled.dueDate.month, DateTime(due.year, due.month + 6, due.day).month);
    expect(rolled.provider, 'RTO Center'); // service fields survive the roll
  });

  test('completing a one-off service removes it', () async {
    final repo = FakeCatalogRepository();
    final asset = (await repo.assets()).first;

    final r = await repo.addReminder(
      assetId: asset.id,
      kind: ReminderKind.warranty,
      label: 'Extended warranty',
      dueDate: DateTime.now().add(const Duration(days: 30)),
    );
    await repo.completeReminder(r.id);

    final left = await repo.remindersFor(asset.id);
    expect(left.where((x) => x.id == r.id), isEmpty);
  });

  test('adding an asset find-or-creates its location', () async {
    final repo = FakeCatalogRepository();
    final before = (await repo.locations()).length;

    await repo.addAsset(name: 'Dyson V12', category: AssetCategoryKind.appliance, locationName: 'Living Room');
    final after = await repo.locations();
    expect(after.length, before + 1);
    expect(after.any((l) => l.name == 'Living Room' && l.assetCount == 1), isTrue);

    // Same name (case-insensitive) reuses the row.
    await repo.addAsset(name: 'TV', category: AssetCategoryKind.electronics, locationName: 'living room');
    expect((await repo.locations()).length, after.length);
  });

  test('setAssetImage stores a photo reference on the asset', () async {
    final repo = FakeCatalogRepository();
    final asset = (await repo.assets()).first;
    expect(asset.imageUrl, isNull);

    final updated = await repo.setAssetImage(
      asset.id,
      bytes: Uint8List.fromList([1, 2, 3]),
      fileName: 'bike.jpg',
      mimeType: 'image/jpeg',
    );
    expect(updated.imageUrl, isNotNull);
    expect((await repo.asset(asset.id)).imageUrl, updated.imageUrl);

    // Bucket paths only resolve with real storage; http refs pass through.
    expect(await repo.resolveImageUrl(updated.imageUrl), isNull);
    expect(await repo.resolveImageUrl('https://example.com/x.jpg'), 'https://example.com/x.jpg');
  });
}
