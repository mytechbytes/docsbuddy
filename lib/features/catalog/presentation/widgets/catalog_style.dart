import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/catalog_models.dart';

export '../../../../core/widgets/formatters.dart';

/// Visual styling for catalog domain values — bubble palette + icons from
/// the design handoff (`REMINDER_TYPES` in screens/shared.jsx). Kept out of
/// the domain so models stay pure Dart.
extension ReminderKindStyle on ReminderKind {
  Color get bg => switch (this) {
        ReminderKind.insurance => const Color(0xFFE1F1F5),
        ReminderKind.pollution => const Color(0xFFE3F5E7),
        ReminderKind.amc => const Color(0xFFFDF1E0),
        ReminderKind.service => const Color(0xFFFBE7EE),
        ReminderKind.tax => const Color(0xFFE8E4F7),
        ReminderKind.warranty => const Color(0xFFDFECFF),
        ReminderKind.registration => const Color(0xFFE5EFE8),
        ReminderKind.fitness => const Color(0xFFFDF1E0),
        ReminderKind.other => const Color(0xFFEEF1F6),
      };

  Color get fg => switch (this) {
        ReminderKind.insurance => const Color(0xFF3A8FA3),
        ReminderKind.pollution => const Color(0xFF3FA75C),
        ReminderKind.amc => const Color(0xFFC68318),
        ReminderKind.service => const Color(0xFFC63D75),
        ReminderKind.tax => const Color(0xFF6C52C2),
        ReminderKind.warranty => const Color(0xFF2476E8),
        ReminderKind.registration => const Color(0xFF4D8A64),
        ReminderKind.fitness => const Color(0xFFC68318),
        ReminderKind.other => AppColors.muted,
      };

  IconData get icon => switch (this) {
        ReminderKind.insurance => Icons.shield_outlined,
        ReminderKind.pollution => Icons.eco_outlined,
        ReminderKind.amc => Icons.build_outlined,
        ReminderKind.service => Icons.settings_outlined,
        ReminderKind.tax => Icons.currency_rupee,
        ReminderKind.warranty => Icons.verified_outlined,
        ReminderKind.registration => Icons.description_outlined,
        ReminderKind.fitness => Icons.monitor_heart_outlined,
        ReminderKind.other => Icons.event_outlined,
      };
}

extension AssetCategoryKindStyle on AssetCategoryKind {
  IconData get icon => switch (this) {
        AssetCategoryKind.vehicle => Icons.directions_car_outlined,
        AssetCategoryKind.appliance => Icons.kitchen_outlined,
        AssetCategoryKind.electronics => Icons.devices_outlined,
        AssetCategoryKind.document => Icons.folder_outlined,
        AssetCategoryKind.other => Icons.category_outlined,
      };
}

extension AssetCategoryStyle on AssetCategory {
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

/// "Overdue by 3 days" / "Due today" / "5 days left".
String dueCountdown(int daysLeft) => daysLeft < 0
    ? 'Overdue by ${-daysLeft} day${daysLeft == -1 ? '' : 's'}'
    : daysLeft == 0
        ? 'Due today'
        : '$daysLeft day${daysLeft == 1 ? '' : 's'} left';

/// "in 5 days" / "3d ago" for a date picker hint.
String relativeDays(int days) => days < 0 ? '${-days}d ago' : 'in $days day${days == 1 ? '' : 's'}';
