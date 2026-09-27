import '../../../core/data/file_storage.dart';
import '../domain/document_models.dart';

/// Pure row → model conversion.
abstract final class DocumentMapper {
  static DocumentMeta fromRow(Json r) => DocumentMeta(
        id: r['id'] as String,
        assetId: r['asset_id'] as String,
        assetDateId: r['asset_date_id'] as String?,
        title: (r['title'] as String?) ?? 'Document',
        kind: DocKind.fromName(r['kind'] as String?),
        mimeType: (r['mime_type'] as String?) ?? 'application/octet-stream',
        sizeBytes: (r['size_bytes'] as int?) ?? 0,
        storagePath: r['storage_path'] as String,
        createdAt: DateTime.parse(r['created_at'] as String),
      );
}
