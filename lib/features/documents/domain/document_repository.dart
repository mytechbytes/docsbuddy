import 'dart:typed_data';

import 'document_models.dart';

/// Documents attached to assets — or to a specific service on an asset when
/// [DocumentMeta.assetDateId] is set. Every method throws an `AppFailure` on
/// error.
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

  /// A short-lived URL to view the file; throws `UnavailableFailure` when
  /// there is no file storage (the offline build).
  Future<String> viewUrl(DocumentMeta doc);

  /// The raw file bytes (for sharing); `UnavailableFailure` offline.
  Future<Uint8List> download(DocumentMeta doc);

  Future<void> delete(DocumentMeta doc);
}
