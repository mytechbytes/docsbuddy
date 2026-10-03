import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_models.freezed.dart';

/// Document categories — mirrors the `doc_kind` enum in 0001. Icons live in
/// the presentation layer.
enum DocKind {
  invoice('Invoice'),
  warranty('Warranty'),
  insurance('Insurance'),
  manual('Manual'),
  photo('Photo'),
  other('Other');

  const DocKind(this.label);
  final String label;

  static DocKind fromName(String? n) => DocKind.values.asNameMap()[n] ?? DocKind.other;
}

@freezed
abstract class DocumentMeta with _$DocumentMeta {
  const DocumentMeta._();

  const factory DocumentMeta({
    required String id,
    required String assetId,

    /// When set, the document belongs to a specific service on the asset
    /// (`documents.asset_date_id`) — e.g. the insurance policy PDF on the
    /// Insurance service — rather than the asset as a whole.
    String? assetDateId,
    required String title,
    required DocKind kind,
    required String mimeType,
    required int sizeBytes,
    required String storagePath,
    required DateTime createdAt,
  }) = _DocumentMeta;

  bool get isImage => mimeType.startsWith('image/') || isImageFileName(title);
}

const _imageExtensions = {'jpg', 'jpeg', 'png', 'webp', 'heic', 'gif', 'bmp'};

/// Lower-cased extension without the dot, or '' when there is none.
String fileExtension(String name) {
  final dot = name.lastIndexOf('.');
  return dot < 0 ? '' : name.substring(dot + 1).toLowerCase();
}

bool isImageFileName(String name) => _imageExtensions.contains(fileExtension(name));

DocKind kindForFileName(String name) => isImageFileName(name) ? DocKind.photo : DocKind.other;

/// Human-readable size, e.g. "512 B", "42 KB", "1.3 MB".
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
