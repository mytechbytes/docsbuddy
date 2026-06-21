import 'package:supabase_flutter/supabase_flutter.dart';

import 'catalog_models.dart';
import 'catalog_repository.dart';

/// Real backend catalog, mapped onto the 0001 schema:
///   - `assets` (category + location stored in the `metadata` JSONB so no schema
///     change is needed),
///   - `asset_dates` for reminders (kind inferred from `label`),
///   - the `complete_asset_date` RPC for completion/recurrence.
///
/// Everything is family-scoped; the caller's family is resolved (and a default
/// "My Home" created) on first use. RLS scopes all reads/writes.
class SupabaseCatalogRepository implements CatalogRepository {
  SupabaseCatalogRepository(this._client);

  final SupabaseClient _client;
  String? _familyId;

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

  Asset _asset(Map<String, dynamic> r) {
    final meta = (r['metadata'] as Map?)?.cast<String, dynamic>() ?? const {};
    return Asset(
      id: r['id'] as String,
      name: r['name'] as String,
      category: _catFromName(meta['category'] as String?),
      locationName: meta['location'] as String?,
      brand: r['brand'] as String?,
      model: r['model'] as String?,
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
    );
  }

  @override
  Future<List<Asset>> assets() => _guard(() async {
        final rows = await _client.from('assets').select('id, name, brand, model, metadata').order('created_at');
        return rows.map(_asset).toList();
      });

  @override
  Future<Asset> asset(String id) => _guard(() async {
        final r = await _client.from('assets').select('id, name, brand, model, metadata').eq('id', id).single();
        return _asset(r);
      });

  @override
  Future<List<Location>> locations() => _guard(() async {
        final rows = await _client.from('assets').select('metadata');
        final counts = <String, int>{};
        for (final r in rows) {
          final loc = ((r['metadata'] as Map?)?['location'] as String?) ?? 'Unassigned';
          counts[loc] = (counts[loc] ?? 0) + 1;
        }
        return counts.entries.map((e) => Location(id: e.key, name: e.key, assetCount: e.value)).toList();
      });

  @override
  Future<List<Reminder>> upcomingReminders({int withinDays = 365}) => _guard(() async {
        final rows = await _client
            .from('asset_dates')
            .select('id, asset_id, label, due_date, recurrence, assets(name)')
            .isFilter('completed_at', null)
            .order('due_date');
        return rows.map((r) => _reminder(r)).where((r) => r.daysLeft <= withinDays).toList();
      });

  @override
  Future<List<Reminder>> remindersFor(String assetId) => _guard(() async {
        final rows = await _client
            .from('asset_dates')
            .select('id, asset_id, label, due_date, recurrence')
            .eq('asset_id', assetId)
            .isFilter('completed_at', null)
            .order('due_date');
        return rows.map((r) => _reminder(r, assetName: '')).toList();
      });

  @override
  Future<Asset> addAsset({
    required String name,
    required AssetCategoryKind category,
    String? locationName,
    String? brand,
    String? model,
  }) =>
      _guard(() async {
        final familyId = await _family();
        final row = await _client
            .from('assets')
            .insert({
              'family_id': familyId,
              'name': name.trim(),
              'brand': brand,
              'model': model,
              'created_by': _client.auth.currentUser?.id,
              'metadata': {'category': category.name, 'location': ?locationName},
            })
            .select('id, name, brand, model, metadata')
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
  }) =>
      _guard(() async {
        final row = await _client
            .from('asset_dates')
            .insert({
              'asset_id': assetId,
              'label': label.trim().isEmpty ? kind.label : label.trim(),
              'due_date': dueDate.toIso8601String().substring(0, 10),
              'recurrence': _recToDb(recurrence),
            })
            .select('id, asset_id, label, due_date, recurrence')
            .single();
        return _reminder(row, assetName: '');
      });

  @override
  Future<void> completeReminder(String reminderId) =>
      _guard(() => _client.rpc('complete_asset_date', params: {'p_id': reminderId}));
}
