import 'dart:typed_data';

import 'package:docsbuddy/core/data/file_storage.dart';
import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/catalog/data/catalog_remote_data_source.dart';
import 'package:docsbuddy/features/catalog/data/remote_catalog_repository.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_inputs.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockRemote extends Mock implements CatalogRemoteDataSource {}

class _MockFiles extends Mock implements FileStorage {}

const _dbCat = '11111111-2222-3333-4444-555555555555';

Json _assetRow({String id = 'a1', String name = 'Bike'}) => {'id': id, 'name': name, 'metadata': <String, dynamic>{}};

void main() {
  late _MockRemote remote;
  late _MockFiles files;
  late RemoteCatalogRepository repo;
  final now = DateTime(2026, 1, 1, 9);

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    remote = _MockRemote();
    files = _MockFiles();
    repo = RemoteCatalogRepository(remote, files, clock: () => now);
    when(() => remote.currentUserId).thenReturn('u1');
    when(() => remote.firstFamilyId()).thenAnswer((_) async => 'fam1');
  });

  test('reads map JSON rows to models', () async {
    when(() => remote.assets()).thenAnswer((_) async => [_assetRow(), _assetRow(id: 'a2', name: 'Fridge')]);
    final assets = await repo.assets();
    expect(assets.map((a) => a.name), ['Bike', 'Fridge']);
  });

  test('upcoming reminders are limited to the window', () async {
    Json row(String id, String due) => {'id': id, 'asset_id': 'a1', 'label': 'Insurance', 'due_date': due};
    when(() => remote.openAssetDates()).thenAnswer((_) async => [row('near', '2026-02-01'), row('far', '2028-01-01')]);
    expect((await repo.upcomingReminders()).map((r) => r.id), ['near']);
  });

  test('backend errors surface as AppFailure', () async {
    when(() => remote.assets()).thenThrow(const PostgrestException(message: 'permission denied'));
    await expectLater(repo.assets(), throwsA(isA<ServerFailure>()));
  });

  group('addAsset', () {
    setUp(() {
      when(() => remote.insertAsset(any())).thenAnswer((_) async => _assetRow());
      when(() => remote.locationIdByName('fam1', 'Garage')).thenAnswer((_) async => null);
      when(() => remote.insertLocation(any())).thenAnswer((_) async => 'loc1');
    });

    test('find-or-creates the room and keeps a real category FK', () async {
      await repo.addAsset(const AssetInput(
        name: ' Bike ',
        category: AssetCategoryKind.vehicle,
        categoryId: _dbCat,
        locationName: 'Garage',
        purchaseDate: null,
        properties: {'Fuel type': 'Petrol'},
      ));
      final values = verify(() => remote.insertAsset(captureAny())).captured.single as Json;
      expect(values['family_id'], 'fam1');
      expect(values['name'], 'Bike');
      expect(values['location_id'], 'loc1');
      expect(values['category_id'], _dbCat);
      expect(values['metadata'], {
        'properties': {'Fuel type': 'Petrol'},
      });
      verifyNever(() => remote.categoryIdForSlug(any()));
    });

    test('custom types anchor on the generic group row with a custom_type', () async {
      when(() => remote.categoryIdForSlug('appliance')).thenAnswer((_) async => 'generic-appliance');
      await repo.addAsset(
          const AssetInput(name: 'Dishwasher', category: AssetCategoryKind.appliance, typeName: 'Dishwasher'));
      final values = verify(() => remote.insertAsset(captureAny())).captured.single as Json;
      expect(values['category_id'], 'generic-appliance');
      expect(values['metadata'], {'custom_type': 'Dishwasher'});
    });

    test('creates a default family on first use', () async {
      when(() => remote.firstFamilyId()).thenAnswer((_) async => null);
      when(() => remote.createFamily('My Home')).thenAnswer((_) async => {'id': 'fresh'});
      when(() => remote.categoryIdForSlug(any())).thenAnswer((_) async => null);
      await repo.addAsset(const AssetInput(name: 'Car', category: AssetCategoryKind.vehicle));
      final values = verify(() => remote.insertAsset(captureAny())).captured.single as Json;
      expect(values['family_id'], 'fresh');
      expect((values['metadata'] as Map)['category'], 'vehicle');
    });
  });

  test('updateAsset merges metadata and clears a stale custom type', () async {
    when(() => remote.assetRow('a1', 'metadata')).thenAnswer((_) async => {
          'metadata': {'custom_type': 'Old', 'properties': {'x': '1'}, 'keep': true},
        });
    when(() => remote.updateAsset('a1', any())).thenAnswer((_) async => _assetRow());
    await repo.updateAsset('a1', const AssetInput(name: 'AC', category: AssetCategoryKind.appliance, categoryId: _dbCat));
    final values = verify(() => remote.updateAsset('a1', captureAny())).captured.single as Json;
    expect(values['category_id'], _dbCat);
    expect(values['metadata'], {'keep': true}); // custom_type and empty properties removed
  });

  test('deleteReminder tombstones with the injected clock', () async {
    when(() => remote.updateAssetDate('r1', any())).thenAnswer((_) async => {});
    await repo.deleteReminder('r1');
    final values = verify(() => remote.updateAssetDate('r1', captureAny())).captured.single as Json;
    expect(values['deleted_at'], now.toUtc().toIso8601String());
  });

  test('addReminder defaults a blank label to the kind', () async {
    when(() => remote.insertAssetDate(any()))
        .thenAnswer((_) async => {'id': 'r1', 'asset_id': 'a1', 'label': 'AMC', 'due_date': '2026-06-01'});
    await repo.addReminder(
        'a1', ReminderInput(kind: ReminderKind.amc, label: ' ', dueDate: DateTime(2026, 6, 1), notifyOffsets: [7]));
    final values = verify(() => remote.insertAssetDate(captureAny())).captured.single as Json;
    expect(values['label'], 'AMC');
    expect(values['due_date'], '2026-06-01');
    expect(values['notify_offsets'], [7]);
  });

  test('setAssetImage uploads under the family path and removes the old photo', () async {
    when(() => remote.assetRow('a1', 'family_id, image_url'))
        .thenAnswer((_) async => {'family_id': 'fam1', 'image_url': 'fam1/assets/a1/photo/old.jpg'});
    when(() => files.upload(any(), any(), mimeType: any(named: 'mimeType'))).thenAnswer((_) async {});
    when(() => files.remove(any())).thenAnswer((_) async {});
    when(() => remote.updateAsset('a1', any())).thenAnswer((_) async => _assetRow());

    await repo.setAssetImage('a1', bytes: Uint8List(1), fileName: 'my photo.jpg', mimeType: 'image/jpeg');

    final path = verify(() => files.upload(captureAny(), any(), mimeType: 'image/jpeg')).captured.single as String;
    expect(path, 'fam1/assets/a1/photo/${now.millisecondsSinceEpoch}_my_photo.jpg');
    verify(() => remote.updateAsset('a1', {'image_url': path})).called(1);
    verify(() => files.remove('fam1/assets/a1/photo/old.jpg')).called(1);
  });

  test('resolveImageUrl signs bucket paths, passes URLs, swallows failures', () async {
    when(() => files.signedUrl('p/x.jpg', expiresIn: any(named: 'expiresIn'))).thenAnswer((_) async => 'signed');
    when(() => files.signedUrl('missing', expiresIn: any(named: 'expiresIn'))).thenThrow(Exception('404'));
    expect(await repo.resolveImageUrl('p/x.jpg'), 'signed');
    expect(await repo.resolveImageUrl('https://cdn/x.jpg'), 'https://cdn/x.jpg');
    expect(await repo.resolveImageUrl('missing'), isNull);
    expect(await repo.resolveImageUrl(null), isNull);
  });
}
