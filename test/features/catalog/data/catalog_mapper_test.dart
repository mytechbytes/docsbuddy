import 'package:docsbuddy/features/catalog/data/catalog_mappers.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('asset rows', () {
    test('maps columns, joined type and location', () {
      final a = CatalogMapper.asset({
        'id': 'a1',
        'name': 'Bedroom AC',
        'brand': 'LG',
        'purchase_date': '2025-03-12',
        'purchase_price': 42000,
        'category_id': 'uuid-1',
        'location_id': 'l1',
        'metadata': {
          'properties': {'Tonnage': '1.5 ton', 'Stars': 5},
        },
        'locations': {'name': 'Bedroom'},
        'asset_categories': {'slug': 'appliance-ac', 'name': 'Air Conditioner'},
      });
      expect(a.category, AssetCategoryKind.appliance);
      expect(a.categoryName, 'Air Conditioner');
      expect(a.locationName, 'Bedroom');
      expect(a.purchaseDate, DateTime(2025, 3, 12));
      expect(a.purchasePrice, 42000.0);
      expect(a.properties, {'Tonnage': '1.5 ton', 'Stars': '5'}); // values stringified
    });

    test('generic-group rows fall back to metadata custom type / legacy keys', () {
      final a = CatalogMapper.asset({
        'id': 'a2',
        'name': 'Dishwasher',
        'metadata': {'custom_type': 'Dishwasher', 'location': 'Kitchen'},
        'asset_categories': {'slug': 'appliance', 'name': 'Appliance'},
      });
      expect(a.category, AssetCategoryKind.appliance);
      expect(a.categoryName, 'Dishwasher');
      expect(a.locationName, 'Kitchen');
    });

    test('pre-backfill rows read the group from metadata', () {
      final a = CatalogMapper.asset({
        'id': 'a3',
        'name': 'Car',
        'metadata': {'category': 'vehicle'},
      });
      expect(a.category, AssetCategoryKind.vehicle);
      expect(a.properties, isEmpty);
    });
  });

  test('reminder rows: stored kind wins, label is the legacy fallback', () {
    final r = CatalogMapper.reminder({
      'id': 'r1',
      'asset_id': 'a1',
      'label': 'Insurance',
      'kind': 'tax',
      'due_date': '2026-05-01',
      'recurrence': 'half_yearly',
      'notify_offsets': [60, 7],
      'cost': 4200,
      'assets': {'name': 'Bike', 'image_url': 'fam/a1/photo.jpg'},
    });
    expect(r.kind, ReminderKind.tax);
    expect(r.recurrence, Recurrence.halfYearly);
    expect(r.notifyOffsets, [60, 7]);
    expect(r.assetName, 'Bike');
    expect(r.assetImageUrl, 'fam/a1/photo.jpg');
    expect(r.cost, 4200.0);

    final legacy = CatalogMapper.reminder({
      'id': 'r2',
      'asset_id': 'a1',
      'label': 'pollution',
      'due_date': '2026-05-01',
    }, assetName: 'Bike');
    expect(legacy.kind, ReminderKind.pollution);
    expect(legacy.notifyOffsets, [30, 7, 1]); // default
  });

  test('location rows read the embedded asset count', () {
    expect(CatalogMapper.location({'id': 'l1', 'name': 'Kitchen', 'assets': [{'count': 3}]}).assetCount, 3);
    expect(CatalogMapper.location({'id': 'l2', 'name': 'Empty', 'assets': []}).assetCount, 0);
  });

  test('category rows parse default_dates', () {
    final c = CatalogMapper.category({
      'id': 'c1',
      'slug': 'vehicle-car',
      'name': 'Car',
      'icon': 'car',
      'default_dates': [
        {'kind': 'insurance', 'label': 'Insurance', 'start_months': 12, 'recurrence': 'yearly'},
        'junk',
      ],
    });
    expect(c.kindGroup, AssetCategoryKind.vehicle);
    expect(c.defaults.single.recurrence, Recurrence.yearly);
  });

  test('recurrence and date codecs round-trip', () {
    for (final r in Recurrence.values) {
      expect(CatalogMapper.recurrenceFromDb(CatalogMapper.recurrenceToDb(r)), r);
    }
    expect(CatalogMapper.dbDate(DateTime(2026, 2, 3, 14, 5)), '2026-02-03');
  });
}
