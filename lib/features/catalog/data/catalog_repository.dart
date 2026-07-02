import 'dart:typed_data';

import 'catalog_models.dart';

/// Assets, locations and services/reminders. Backend-agnostic, mirroring the
/// Postgres schema so a Supabase implementation can slot in later.
abstract interface class CatalogRepository {
  Future<List<Reminder>> upcomingReminders({int withinDays = 365});
  Future<List<Asset>> assets();
  Future<Asset> asset(String id);
  Future<List<Reminder>> remindersFor(String assetId);
  Future<List<Location>> locations();

  /// The `asset_categories` catalog (specific appliance/vehicle types with
  /// their default services). Empty when the backend isn't seeded yet.
  Future<List<AssetCategory>> categories();

  Future<Asset> addAsset({
    required String name,
    required AssetCategoryKind category,
    String? categoryId,
    String? locationName,
    String? brand,
    String? model,
    String? serialNo,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? store,
  });

  Future<Reminder> addReminder({
    required String assetId,
    required ReminderKind kind,
    required String label,
    required DateTime dueDate,
    Recurrence recurrence,
    List<int>? notifyOffsets,
    String? provider,
    String? policyNo,
    double? cost,
    String? notes,
  });

  /// Marks the service done — rolls `due_date` forward per its recurrence
  /// (one-offs are completed and disappear from upcoming lists).
  Future<void> completeReminder(String reminderId);

  Future<Location> createLocation(String name);
  Future<void> updateLocation(String id, {String? name});

  /// Uploads/replaces the room's photo and stores its reference on
  /// `locations.image_url`.
  Future<void> setLocationImage(
    String locationId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  });

  /// Uploads/replaces the asset's photo and stores its reference on
  /// `assets.image_url`; returns the updated asset.
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
