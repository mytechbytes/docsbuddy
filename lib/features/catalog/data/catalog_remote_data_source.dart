import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/file_storage.dart';

/// Raw table/RPC access for the catalog — one method per query, JSON in and
/// out, no mapping or business rules. The repository is the only caller.
abstract interface class CatalogRemoteDataSource {
  String? get currentUserId;

  Future<String?> firstFamilyId();
  Future<Json> createFamily(String name);

  Future<List<Json>> assets();
  Future<Json> asset(String id);
  Future<Json> assetRow(String id, String columns);
  Future<Json> insertAsset(Json values);
  Future<Json> updateAsset(String id, Json values);
  Future<void> deleteAsset(String id);

  Future<List<Json>> categories();
  Future<String?> categoryIdForSlug(String slug);

  Future<List<Json>> locations();
  Future<Json> locationRow(String id, String columns);
  Future<String?> locationIdByName(String familyId, String name);
  Future<String> insertLocation(Json values);
  Future<void> updateLocation(String id, Json values);

  /// Open (not completed, not deleted) services, soonest first — all of them
  /// with the parent asset joined, or just [assetId]'s.
  Future<List<Json>> openAssetDates({String? assetId});
  Future<Json> insertAssetDate(Json values);
  Future<Json> updateAssetDate(String id, Json values);
  Future<void> completeAssetDate(String id);
}

class SupabaseCatalogRemoteDataSource implements CatalogRemoteDataSource {
  SupabaseCatalogRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const assetColumns =
      'id, name, brand, model, serial_no, purchase_date, purchase_price, store, image_url, location_id, category_id, metadata, locations(name), asset_categories(slug, name)';
  static const dateColumns =
      'id, asset_id, label, kind, due_date, recurrence, notify_offsets, provider, policy_no, cost, notes';

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  Future<String?> firstFamilyId() async {
    final rows = await _client.from('families').select('id').limit(1);
    return rows.isEmpty ? null : rows.first['id'] as String;
  }

  @override
  Future<Json> createFamily(String name) async =>
      await _client.rpc('create_family', params: {'p_name': name}) as Json;

  @override
  Future<List<Json>> assets() => _client.from('assets').select(assetColumns).order('created_at');

  @override
  Future<Json> asset(String id) => _client.from('assets').select(assetColumns).eq('id', id).single();

  @override
  Future<Json> assetRow(String id, String columns) =>
      _client.from('assets').select(columns).eq('id', id).single();

  @override
  Future<Json> insertAsset(Json values) =>
      _client.from('assets').insert(values).select(assetColumns).single();

  @override
  Future<Json> updateAsset(String id, Json values) =>
      _client.from('assets').update(values).eq('id', id).select(assetColumns).single();

  @override
  Future<void> deleteAsset(String id) => _client.from('assets').delete().eq('id', id);

  @override
  Future<List<Json>> categories() =>
      _client.from('asset_categories').select('id, slug, name, icon, default_dates').order('name');

  @override
  Future<String?> categoryIdForSlug(String slug) async {
    final rows = await _client.from('asset_categories').select('id').eq('slug', slug).limit(1);
    return rows.isEmpty ? null : rows.first['id'] as String;
  }

  @override
  Future<List<Json>> locations() => _client
      .from('locations')
      .select('id, name, kind, image_url, parent_id, assets(count)')
      .order('sort_order')
      .order('name');

  @override
  Future<Json> locationRow(String id, String columns) =>
      _client.from('locations').select(columns).eq('id', id).single();

  @override
  Future<String?> locationIdByName(String familyId, String name) async {
    final rows =
        await _client.from('locations').select('id').eq('family_id', familyId).ilike('name', name).limit(1);
    return rows.isEmpty ? null : rows.first['id'] as String;
  }

  @override
  Future<String> insertLocation(Json values) async =>
      (await _client.from('locations').insert(values).select('id').single())['id'] as String;

  @override
  Future<void> updateLocation(String id, Json values) => _client.from('locations').update(values).eq('id', id);

  @override
  Future<List<Json>> openAssetDates({String? assetId}) {
    final query = _client
        .from('asset_dates')
        .select(assetId == null ? '$dateColumns, assets(name, image_url)' : dateColumns);
    final scoped = assetId == null ? query : query.eq('asset_id', assetId);
    return scoped.isFilter('completed_at', null).isFilter('deleted_at', null).order('due_date');
  }

  @override
  Future<Json> insertAssetDate(Json values) =>
      _client.from('asset_dates').insert(values).select(dateColumns).single();

  @override
  Future<Json> updateAssetDate(String id, Json values) =>
      _client.from('asset_dates').update(values).eq('id', id).select(dateColumns).single();

  @override
  Future<void> completeAssetDate(String id) => _client.rpc('complete_asset_date', params: {'p_id': id});
}
