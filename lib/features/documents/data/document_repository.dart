import 'dart:typed_data';

import 'document_models.dart';

/// Documents attached to assets — or to a specific service on an asset when
/// [DocumentMeta.assetDateId] is set. Bytes live in object storage; metadata
/// in the `documents` table. Downloads use short-lived signed URLs.
abstract interface class DocumentRepository {
  Future<List<DocumentMeta>> forAsset(String assetId);

  /// Total (non-deleted) documents across the family — the profile stat.
  Future<int> countAll();

  Future<DocumentMeta> upload({
    required String assetId,
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    required DocKind kind,
    String? assetDateId,
  });

  /// A short-lived URL to view/download the file, or null if unavailable
  /// (e.g. the local fake backend has no real storage).
  Future<String?> viewUrl(DocumentMeta doc);

  Future<void> delete(DocumentMeta doc);
}
