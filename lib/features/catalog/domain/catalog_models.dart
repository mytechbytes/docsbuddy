import 'package:freezed_annotation/freezed_annotation.dart';

import 'catalog_enums.dart';

export 'catalog_enums.dart';

part 'catalog_models.freezed.dart';

/// A service auto-seeded when an asset of a category is created — one entry
/// of `asset_categories.default_dates`.
@freezed
abstract class DefaultReminder with _$DefaultReminder {
  const factory DefaultReminder({
    required ReminderKind kind,
    required String label,

    /// Months after the purchase date (or creation date) the first due falls.
    required int startMonths,
    @Default(Recurrence.none) Recurrence recurrence,
  }) = _DefaultReminder;
}

/// A row of the `asset_categories` catalog: a specific appliance/vehicle type
/// (or one of the five generic groups) with the services it seeds by default.
@freezed
abstract class AssetCategory with _$AssetCategory {
  const AssetCategory._();

  const factory AssetCategory({
    required String id,
    required String slug,
    required String name,

    /// Icon key (`car`, `fridge`, …) — mapped to an icon by the UI.
    String? iconToken,
    @Default(<DefaultReminder>[]) List<DefaultReminder> defaults,
  }) = _AssetCategory;

  /// Top-level group, encoded as the slug's first segment
  /// (`vehicle-car` → vehicle; generic rows are the segment itself).
  AssetCategoryKind get kindGroup =>
      AssetCategoryKind.values.asNameMap()[slug.split('-').first] ?? AssetCategoryKind.other;

  /// Whether this is one of the five generic group rows (used for backfill).
  bool get isGeneric => !slug.contains('-');
}

/// A room/place in the home — maps `public.locations`.
@freezed
abstract class Location with _$Location {
  const factory Location({
    required String id,
    required String name,
    @Default(0) int assetCount,
    String? kind,
    String? imageUrl,
    String? parentId,
  }) = _Location;
}

@freezed
abstract class Asset with _$Asset {
  const Asset._();

  const factory Asset({
    required String id,
    required String name,
    required AssetCategoryKind category,

    /// FK into `asset_categories` (specific type, e.g. "Air Conditioner").
    String? categoryId,

    /// Specific type name — the joined catalog row, a built-in fallback type,
    /// or a user-entered custom type ("Others" on Add asset).
    String? categoryName,
    String? locationName,
    String? locationId,
    String? brand,
    String? model,
    String? serialNo,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? store,
    String? imageUrl,

    /// Type-specific extras (e.g. Tonnage, IMEI) — `assets.metadata.properties`.
    @Default(<String, String>{}) Map<String, String> properties,
  }) = _Asset;

  /// Specific type when known, else the generic group label.
  String get typeLabel => categoryName ?? category.label;

  String get subtitle => [typeLabel, ?locationName].join(' · ');

  /// Whether the asset sits in [room] (by FK, or by name for legacy rows).
  bool isIn(Location room) =>
      locationId == room.id || (locationName ?? '').toLowerCase() == room.name.toLowerCase();
}

/// A **service** on an asset (insurance, AMC, pollution, road tax, …) — maps
/// an `asset_dates` row 1:1. Its notify offsets are the reminders; documents
/// can attach to it via `documents.asset_date_id`.
@freezed
abstract class Reminder with _$Reminder {
  const Reminder._();

  const factory Reminder({
    required String id,
    required String assetId,
    required String assetName,
    required ReminderKind kind,
    required String label,
    required DateTime dueDate,
    @Default(Recurrence.none) Recurrence recurrence,

    /// Days-before-due to notify at (per service, `asset_dates.notify_offsets`).
    @Default(<int>[30, 7, 1]) List<int> notifyOffsets,
    String? provider,
    String? policyNo,
    double? cost,
    String? notes,

    /// The parent asset's photo reference (bucket path or URL), for list rows.
    String? assetImageUrl,
  }) = _Reminder;

  /// e.g. "30 · 7 · 1d" for the reminder rows / NEXT DUE banner.
  String get offsetsLabel => '${notifyOffsets.join(' · ')}d';

  /// Whole days from [now]'s date to the due date (negative = overdue).
  int daysLeftOn(DateTime now) => calendarDaysBetween(now, dueDate);

  /// Whole days from today (negative = overdue).
  int get daysLeft => daysLeftOn(DateTime.now());

  bool get isOneOff => recurrence == Recurrence.none;
}

/// Whole calendar days from [from]'s date to [to]'s date (negative = past).
int calendarDaysBetween(DateTime from, DateTime to) =>
    DateTime(to.year, to.month, to.day).difference(DateTime(from.year, from.month, from.day)).inDays;
