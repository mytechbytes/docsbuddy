import 'catalog_models.dart';

/// Built-in appliance-type catalog, mirroring the `0005_asset_categories.sql`
/// seed. Used by the fake repository and as the fallback whenever the backend
/// catalog is empty/unreachable — the type picker is never blank.
///
/// The ids are NOT database UUIDs; repositories treat them as "no FK" and
/// carry the type name in `assets.metadata` instead.
const commonAssetCategories = <AssetCategory>[
  AssetCategory(id: 'cat_car', slug: 'vehicle-car', name: 'Car', iconToken: 'car', defaults: [
    DefaultReminder(kind: ReminderKind.insurance, label: 'Insurance', startMonths: 12, recurrence: Recurrence.yearly),
    DefaultReminder(kind: ReminderKind.pollution, label: 'Pollution (PUC)', startMonths: 6, recurrence: Recurrence.halfYearly),
    DefaultReminder(kind: ReminderKind.service, label: 'Service Due', startMonths: 6, recurrence: Recurrence.halfYearly),
  ]),
  AssetCategory(id: 'cat_bike', slug: 'vehicle-bike', name: 'Bike / Scooter', iconToken: 'bike', defaults: [
    DefaultReminder(kind: ReminderKind.insurance, label: 'Insurance', startMonths: 12, recurrence: Recurrence.yearly),
    DefaultReminder(kind: ReminderKind.pollution, label: 'Pollution (PUC)', startMonths: 6, recurrence: Recurrence.halfYearly),
    DefaultReminder(kind: ReminderKind.service, label: 'Service Due', startMonths: 6, recurrence: Recurrence.halfYearly),
  ]),
  AssetCategory(id: 'cat_ac', slug: 'appliance-ac', name: 'Air Conditioner', iconToken: 'ac', defaults: [
    DefaultReminder(kind: ReminderKind.amc, label: 'AMC', startMonths: 12, recurrence: Recurrence.yearly),
    DefaultReminder(kind: ReminderKind.service, label: 'Wet Service', startMonths: 6, recurrence: Recurrence.halfYearly),
    DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 12),
  ]),
  AssetCategory(id: 'cat_fridge', slug: 'appliance-fridge', name: 'Refrigerator', iconToken: 'fridge', defaults: [
    DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 12),
  ]),
  AssetCategory(id: 'cat_washer', slug: 'appliance-washing-machine', name: 'Washing Machine', iconToken: 'washer', defaults: [
    DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 24),
    DefaultReminder(kind: ReminderKind.service, label: 'Service Due', startMonths: 12, recurrence: Recurrence.yearly),
  ]),
  AssetCategory(id: 'cat_purifier', slug: 'appliance-water-purifier', name: 'Water Purifier', iconToken: 'water', defaults: [
    DefaultReminder(kind: ReminderKind.amc, label: 'AMC', startMonths: 12, recurrence: Recurrence.yearly),
    DefaultReminder(kind: ReminderKind.service, label: 'Filter Change', startMonths: 6, recurrence: Recurrence.halfYearly),
  ]),
  AssetCategory(id: 'cat_tv', slug: 'appliance-tv', name: 'Television', iconToken: 'tv', defaults: [
    DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 12),
  ]),
  AssetCategory(id: 'cat_microwave', slug: 'appliance-microwave', name: 'Microwave', iconToken: 'microwave', defaults: [
    DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 12),
  ]),
  AssetCategory(id: 'cat_air_purifier', slug: 'appliance-air-purifier', name: 'Air Purifier', iconToken: 'air', defaults: [
    DefaultReminder(kind: ReminderKind.service, label: 'Filter Change', startMonths: 6, recurrence: Recurrence.halfYearly),
  ]),
  AssetCategory(id: 'cat_geyser', slug: 'appliance-geyser', name: 'Water Heater / Geyser', iconToken: 'heater', defaults: [
    DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 24),
    DefaultReminder(kind: ReminderKind.service, label: 'Descaling Service', startMonths: 12, recurrence: Recurrence.yearly),
  ]),
  AssetCategory(id: 'cat_chimney', slug: 'appliance-chimney', name: 'Kitchen Chimney', iconToken: 'chimney', defaults: [
    DefaultReminder(kind: ReminderKind.service, label: 'Deep Clean Service', startMonths: 6, recurrence: Recurrence.halfYearly),
  ]),
  AssetCategory(id: 'cat_phone', slug: 'electronics-phone', name: 'Smartphone', iconToken: 'phone', defaults: [
    DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 12),
  ]),
  AssetCategory(id: 'cat_laptop', slug: 'electronics-laptop', name: 'Laptop', iconToken: 'laptop', defaults: [
    DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 12),
  ]),
];

/// True when the id is a database UUID (a real `asset_categories` FK) rather
/// than one of the built-in `cat_*` fallback ids above.
bool isDbCategoryId(String? id) =>
    id != null && RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F-]{27}$').hasMatch(id);
