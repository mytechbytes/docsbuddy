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
