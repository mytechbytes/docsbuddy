import 'dart:typed_data';

/// A picked image/document, source-agnostic (camera, gallery or file browser).
class PickedMedia {
  const PickedMedia({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;

  String? get extension {
    final dot = name.lastIndexOf('.');
    return dot < 0 ? null : name.substring(dot + 1).toLowerCase();
  }

  String get imageMime => switch (extension) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        'gif' => 'image/gif',
        _ => 'image/jpeg',
      };

  String get docMime => switch (extension) {
        'pdf' => 'application/pdf',
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        'gif' => 'image/gif',
        'doc' => 'application/msword',
        'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        _ => 'application/octet-stream',
      };
}
