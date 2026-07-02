import 'dart:typed_data';

import 'package:docsbuddy/features/catalog/data/catalog_models.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('createLocation adds a room; duplicates reuse the existing one', () async {
    final repo = FakeCatalogRepository();
    final before = (await repo.locations()).length;

    final room = await repo.createLocation('Study');
    expect((await repo.locations()).length, before + 1);

    final dupe = await repo.createLocation('study');
    expect(dupe.id, room.id);
    expect((await repo.locations()).length, before + 1);
  });

  test('updateLocation renames the room and keeps its assets attached', () async {
    final repo = FakeCatalogRepository();
    final kitchen = (await repo.locations()).firstWhere((l) => l.name == 'Kitchen');
    expect(kitchen.assetCount, 1); // the seeded fridge

    await repo.updateLocation(kitchen.id, name: 'Modular Kitchen');
    final renamed = (await repo.locations()).firstWhere((l) => l.id == kitchen.id);
    expect(renamed.name, 'Modular Kitchen');
    expect(renamed.assetCount, 1); // fridge still registered

    final fridge = (await repo.assets()).firstWhere((a) => a.name.contains('Fridge'));
    expect(fridge.locationName, 'Modular Kitchen');
  });

  test('setLocationImage stores a photo reference on the room', () async {
    final repo = FakeCatalogRepository();
    final room = (await repo.locations()).first;
    expect(room.imageUrl, isNull);

    await repo.setLocationImage(room.id,
        bytes: Uint8List.fromList([1]), fileName: 'kitchen.jpg', mimeType: 'image/jpeg');
    final updated = (await repo.locations()).firstWhere((l) => l.id == room.id);
    expect(updated.imageUrl, isNotNull);
  });

  test('asset counts group by room case-insensitively', () async {
    final repo = FakeCatalogRepository();
    await repo.addAsset(name: 'Mixer', category: AssetCategoryKind.appliance, locationName: 'kitchen');
    final kitchen = (await repo.locations()).firstWhere((l) => l.name.toLowerCase() == 'kitchen');
    expect(kitchen.assetCount, 2);
  });
}
