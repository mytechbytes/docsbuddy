import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/file_storage.dart';

/// Raw `documents` table access — JSON in/out, no mapping.
abstract interface class DocumentRemoteDataSource {
  String? get currentUserId;
  Future<List<Json>> forAsset(String assetId);
  Future<int> countAll();
  Future<String> familyIdOfAsset(String assetId);
  Future<Json> insert(Json values);
  Future<void> delete(String id);
}

class SupabaseDocumentRemoteDataSource implements DocumentRemoteDataSource {
  SupabaseDocumentRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const columns = 'id, asset_id, asset_date_id, title, kind, mime_type, size_bytes, storage_path, created_at';

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  Future<List<Json>> forAsset(String assetId) => _client
      .from('documents')
      .select(columns)
      .eq('asset_id', assetId)
      .isFilter('deleted_at', null)
      .order('created_at', ascending: false);

  @override
  Future<int> countAll() async =>
      (await _client.from('documents').select('id').isFilter('deleted_at', null)).length;

  @override
  Future<String> familyIdOfAsset(String assetId) async =>
      (await _client.from('assets').select('family_id').eq('id', assetId).single())['family_id'] as String;

  @override
  Future<Json> insert(Json values) => _client.from('documents').insert(values).select(columns).single();

  @override
  Future<void> delete(String id) => _client.from('documents').delete().eq('id', id);
}
