import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'document_models.dart';
import 'document_repository.dart';

/// Real documents: bytes go straight to the `docsbuddy-files` Storage bucket,
/// metadata into the `documents` table. The storage path is family-scoped
/// (`{family_id}/assets/{asset_id}/documents/...`) so one Storage RLS policy
/// enforces isolation (see supabase/migrations/0004_storage.sql).
class SupabaseDocumentRepository implements DocumentRepository {
  SupabaseDocumentRepository(this._client);

  final SupabaseClient _client;
  static const _bucket = 'docsbuddy-files';

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on StorageException catch (e) {
      throw Exception(e.message);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }

  DocumentMeta _doc(Map<String, dynamic> r) => DocumentMeta(
        id: r['id'] as String,
        assetId: r['asset_id'] as String,
        title: (r['title'] as String?) ?? 'Document',
        kind: DocKind.fromName(r['kind'] as String?),
        mimeType: (r['mime_type'] as String?) ?? 'application/octet-stream',
        sizeBytes: (r['size_bytes'] as int?) ?? 0,
        storagePath: r['storage_path'] as String,
        createdAt: DateTime.parse(r['created_at'] as String),
      );

  @override
  Future<List<DocumentMeta>> forAsset(String assetId) => _guard(() async {
        final rows = await _client
            .from('documents')
            .select('id, asset_id, title, kind, mime_type, size_bytes, storage_path, created_at')
            .eq('asset_id', assetId)
            .isFilter('deleted_at', null)
            .order('created_at', ascending: false);
        return rows.map(_doc).toList();
      });

  @override
  Future<DocumentMeta> upload({
    required String assetId,
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    required DocKind kind,
  }) =>
      _guard(() async {
        final familyId = await _client.from('assets').select('family_id').eq('id', assetId).single();
        final fam = familyId['family_id'] as String;
        final safe = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
        final path = '$fam/assets/$assetId/documents/${DateTime.now().millisecondsSinceEpoch}_$safe';

        await _client.storage.from(_bucket).uploadBinary(
              path,
              bytes,
              fileOptions: FileOptions(contentType: mimeType, upsert: false),
            );

        final row = await _client
            .from('documents')
            .insert({
              'family_id': fam,
              'asset_id': assetId,
              'kind': kind.name,
              'title': fileName,
              'storage_path': path,
              'mime_type': mimeType,
              'size_bytes': bytes.length,
              'uploaded_by': _client.auth.currentUser?.id,
            })
            .select('id, asset_id, title, kind, mime_type, size_bytes, storage_path, created_at')
            .single();
        return _doc(row);
      });

  @override
  Future<String?> viewUrl(DocumentMeta doc) =>
      _guard(() => _client.storage.from(_bucket).createSignedUrl(doc.storagePath, 900));

  @override
  Future<void> delete(DocumentMeta doc) => _guard(() async {
        await _client.storage.from(_bucket).remove([doc.storagePath]);
        await _client.from('documents').delete().eq('id', doc.id);
      });
}
