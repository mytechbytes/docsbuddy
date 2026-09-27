import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

typedef Json = Map<String, dynamic>;

/// Object storage for user files (photos, documents, avatars). Paths are
/// family-scoped by the callers so one storage RLS policy isolates families.
abstract interface class FileStorage {
  Future<void> upload(String path, Uint8List bytes, {required String mimeType});
  Future<void> remove(String path);
  Future<String> signedUrl(String path, {required Duration expiresIn});
  Future<Uint8List> download(String path);
}

class SupabaseFileStorage implements FileStorage {
  SupabaseFileStorage(this._client, {this.bucket = 'docsbuddy-files'});

  final SupabaseClient _client;
  final String bucket;

  StorageFileApi get _files => _client.storage.from(bucket);

  @override
  Future<void> upload(String path, Uint8List bytes, {required String mimeType}) =>
      _files.uploadBinary(path, bytes, fileOptions: FileOptions(contentType: mimeType, upsert: false));

  @override
  Future<void> remove(String path) => _files.remove([path]);

  @override
  Future<String> signedUrl(String path, {required Duration expiresIn}) =>
      _files.createSignedUrl(path, expiresIn.inSeconds);

  @override
  Future<Uint8List> download(String path) => _files.download(path);
}

/// Storage-safe file name: anything outside `[A-Za-z0-9._-]` becomes `_`.
String safeFileName(String fileName) => fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');

/// Whether an image reference is a bucket path (vs. an absolute URL).
bool isBucketPath(String? ref) => ref != null && ref.isNotEmpty && !ref.startsWith('http');
