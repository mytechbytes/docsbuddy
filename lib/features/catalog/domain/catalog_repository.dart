import 'dart:typed_data';

import 'catalog_inputs.dart';
import 'catalog_models.dart';

/// Assets, locations and services/reminders. Backend-agnostic; every method
/// throws an `AppFailure` on error.
abstract interface class CatalogRepository {
  Future<List<Reminder>> upcomingReminders({int withinDays = 365});
  Future<List<Asset>> assets();
  Future<Asset> asset(String id);
  Future<List<Reminder>> remindersFor(String assetId);
  Future<List<Location>> locations();

  /// The `asset_categories` catalog (specific appliance/vehicle types with
  /// their default services). Empty when the backend isn't seeded yet.
  Future<List<AssetCategory>> categories();

  Future<Asset> addAsset(AssetInput input);

  /// Rewrites an asset's editable fields; the location is find-or-created by
  /// name like on create.
  Future<Asset> updateAsset(String id, AssetInput input);

  /// Deletes the asset — its services and document metadata cascade.
  Future<void> deleteAsset(String id);

  Future<Reminder> addReminder(String assetId, ReminderInput input);

  Future<Reminder> updateReminder(String id, ReminderInput input);

  /// Removes a service (tombstoned on the real backend for sync).
  Future<void> deleteReminder(String id);

  /// Marks the service done — rolls `due_date` forward per its recurrence
  /// (one-offs are completed and disappear from upcoming lists).
  Future<void> completeReminder(String reminderId);

  Future<Location> createLocation(String name);
  Future<void> updateLocation(String id, {String? name});

  /// Persists a new room ordering (`locations.sort_order` by list index).
  Future<void> reorderLocations(List<String> orderedIds);

  /// Uploads/replaces the room's photo and stores its reference.
  Future<void> setLocationImage(
    String locationId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  });

  /// Uploads/replaces the asset's photo; returns the updated asset.
  Future<Asset> setAssetImage(
    String assetId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  });

  /// Resolves a stored image reference (private-bucket path or absolute URL)
  /// to a displayable URL — signed for bucket paths; null when unavailable.
  Future<String?> resolveImageUrl(String? imageRef);
}
