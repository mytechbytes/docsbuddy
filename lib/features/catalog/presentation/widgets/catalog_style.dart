import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/catalog_models.dart';
import '../../../../core/l10n/l10n.dart';

export '../../../../core/widgets/formatters.dart';

/// Visual styling for catalog domain values — bubble palette + icons from
/// the design handoff (`REMINDER_TYPES` in screens/shared.jsx). Kept out of
/// the domain so models stay pure Dart.
extension ReminderKindStyle on ReminderKind {
  Color get bg => switch (this) {
        ReminderKind.insurance => AppColors.insuranceBg,
        ReminderKind.pollution => AppColors.pollutionBg,
        ReminderKind.amc || ReminderKind.fitness => AppColors.amcBg,
        ReminderKind.service => AppColors.serviceBg,
        ReminderKind.tax => AppColors.taxBg,
        ReminderKind.warranty => AppColors.warrantyBg,
        ReminderKind.registration => AppColors.registrationBg,
        ReminderKind.other => AppColors.otherKindBg,
      };

  Color get fg => switch (this) {
        ReminderKind.insurance => AppColors.insuranceFg,
        ReminderKind.pollution => AppColors.pollutionFg,
        ReminderKind.amc || ReminderKind.fitness => AppColors.amcFg,
        ReminderKind.service => AppColors.serviceFg,
        ReminderKind.tax => AppColors.taxFg,
        ReminderKind.warranty => AppColors.warrantyFg,
        ReminderKind.registration => AppColors.registrationFg,
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
String dueCountdown(AppLocalizations l10n, int daysLeft) => daysLeft < 0
    ? l10n.dueOverdueBy(-daysLeft)
    : daysLeft == 0
        ? l10n.dueToday
        : l10n.dueDaysLeft(daysLeft);

/// "in 5 days" / "3d ago" for a date picker hint.
String relativeDays(AppLocalizations l10n, int days) =>
    days < 0 ? l10n.relativeDaysAgo(-days) : l10n.relativeInDays(days);

/// Localized names for catalog domain values (the domain `label`s stay
/// English because some are stored as data).
extension ReminderKindName on ReminderKind {
  String displayName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      ReminderKind.insurance => l.kindInsurance,
      ReminderKind.pollution => l.kindPollution,
      ReminderKind.amc => l.kindAmc,
      ReminderKind.service => l.kindService,
      ReminderKind.tax => l.kindTax,
      ReminderKind.warranty => l.kindWarranty,
      ReminderKind.registration => l.kindRegistration,
      ReminderKind.fitness => l.kindFitness,
      ReminderKind.other => l.kindOther,
    };
  }
}

extension AssetCategoryKindName on AssetCategoryKind {
  String displayName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      AssetCategoryKind.vehicle => l.groupVehicle,
      AssetCategoryKind.appliance => l.groupAppliance,
      AssetCategoryKind.electronics => l.groupElectronics,
      AssetCategoryKind.document => l.groupDocument,
      AssetCategoryKind.other => l.groupOther,
    };
  }
}

extension RecurrenceName on Recurrence {
  String displayName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      Recurrence.none => l.recurrenceNone,
      Recurrence.monthly => l.recurrenceMonthly,
      Recurrence.quarterly => l.recurrenceQuarterly,
      Recurrence.halfYearly => l.recurrenceHalfYearly,
      Recurrence.yearly => l.recurrenceYearly,
    };
  }
}

extension AssetTypeName on Asset {
  /// Specific type when known, else the localized group name.
  String typeName(BuildContext context) => categoryName ?? category.displayName(context);
}
