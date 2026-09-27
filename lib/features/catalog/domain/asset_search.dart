import 'catalog_models.dart';

/// Pure, case-insensitive matching used by Search and the Assets tab.
bool assetMatches(Asset a, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return [a.name, a.brand, a.model, a.serialNo, a.typeLabel, a.locationName]
      .any((s) => (s ?? '').toLowerCase().contains(q));
}

bool reminderMatches(Reminder r, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return [r.label, r.assetName, r.provider, r.policyNo].any((s) => (s ?? '').toLowerCase().contains(q));
}

bool categoryMatches(AssetCategory c, String query) =>
    c.name.toLowerCase().contains(query.trim().toLowerCase());
