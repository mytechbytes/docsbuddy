import 'dart:typed_data';

import 'document_models.dart';
import 'document_repository.dart';

/// In-memory documents (metadata only — no real files, so [viewUrl] is null).
class FakeDocumentRepository implements DocumentRepository {
  final _byAsset = <String, List<DocumentMeta>>{};
  int _seq = 0;

  Future<void> _delay() => Future<void>.delayed(const Duration(milliseconds: 400));

  @override
  Future<List<DocumentMeta>> forAsset(String assetId) async {
    await _delay();
    return List.unmodifiable(_byAsset[assetId] ?? const []);
  }

  @override
  Future<int> countAll() async {
    await _delay();
    return _byAsset.values.fold<int>(0, (sum, list) => sum + list.length);
  }

  @override
  Future<DocumentMeta> upload({
    required String assetId,
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    required DocKind kind,
    String? assetDateId,
  }) async {
    await _delay();
    final doc = DocumentMeta(
      id: 'doc_${_seq++}',
      assetId: assetId,
      assetDateId: assetDateId,
      title: fileName,
      kind: kind,
      mimeType: mimeType,
      sizeBytes: bytes.length,
      storagePath: 'local/$assetId/$fileName',
      createdAt: DateTime.now(),
    );
    (_byAsset[assetId] ??= []).add(doc);
    return doc;
  }

  @override
  Future<String?> viewUrl(DocumentMeta doc) async => null;

  @override
  Future<void> delete(DocumentMeta doc) async {
    await _delay();
    _byAsset[doc.assetId]?.removeWhere((d) => d.id == doc.id);
  }
}
