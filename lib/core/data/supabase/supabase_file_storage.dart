import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../file_storage.dart';

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
