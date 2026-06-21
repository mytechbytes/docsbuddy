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

class Location {
  const Location({required this.id, required this.name, this.assetCount = 0});
  final String id;
  final String name;
  final int assetCount;
}

class Asset {
  const Asset({
    required this.id,
    required this.name,
    required this.category,
    this.locationName,
    this.brand,
    this.model,
  });

  final String id;
  final String name;
  final AssetCategoryKind category;
  final String? locationName;
  final String? brand;
  final String? model;

  String get subtitle => [category.label, if (locationName != null) locationName].join(' · ');
}

class Reminder {
  const Reminder({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.kind,
    required this.label,
    required this.dueDate,
    this.recurrence = Recurrence.none,
  });

  final String id;
  final String assetId;
  final String assetName;
  final ReminderKind kind;
  final String label;
  final DateTime dueDate;
  final Recurrence recurrence;

  /// Whole days from today (negative = overdue).
  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.difference(today).inDays;
  }
}
