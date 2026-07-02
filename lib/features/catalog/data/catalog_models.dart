import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Reminder/document kinds, each with the bubble palette + icon from the design
/// handoff (`REMINDER_TYPES` in screens/shared.jsx).
enum ReminderKind {
  insurance(Color(0xFFE1F1F5), Color(0xFF3A8FA3), Icons.shield_outlined, 'Insurance'),
  pollution(Color(0xFFE3F5E7), Color(0xFF3FA75C), Icons.eco_outlined, 'Pollution'),
  amc(Color(0xFFFDF1E0), Color(0xFFC68318), Icons.build_outlined, 'AMC'),
  service(Color(0xFFFBE7EE), Color(0xFFC63D75), Icons.settings_outlined, 'Service'),
  tax(Color(0xFFE8E4F7), Color(0xFF6C52C2), Icons.currency_rupee, 'Tax'),
  warranty(Color(0xFFDFECFF), Color(0xFF2476E8), Icons.verified_outlined, 'Warranty'),
  registration(Color(0xFFE5EFE8), Color(0xFF4D8A64), Icons.description_outlined, 'Registration'),
  fitness(Color(0xFFFDF1E0), Color(0xFFC68318), Icons.monitor_heart_outlined, 'Fitness'),
  other(Color(0xFFEEF1F6), AppColors.muted, Icons.event_outlined, 'Other');

  const ReminderKind(this.bg, this.fg, this.icon, this.label);
  final Color bg;
  final Color fg;
  final IconData icon;
  final String label;
}

/// Top-level asset categories.
enum AssetCategoryKind {
  vehicle(Icons.directions_car_outlined, 'Vehicle'),
  appliance(Icons.kitchen_outlined, 'Appliance'),
  electronics(Icons.devices_outlined, 'Electronics'),
  document(Icons.folder_outlined, 'Document'),
  other(Icons.category_outlined, 'Other');

  const AssetCategoryKind(this.icon, this.label);
  final IconData icon;
  final String label;
}

enum Recurrence {
  none('None'),
  monthly('Monthly'),
  quarterly('Quarterly'),
  halfYearly('Half-yearly'),
  yearly('Yearly');

  const Recurrence(this.label);
  final String label;
}

/// A service auto-seeded when an asset of a category is created — one entry
/// of `asset_categories.default_dates`.
class DefaultReminder {
  const DefaultReminder({
    required this.kind,
    required this.label,
    required this.startMonths,
    this.recurrence = Recurrence.none,
  });

  final ReminderKind kind;
  final String label;

  /// Months after the purchase date (or creation date) the first due falls.
  final int startMonths;
  final Recurrence recurrence;

  factory DefaultReminder.fromJson(Map<String, dynamic> j) => DefaultReminder(
        kind: ReminderKind.values.asNameMap()[j['kind']] ?? ReminderKind.other,
        label: (j['label'] as String?) ?? 'Reminder',
        startMonths: (j['start_months'] as num?)?.toInt() ?? 12,
        recurrence: switch (j['recurrence']) {
          'monthly' => Recurrence.monthly,
          'quarterly' => Recurrence.quarterly,
          'half_yearly' => Recurrence.halfYearly,
          'yearly' => Recurrence.yearly,
          _ => Recurrence.none,
        },
      );
}

/// A row of the `asset_categories` catalog: a specific appliance/vehicle type
/// (or one of the five generic groups) with the services it seeds by default.
class AssetCategory {
  const AssetCategory({
    required this.id,
    required this.slug,
    required this.name,
    this.iconToken,
    this.defaults = const [],
  });

  final String id;
  final String slug;
  final String name;
  final String? iconToken;
  final List<DefaultReminder> defaults;

  /// Top-level group, encoded as the slug's first segment
  /// (`vehicle-car` → vehicle; generic rows are the segment itself).
  AssetCategoryKind get kindGroup {
    final prefix = slug.split('-').first;
    return AssetCategoryKind.values.asNameMap()[prefix] ?? AssetCategoryKind.other;
  }

  /// Whether this is one of the five generic group rows (used for backfill).
  bool get isGeneric => !slug.contains('-');

  IconData get icon => switch (iconToken) {
        'car' => Icons.directions_car_outlined,
        'bike' => Icons.two_wheeler_outlined,
        'ac' => Icons.ac_unit_outlined,
        'fridge' => Icons.kitchen_outlined,
        'washer' => Icons.local_laundry_service_outlined,
        'water' => Icons.water_drop_outlined,
        'tv' => Icons.tv_outlined,
        'microwave' => Icons.microwave_outlined,
        'air' => Icons.air_outlined,
        'heater' => Icons.hot_tub_outlined,
        'chimney' => Icons.fireplace_outlined,
        'phone' => Icons.smartphone_outlined,
        'laptop' => Icons.laptop_outlined,
        'plug' => Icons.power_outlined,
        'devices' => Icons.devices_outlined,
        'folder' => Icons.folder_outlined,
        _ => kindGroup.icon,
      };
}

/// A room/place in the home — maps `public.locations` (real table, not the
/// old metadata grouping).
class Location {
  const Location({
    required this.id,
    required this.name,
    this.assetCount = 0,
    this.kind,
    this.imageUrl,
    this.parentId,
  });

  final String id;
  final String name;
  final int assetCount;
  final String? kind;
  final String? imageUrl;
  final String? parentId;
}

class Asset {
  const Asset({
    required this.id,
    required this.name,
    required this.category,
    this.categoryId,
    this.categoryName,
    this.locationName,
    this.locationId,
    this.brand,
    this.model,
    this.serialNo,
    this.purchaseDate,
    this.purchasePrice,
    this.store,
    this.imageUrl,
  });

  final String id;
  final String name;
  final AssetCategoryKind category;

  /// FK into `asset_categories` (specific type, e.g. "Air Conditioner").
  final String? categoryId;
  final String? categoryName;
  final String? locationName;
  final String? locationId;
  final String? brand;
  final String? model;
  final String? serialNo;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String? store;
  final String? imageUrl;

  /// Specific type when known, else the generic group label.
  String get typeLabel => categoryName ?? category.label;

  String get subtitle => [typeLabel, if (locationName != null) locationName].join(' · ');
}

/// A **service** on an asset (insurance, AMC, pollution, road tax, …) — maps
/// an `asset_dates` row 1:1. Its notify offsets are the reminders; documents
/// can attach to it via `documents.asset_date_id`.
class Reminder {
  const Reminder({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.kind,
    required this.label,
    required this.dueDate,
    this.recurrence = Recurrence.none,
    this.notifyOffsets = const [30, 7, 1],
    this.provider,
    this.policyNo,
    this.cost,
    this.notes,
    this.assetImageUrl,
  });

  final String id;
  final String assetId;
  final String assetName;
  final ReminderKind kind;
  final String label;
  final DateTime dueDate;
  final Recurrence recurrence;

  /// Days-before-due to notify at (per service, `asset_dates.notify_offsets`).
  final List<int> notifyOffsets;
  final String? provider;
  final String? policyNo;
  final double? cost;
  final String? notes;

  /// The parent asset's photo reference (bucket path or URL), for list rows.
  final String? assetImageUrl;

  /// e.g. "30 · 7 · 1d" for the reminder rows / NEXT DUE banner.
  String get offsetsLabel => '${notifyOffsets.join(' · ')}d';

  /// Whole days from today (negative = overdue).
  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.difference(today).inDays;
  }
}
