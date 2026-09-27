import '../../../core/data/file_storage.dart';
import '../domain/catalog_models.dart';

/// Pure JSON ⇄ model conversion for the catalog tables. No I/O.
abstract final class CatalogMapper {
  // ── enum codecs ──
  static String recurrenceToDb(Recurrence r) => r == Recurrence.halfYearly ? 'half_yearly' : r.name;

  static Recurrence recurrenceFromDb(String? s) => switch (s) {
        'monthly' => Recurrence.monthly,
        'quarterly' => Recurrence.quarterly,
        'half_yearly' => Recurrence.halfYearly,
        'yearly' => Recurrence.yearly,
        _ => Recurrence.none,
      };

  static AssetCategoryKind categoryKindFromName(String? n) =>
      AssetCategoryKind.values.asNameMap()[n] ?? AssetCategoryKind.other;

  /// Kind comes from the stored `asset_dates.kind` (written since 0005);
  /// label matching remains only as the fallback for old rows.
  static ReminderKind reminderKindFor(String? kind, String label) =>
      ReminderKind.values.asNameMap()[kind] ??
      ReminderKind.values.firstWhere(
        (k) => k.label.toLowerCase() == label.toLowerCase(),
        orElse: () => ReminderKind.other,
      );

  static DateTime? date(String? s) => s == null ? null : DateTime.parse(s);

  /// `YYYY-MM-DD` for Postgres `date` columns.
  static String dbDate(DateTime d) => d.toIso8601String().substring(0, 10);

  // ── rows ──
  static Asset asset(Json r) {
    final meta = (r['metadata'] as Map?)?.cast<String, dynamic>() ?? const {};
    final cat = (r['asset_categories'] as Map?)?.cast<String, dynamic>();
    final slug = cat?['slug'] as String?;
    return Asset(
      id: r['id'] as String,
      name: r['name'] as String,
      // Group from the joined category slug's prefix; metadata is the
      // fallback for rows created before the 0005 backfill.
      category: categoryKindFromName(slug?.split('-').first ?? meta['category'] as String?),
      categoryId: r['category_id'] as String?,
      // Joined specific type, else a custom/fallback type riding in metadata.
      categoryName: slug != null && slug.contains('-') ? (cat?['name'] as String?) : meta['custom_type'] as String?,
      properties: ((meta['properties'] as Map?) ?? const {}).map((k, v) => MapEntry('$k', '$v')),
      // Joined location name; old pre-0006 rows may still carry the metadata key.
      locationName: (r['locations'] as Map?)?['name'] as String? ?? meta['location'] as String?,
      locationId: r['location_id'] as String?,
      brand: r['brand'] as String?,
      model: r['model'] as String?,
      serialNo: r['serial_no'] as String?,
      purchaseDate: date(r['purchase_date'] as String?),
      purchasePrice: (r['purchase_price'] as num?)?.toDouble(),
      store: r['store'] as String?,
      imageUrl: r['image_url'] as String?,
    );
  }

  static Reminder reminder(Json r, {String? assetName}) {
    final label = r['label'] as String;
    final parent = r['assets'] as Map?;
    return Reminder(
      id: r['id'] as String,
      assetId: r['asset_id'] as String,
      assetName: assetName ?? parent?['name'] as String? ?? '',
      kind: reminderKindFor(r['kind'] as String?, label),
      label: label,
      dueDate: DateTime.parse(r['due_date'] as String),
      recurrence: recurrenceFromDb(r['recurrence'] as String?),
      notifyOffsets: (r['notify_offsets'] as List?)?.cast<int>() ?? const [30, 7, 1],
      provider: r['provider'] as String?,
      policyNo: r['policy_no'] as String?,
      cost: (r['cost'] as num?)?.toDouble(),
      notes: r['notes'] as String?,
      assetImageUrl: parent?['image_url'] as String?,
    );
  }

  static Location location(Json r) {
    final counts = r['assets'] as List?;
    final count = counts == null || counts.isEmpty ? 0 : (counts.first as Map)['count'] as int? ?? 0;
    return Location(
      id: r['id'] as String,
      name: r['name'] as String,
      assetCount: count,
      kind: r['kind'] as String?,
      imageUrl: r['image_url'] as String?,
      parentId: r['parent_id'] as String?,
    );
  }

  static AssetCategory category(Json r) => AssetCategory(
        id: r['id'] as String,
        slug: (r['slug'] as String?) ?? 'other',
        name: (r['name'] as String?) ?? 'Other',
        iconToken: r['icon'] as String?,
        defaults: ((r['default_dates'] as List?) ?? const [])
            .whereType<Map>()
            .map((j) => defaultReminder(j.cast<String, dynamic>()))
            .toList(),
      );

  static DefaultReminder defaultReminder(Json j) => DefaultReminder(
        kind: ReminderKind.values.asNameMap()[j['kind']] ?? ReminderKind.other,
        label: (j['label'] as String?) ?? 'Reminder',
        startMonths: (j['start_months'] as num?)?.toInt() ?? 12,
        recurrence: recurrenceFromDb(j['recurrence'] as String?),
      );
}
