import 'package:docsbuddy/features/catalog/domain/asset_search.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/catalog_fixtures.dart';

void main() {
  const bike = Asset(
    id: 'a1',
    name: 'Royal Enfield Classic',
    category: AssetCategoryKind.vehicle,
    serialNo: 'TN 01 AB 1234',
    locationName: 'Garage',
  );

  test('assets match name, serial, room and type case-insensitively', () {
    expect(assetMatches(bike, 'royal'), isTrue);
    expect(assetMatches(bike, 'tn 01'), isTrue);
    expect(assetMatches(bike, 'GARAGE'), isTrue);
    expect(assetMatches(bike, 'vehicle'), isTrue); // type label
    expect(assetMatches(bike, 'fridge'), isFalse);
    expect(assetMatches(bike, '  '), isTrue); // empty query matches all
  });

  test('reminders match label, asset, provider and policy no.', () {
    final r = reminderDueIn(5).copyWith(provider: 'Acko', policyNo: 'ACKO-9');
    expect(reminderMatches(r, 'acko-9'), isTrue);
    expect(reminderMatches(r, 'bike'), isTrue);
    expect(reminderMatches(r, 'zzz'), isFalse);
  });

  test('Asset.isIn matches by FK or by room name', () {
    const room = Location(id: 'l1', name: 'garage');
    expect(bike.isIn(room), isTrue);
    expect(bike.copyWith(locationName: null, locationId: 'l1').isIn(room), isTrue);
    expect(bike.copyWith(locationName: 'Kitchen').isIn(room), isFalse);
  });
}
