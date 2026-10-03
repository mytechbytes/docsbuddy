import 'dart:typed_data';

import '../../../core/data/file_storage.dart';
import '../../../core/data/supabase/supabase_guard.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/catalog_inputs.dart';
import '../domain/catalog_models.dart';
import '../domain/catalog_repository.dart';
import '../domain/common_categories.dart';
import 'catalog_mappers.dart';
import 'catalog_remote_data_source.dart';

/// Backend catalog over the 0001 schema: `assets` (only the custom type/properties ride in `metadata`), `locations`
/// find-or-created by name on asset save, `asset_dates` as the **service** rows, and the `complete_asset_date` RPC for
/// completion/recurrence. Everything is family-scoped: the caller's family is resolved (a default "My Home" is created
/// on first use) and RLS scopes all reads and writes.
class RemoteCatalogRepository implements CatalogRepository {
  RemoteCatalogRepository(this._remote, this._files, {required this._logger, Clock clock = DateTime.now})
      : _now = clock;

  final CatalogRemoteDataSource _remote;
  final FileStorage _files;
  final AppLogger _logger;
  final Clock _now;
  String? _familyId;

  Future<String> _family() async {
    if (_familyId != null) return _familyId!;
    final existing = await _remote.firstFamilyId();
    if (existing != null) return _familyId = existing;
    return _familyId = (await _remote.createFamily('My Home'))['id'] as String;
  }

  /// Find-or-create a `locations` row by (family, case-insensitive name).
  Future<String> _locationIdFor(String familyId, String name) async =>
      await _remote.locationIdByName(familyId, name) ??
      await _remote.insertLocation({
        'family_id': familyId,
        'name': name,
        'kind': 'room',
        'created_by': _remote.currentUserId,
      });

  Future<String?> _genericCategoryId(AssetCategoryKind kind) => _remote.categoryIdForSlug(kind.name);

  String _photoPath(String familyId, String folder, String id, String fileName) =>
      '$familyId/$folder/$id/photo/${_now().millisecondsSinceEpoch}_${safeFileName(fileName)}';

  /// Uploads a new photo and deletes the replaced one (best-effort).
  Future<void> _replacePhoto({
    required String path,
    required String? previous,
    required Uint8List bytes,
    required String mimeType,
    required Future<void> Function() savePath,
  }) async {
    await _files.upload(path, bytes, mimeType: mimeType);
    await savePath();
    if (isBucketPath(previous)) {
      try {
        await _files.remove(previous!);
      } catch (e) {
        // Leave the orphan for a maintenance job.
        _logger.warning('Could not delete replaced photo $previous', error: e);
      }
    }
  }

  Json _assetValues(AssetInput i) => {
        'brand': i.brand,
        'model': i.model,
        'serial_no': i.serialNo,
        'purchase_date': i.purchaseDate == null ? null : CatalogMapper.dbDate(i.purchaseDate!),
        'purchase_price': i.purchasePrice,
        'store': i.store,
      };

  Json _dateValues(ReminderInput i) => {
        'label': i.label.trim().isEmpty ? i.kind.label : i.label.trim(),
        'kind': i.kind.name,
        'due_date': CatalogMapper.dbDate(i.dueDate),
        'recurrence': CatalogMapper.recurrenceToDb(i.recurrence),
        'notify_offsets': ?i.notifyOffsets,
        'provider': i.provider,
        'policy_no': i.policyNo,
        'cost': i.cost,
        'notes': i.notes,
      };

  // ── reads ──

  @override
  Future<List<Asset>> assets() => guardBackend(() async => (await _remote.assets()).map(CatalogMapper.asset).toList());

  @override
  Future<Asset> asset(String id) => guardBackend(() async => CatalogMapper.asset(await _remote.asset(id)));

  @override
  Future<List<AssetCategory>> categories() =>
      guardBackend(() async => (await _remote.categories()).map(CatalogMapper.category).toList());

  @override
  Future<List<Location>> locations() =>
      guardBackend(() async => (await _remote.locations()).map(CatalogMapper.location).toList());

  @override
  Future<List<Reminder>> upcomingReminders({int withinDays = 365}) => guardBackend(() async {
        final now = _now();
        return (await _remote.openAssetDates())
            .map((r) => CatalogMapper.reminder(r))
            .where((r) => r.daysLeftOn(now) <= withinDays)
            .toList();
      });

  @override
  Future<List<Reminder>> remindersFor(String assetId) => guardBackend(() async =>
      (await _remote.openAssetDates(assetId: assetId)).map((r) => CatalogMapper.reminder(r, assetName: '')).toList());

  @override
  Future<String?> resolveImageUrl(String? imageRef) async {
    if (imageRef == null || imageRef.isEmpty) return null;
    if (!isBucketPath(imageRef)) return imageRef;
    try {
      return await _files.signedUrl(imageRef, expiresIn: const Duration(hours: 1));
    } catch (e) {
      // Missing object / offline → the UI falls back to the icon.
      _logger.warning('Could not sign image $imageRef', error: e);
      return null;
    }
  }

  // ── assets ──

  @override
  Future<Asset> addAsset(AssetInput input) => guardBackend(() async {
        final familyId = await _family();
        final loc = input.locationName?.trim();
        final locationId = loc == null || loc.isEmpty ? null : await _locationIdFor(familyId, loc);
        // Prefer the real FK; built-in fallback/custom types have no DB row,
        // so they land on the generic group row + metadata.custom_type.
        final hasDbCat = isDbCategoryId(input.categoryId);
        final catId = hasDbCat ? input.categoryId : await _genericCategoryId(input.category);
        final row = await _remote.insertAsset({
          'family_id': familyId,
          'name': input.name.trim(),
          ..._assetValues(input),
          'location_id': locationId,
          'category_id': catId,
          'created_by': _remote.currentUserId,
          'metadata': {
            if (catId == null) 'category': input.category.name,
            if (!hasDbCat && input.typeName != null) 'custom_type': input.typeName,
            if (input.properties.isNotEmpty) 'properties': input.properties,
          },
        });
        return CatalogMapper.asset(row);
      });

  @override
  Future<Asset> updateAsset(String id, AssetInput input) => guardBackend(() async {
        final loc = input.locationName?.trim();
        final locationId = loc == null || loc.isEmpty ? null : await _locationIdFor(await _family(), loc);

        // Merge custom_type/properties into the existing metadata; picking a
        // real catalog type clears any earlier custom type. Custom/fallback
        // types re-anchor on the generic group row.
        final hasDbCat = isDbCategoryId(input.categoryId);
        final genericId = !hasDbCat && input.typeName != null ? await _genericCategoryId(input.category) : null;
        final current = await _remote.assetRow(id, 'metadata');
        final meta = {...((current['metadata'] as Map?)?.cast<String, dynamic>() ?? const {})};
        if (hasDbCat) {
          meta.remove('custom_type');
        } else if (input.typeName != null) {
          meta['custom_type'] = input.typeName;
          if (genericId == null) meta['category'] = input.category.name;
        }
        input.properties.isEmpty ? meta.remove('properties') : meta['properties'] = input.properties;

        final row = await _remote.updateAsset(id, {
          if (input.name.trim().isNotEmpty) 'name': input.name.trim(),
          if (hasDbCat) 'category_id': input.categoryId else if (input.typeName != null) 'category_id': genericId,
          'location_id': ?locationId,
          ..._assetValues(input),
          'metadata': meta,
        });
        return CatalogMapper.asset(row);
      });

  /// Services and document rows cascade via FKs; storage files are left as
  /// orphans (cleaned up by a future maintenance job).
  @override
  Future<void> deleteAsset(String id) => guardBackend(() => _remote.deleteAsset(id));

  @override
  Future<Asset> setAssetImage(
    String assetId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) =>
      guardBackend(() async {
        final row = await _remote.assetRow(assetId, 'family_id, image_url');
        final path = _photoPath(row['family_id'] as String, 'assets', assetId, fileName);
        late Json updated;
        await _replacePhoto(
          path: path,
          previous: row['image_url'] as String?,
          bytes: bytes,
          mimeType: mimeType,
          savePath: () async => updated = await _remote.updateAsset(assetId, {'image_url': path}),
        );
        return CatalogMapper.asset(updated);
      });

  // ── services ──

  @override
  Future<Reminder> addReminder(String assetId, ReminderInput input) => guardBackend(() async {
        final row = await _remote.insertAssetDate({'asset_id': assetId, ..._dateValues(input)});
        return CatalogMapper.reminder(row, assetName: '');
      });

  @override
  Future<Reminder> updateReminder(String id, ReminderInput input) => guardBackend(() async {
        final row = await _remote.updateAssetDate(id, _dateValues(input));
        return CatalogMapper.reminder(row, assetName: '');
      });

  /// Tombstone (deleted_at) so local-first sync can propagate the delete.
  @override
  Future<void> deleteReminder(String id) => guardBackend(
      () => _remote.updateAssetDate(id, {'deleted_at': _now().toUtc().toIso8601String()}));

  @override
  Future<void> completeReminder(String reminderId) => guardBackend(() => _remote.completeAssetDate(reminderId));

  // ── locations ──

  @override
  Future<Location> createLocation(String name) => guardBackend(() async {
        final id = await _locationIdFor(await _family(), name.trim());
        return Location(id: id, name: name.trim());
      });

  @override
  Future<void> updateLocation(String id, {String? name}) => guardBackend(() async {
        if (name == null || name.trim().isEmpty) return;
        await _remote.updateLocation(id, {'name': name.trim()});
      });

  @override
  Future<void> reorderLocations(List<String> orderedIds) => guardBackend(() async {
        for (var i = 0; i < orderedIds.length; i++) {
          await _remote.updateLocation(orderedIds[i], {'sort_order': i});
        }
      });

  @override
  Future<void> setLocationImage(
    String locationId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) =>
      guardBackend(() async {
        final row = await _remote.locationRow(locationId, 'family_id, image_url');
        final path = _photoPath(row['family_id'] as String, 'locations', locationId, fileName);
        await _replacePhoto(
          path: path,
          previous: row['image_url'] as String?,
          bytes: bytes,
          mimeType: mimeType,
          savePath: () => _remote.updateLocation(locationId, {'image_url': path}),
        );
      });
}
