import 'package:flutter/material.dart';

/// Document categories — mirrors the `doc_kind` enum in 0001.
enum DocKind {
  invoice(Icons.receipt_long_outlined, 'Invoice'),
  warranty(Icons.verified_outlined, 'Warranty'),
  insurance(Icons.shield_outlined, 'Insurance'),
  manual(Icons.menu_book_outlined, 'Manual'),
  photo(Icons.image_outlined, 'Photo'),
  other(Icons.description_outlined, 'Other');

  const DocKind(this.icon, this.label);
  final IconData icon;
  final String label;

  static DocKind fromName(String? n) =>
      DocKind.values.firstWhere((k) => k.name == n, orElse: () => DocKind.other);
}

class DocumentMeta {
  const DocumentMeta({
    required this.id,
    required this.assetId,
    required this.title,
    required this.kind,
    required this.mimeType,
    required this.sizeBytes,
    required this.storagePath,
    required this.createdAt,
    this.assetDateId,
  });

  final String id;
  final String assetId;

  /// When set, the document belongs to a specific service on the asset
  /// (`documents.asset_date_id`) — e.g. the insurance policy PDF on the
  /// Insurance service — rather than the asset as a whole.
  final String? assetDateId;
  final String title;
  final DocKind kind;
  final String mimeType;
  final int sizeBytes;
  final String storagePath;
  final DateTime createdAt;

  String get prettySize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
