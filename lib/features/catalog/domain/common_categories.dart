import '../data/catalog_models.dart';

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

/// One extra field the Add-asset form shows for a specific appliance type.
/// Values are stored per asset in `assets.metadata.properties`.
class PropertySpec {
  const PropertySpec(this.label, this.hint);
  final String label;
  final String hint;
}

/// Type-specific properties by category slug.
List<PropertySpec> propertySpecsFor(String? slug) => switch (slug) {
      'vehicle-car' => const [
          PropertySpec('Fuel type', 'e.g. Petrol / Diesel / EV'),
          PropertySpec('Variant', 'e.g. VX CVT'),
          PropertySpec('Odometer (km)', 'e.g. 24500'),
        ],
      'vehicle-bike' => const [
          PropertySpec('Fuel type', 'e.g. Petrol / EV'),
          PropertySpec('Odometer (km)', 'e.g. 12800'),
        ],
      'appliance-ac' => const [
          PropertySpec('Tonnage', 'e.g. 1.5 ton'),
          PropertySpec('Energy rating', 'e.g. 5 star'),
          PropertySpec('Type', 'e.g. Split / Window'),
        ],
      'appliance-fridge' => const [
          PropertySpec('Capacity (L)', 'e.g. 340'),
          PropertySpec('Energy rating', 'e.g. 3 star'),
        ],
      'appliance-washing-machine' => const [
          PropertySpec('Capacity (kg)', 'e.g. 7'),
          PropertySpec('Type', 'e.g. Front load / Top load'),
        ],
      'appliance-water-purifier' => const [
          PropertySpec('Filter type', 'e.g. RO + UV'),
        ],
      'appliance-tv' => const [
          PropertySpec('Screen size', 'e.g. 55"'),
          PropertySpec('Resolution', 'e.g. 4K'),
        ],
      'appliance-microwave' => const [
          PropertySpec('Capacity (L)', 'e.g. 28'),
          PropertySpec('Type', 'e.g. Convection'),
        ],
      'appliance-geyser' => const [
          PropertySpec('Capacity (L)', 'e.g. 15'),
        ],
      'appliance-chimney' => const [
          PropertySpec('Suction (m³/hr)', 'e.g. 1200'),
        ],
      'electronics-phone' => const [
          PropertySpec('IMEI', 'from the box / *#06#'),
          PropertySpec('Storage', 'e.g. 256 GB'),
        ],
      'electronics-laptop' => const [
          PropertySpec('Configuration', 'e.g. i7 / 16 GB / 512 GB'),
        ],
      _ => const [],
    };
