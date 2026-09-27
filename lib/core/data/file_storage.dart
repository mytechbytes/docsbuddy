import 'dart:typed_data';

export 'json.dart';

/// Object storage for user files (photos, documents, avatars). Paths are
/// family-scoped by the callers so one storage policy isolates families.
/// Backend-neutral: implementations live with their backend.
abstract interface class FileStorage {
  Future<void> upload(String path, Uint8List bytes, {required String mimeType});
  Future<void> remove(String path);
  Future<String> signedUrl(String path, {required Duration expiresIn});
  Future<Uint8List> download(String path);
}

/// Storage-safe file name: anything outside `[A-Za-z0-9._-]` becomes `_`.
String safeFileName(String fileName) => fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');

/// Whether an image reference is a bucket path (vs. an absolute URL).
bool isBucketPath(String? ref) => ref != null && ref.isNotEmpty && !ref.startsWith('http');
