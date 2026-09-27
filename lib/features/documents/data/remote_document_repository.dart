import 'dart:typed_data';

import '../../../core/data/file_storage.dart';
import '../../../core/data/supabase/supabase_guard.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/document_models.dart';
import '../domain/document_repository.dart';
import 'document_mapper.dart';
import 'document_remote_data_source.dart';

/// Bytes go to the storage bucket, metadata into `documents`. The storage path
/// is family-scoped (`{family_id}/assets/{asset_id}/documents/...`) so one
/// storage RLS policy enforces isolation (see 0004_storage.sql).
class RemoteDocumentRepository implements DocumentRepository {
  RemoteDocumentRepository(this._remote, this._files, {Clock clock = DateTime.now}) : _now = clock;

  final DocumentRemoteDataSource _remote;
  final FileStorage _files;
  final Clock _now;

  @override
  Future<List<DocumentMeta>> forAsset(String assetId) =>
      guardBackend(() async => (await _remote.forAsset(assetId)).map(DocumentMapper.fromRow).toList());

  @override
  Future<int> countAll() => guardBackend(_remote.countAll);

  @override
  Future<DocumentMeta> upload({
    required String assetId,
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    required DocKind kind,
    String? assetDateId,
  }) =>
      guardBackend(() async {
        final fam = await _remote.familyIdOfAsset(assetId);
        final path = '$fam/assets/$assetId/documents/${_now().millisecondsSinceEpoch}_${safeFileName(fileName)}';
        await _files.upload(path, bytes, mimeType: mimeType);
        final row = await _remote.insert({
          'family_id': fam,
          'asset_id': assetId,
          'asset_date_id': assetDateId,
          'kind': kind.name,
          'title': fileName,
          'storage_path': path,
          'mime_type': mimeType,
          'size_bytes': bytes.length,
          'uploaded_by': _remote.currentUserId,
        });
        return DocumentMapper.fromRow(row);
      });

  @override
  Future<String> viewUrl(DocumentMeta doc) =>
      guardBackend(() => _files.signedUrl(doc.storagePath, expiresIn: const Duration(minutes: 15)));

  @override
  Future<Uint8List> download(DocumentMeta doc) => guardBackend(() => _files.download(doc.storagePath));

  @override
  Future<void> delete(DocumentMeta doc) => guardBackend(() async {
        await _files.remove(doc.storagePath);
        await _remote.delete(doc.id);
      });
}
