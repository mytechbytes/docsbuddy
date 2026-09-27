/// Service/reminder kinds (`asset_dates.kind`). Visual styling (bubble
/// colours, icons) lives in the presentation layer — see `catalog_style.dart`.
enum ReminderKind {
  insurance('Insurance'),
  pollution('Pollution'),
  amc('AMC'),
  service('Service'),
  tax('Tax'),
  warranty('Warranty'),
  registration('Registration'),
  fitness('Fitness'),
  other('Other');

  const ReminderKind(this.label);
  final String label;
}

/// Top-level asset groups.
enum AssetCategoryKind {
  vehicle('Vehicle'),
  appliance('Appliance'),
  electronics('Electronics'),
  document('Document'),
  other('Other');

  const AssetCategoryKind(this.label);
  final String label;
}

enum Recurrence {
  none('None', 0),
  monthly('Monthly', 1),
  quarterly('Quarterly', 3),
  halfYearly('Half-yearly', 6),
  yearly('Yearly', 12);

  const Recurrence(this.label, this.stepMonths);
  final String label;

  /// Months between occurrences (0 = one-off).
  final int stepMonths;
}
