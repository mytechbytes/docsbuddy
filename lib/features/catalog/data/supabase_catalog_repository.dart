import 'package:supabase_flutter/supabase_flutter.dart';

import 'catalog_models.dart';
import 'catalog_repository.dart';

/// Real backend catalog, mapped onto the 0001 schema:
///   - `assets` with real columns (`serial_no`, `purchase_*`, `store`,
///     `image_url`, `location_id`; only `category` still rides in `metadata`
///     until the category catalog lands),
///   - `locations` as a real table (find-or-created by name on asset save),
///   - `asset_dates` as the **service** rows (kind inferred from `label`;
///     per-service `notify_offsets`, provider/policy/cost/notes from 0006),
///   - the `complete_asset_date` RPC for completion/recurrence.
///
/// Everything is family-scoped; the caller's family is resolved (and a default
/// "My Home" created) on first use. RLS scopes all reads/writes.
class SupabaseCatalogRepository implements CatalogRepository {
  SupabaseCatalogRepository(this._client);

  final SupabaseClient _client;
  String? _familyId;

  static const _assetCols =
      'id, name, brand, model, serial_no, purchase_date, purchase_price, store, image_url, location_id, metadata, locations(name)';
  static const _dateCols =
      'id, asset_id, label, due_date, recurrence, notify_offsets, provider, policy_no, cost, notes';

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<String> _family() async {
    if (_familyId != null) return _familyId!;
    final rows = await _client.from('families').select('id').limit(1);
    if (rows.isNotEmpty) return _familyId = rows.first['id'] as String;
    final created = await _client.rpc('create_family', params: {'p_name': 'My Home'}) as Map<String, dynamic>;
    return _familyId = created['id'] as String;
  }

  // ── enum mapping ──
  static String _recToDb(Recurrence r) => r == Recurrence.halfYearly ? 'half_yearly' : r.name;
  static Recurrence _recFromDb(String? s) => switch (s) {
        'monthly' => Recurrence.monthly,
        'quarterly' => Recurrence.quarterly,
        'half_yearly' => Recurrence.halfYearly,
        'yearly' => Recurrence.yearly,
        _ => Recurrence.none,
      };

  static AssetCategoryKind _catFromName(String? n) =>
      AssetCategoryKind.values.firstWhere((c) => c.name == n, orElse: () => AssetCategoryKind.other);

  static ReminderKind _kindFromLabel(String label) => ReminderKind.values.firstWhere(
        (k) => k.label.toLowerCase() == label.toLowerCase(),
        orElse: () => ReminderKind.other,
      );

  static DateTime? _date(String? s) => s == null ? null : DateTime.parse(s);
  static String _dbDate(DateTime d) => d.toIso8601String().substring(0, 10);

  Asset _asset(Map<String, dynamic> r) {
    final meta = (r['metadata'] as Map?)?.cast<String, dynamic>() ?? const {};
    return Asset(
      id: r['id'] as String,
      name: r['name'] as String,
      category: _catFromName(meta['category'] as String?),
      // Joined location name; old pre-0006 rows may still carry the metadata key.
      locationName: (r['locations'] as Map?)?['name'] as String? ?? meta['location'] as String?,
      locationId: r['location_id'] as String?,
      brand: r['brand'] as String?,
      model: r['model'] as String?,
      serialNo: r['serial_no'] as String?,
      purchaseDate: _date(r['purchase_date'] as String?),
      purchasePrice: (r['purchase_price'] as num?)?.toDouble(),
      store: r['store'] as String?,
      imageUrl: r['image_url'] as String?,
    );
  }

  Reminder _reminder(Map<String, dynamic> r, {String? assetName}) {
    final label = r['label'] as String;
    return Reminder(
      id: r['id'] as String,
      assetId: r['asset_id'] as String,
      assetName: assetName ?? (r['assets'] as Map?)?['name'] as String? ?? '',
      kind: _kindFromLabel(label),
      label: label,
      dueDate: DateTime.parse(r['due_date'] as String),
      recurrence: _recFromDb(r['recurrence'] as String?),
      notifyOffsets: (r['notify_offsets'] as List?)?.cast<int>() ?? const [30, 7, 1],
      provider: r['provider'] as String?,
      policyNo: r['policy_no'] as String?,
      cost: (r['cost'] as num?)?.toDouble(),
      notes: r['notes'] as String?,
    );
  }

  @override
  Future<List<Asset>> assets() => _guard(() async {
        final rows = await _client.from('assets').select(_assetCols).order('created_at');
        return rows.map(_asset).toList();
      });

  @override
  Future<Asset> asset(String id) => _guard(() async {
        final r = await _client.from('assets').select(_assetCols).eq('id', id).single();
        return _asset(r);
      });

  @override
  Future<List<Location>> locations() => _guard(() async {
        final rows = await _client
            .from('locations')
            .select('id, name, kind, image_url, parent_id, assets(count)')
            .order('sort_order')
            .order('name');
        return rows.map((r) {
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
        }).toList();
      });

  @override
  Future<List<Reminder>> upcomingReminders({int withinDays = 365}) => _guard(() async {
        final rows = await _client
            .from('asset_dates')
            .select('$_dateCols, assets(name)')
            .isFilter('completed_at', null)
            .order('due_date');
        return rows.map((r) => _reminder(r)).where((r) => r.daysLeft <= withinDays).toList();
      });

  @override
  Future<List<Reminder>> remindersFor(String assetId) => _guard(() async {
        final rows = await _client
            .from('asset_dates')
            .select(_dateCols)
            .eq('asset_id', assetId)
            .isFilter('completed_at', null)
            .order('due_date');
        return rows.map((r) => _reminder(r, assetName: '')).toList();
      });

  /// Find-or-create a `locations` row by (family, case-insensitive name).
  Future<String> _locationIdFor(String familyId, String name) async {
    final existing = await _client
        .from('locations')
        .select('id')
        .eq('family_id', familyId)
        .ilike('name', name)
        .limit(1);
    if (existing.isNotEmpty) return existing.first['id'] as String;
    final row = await _client
        .from('locations')
        .insert({
          'family_id': familyId,
          'name': name,
          'kind': 'room',
          'created_by': _client.auth.currentUser?.id,
        })
        .select('id')
        .single();
    return row['id'] as String;
  }

  @override
  Future<Asset> addAsset({
    required String name,
    required AssetCategoryKind category,
    String? locationName,
    String? brand,
    String? model,
    String? serialNo,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? store,
  }) =>
      _guard(() async {
        final familyId = await _family();
        final loc = locationName?.trim();
        final locationId = loc == null || loc.isEmpty ? null : await _locationIdFor(familyId, loc);
        final row = await _client
            .from('assets')
            .insert({
              'family_id': familyId,
              'name': name.trim(),
              'brand': brand,
              'model': model,
              'serial_no': serialNo,
              'purchase_date': purchaseDate == null ? null : _dbDate(purchaseDate),
              'purchase_price': purchasePrice,
              'store': store,
              'location_id': locationId,
              'created_by': _client.auth.currentUser?.id,
              'metadata': {'category': category.name},
            })
            .select(_assetCols)
            .single();
        return _asset(row);
      });

  @override
  Future<Reminder> addReminder({
    required String assetId,
    required ReminderKind kind,
    required String label,
    required DateTime dueDate,
    Recurrence recurrence = Recurrence.none,
    List<int>? notifyOffsets,
    String? provider,
    String? policyNo,
    double? cost,
    String? notes,
  }) =>
      _guard(() async {
        final row = await _client
            .from('asset_dates')
            .insert({
              'asset_id': assetId,
              'label': label.trim().isEmpty ? kind.label : label.trim(),
              'due_date': _dbDate(dueDate),
              'recurrence': _recToDb(recurrence),
              'notify_offsets': ?notifyOffsets,
              'provider': provider,
              'policy_no': policyNo,
              'cost': cost,
              'notes': notes,
            })
            .select(_dateCols)
            .single();
        return _reminder(row, assetName: '');
      });

  @override
  Future<void> completeReminder(String reminderId) =>
      _guard(() => _client.rpc('complete_asset_date', params: {'p_id': reminderId}));

  @override
  Future<Location> createLocation(String name) => _guard(() async {
        final familyId = await _family();
        final id = await _locationIdFor(familyId, name.trim());
        return Location(id: id, name: name.trim());
      });

  @override
  Future<void> updateLocation(String id, {String? name}) => _guard(() async {
        if (name == null || name.trim().isEmpty) return;
        await _client.from('locations').update({'name': name.trim()}).eq('id', id);
      });
}
