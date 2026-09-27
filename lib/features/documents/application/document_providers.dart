import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/media/picked_media.dart';
import '../domain/document_models.dart';
import '../domain/document_repository.dart';

/// Bound at the composition root (`bootstrap/dependencies.dart`).
final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) => throw UnimplementedError('documentRepositoryProvider must be overridden'),
);

final assetDocumentsProvider = FutureProvider.family<List<DocumentMeta>, String>((ref, assetId) {
  return ref.watch(documentRepositoryProvider).forAsset(assetId);
});

/// The documents attached to one service on an asset.
final serviceDocumentsProvider =
    FutureProvider.family<List<DocumentMeta>, ({String assetId, String reminderId})>((ref, key) async {
  final docs = await ref.watch(assetDocumentsProvider(key.assetId).future);
  return docs.where((d) => d.assetDateId == key.reminderId).toList();
});

/// Signed display URL for a document, cached per document so thumbnail grids
/// don't re-sign on every rebuild. Null when files aren't viewable (offline).
final documentUrlProvider = FutureProvider.family<String?, DocumentMeta>((ref, doc) async {
  try {
    return await ref.watch(documentRepositoryProvider).viewUrl(doc);
  } catch (e) {
    ref.read(appLoggerProvider).info('No preview URL for ${doc.id}: $e');
    return null;
  }
});

final documentCountProvider = FutureProvider<int>((ref) => ref.watch(documentRepositoryProvider).countAll());

/// Document actions for one asset. Methods throw `AppFailure`.
class AssetDocumentsController {
  AssetDocumentsController(this._ref, this.assetId);

  final Ref _ref;
  final String assetId;

  DocumentRepository get _repo => _ref.read(documentRepositoryProvider);
  AppLogger get _logger => _ref.read(appLoggerProvider);

  /// Uploads every file, continuing past failures; returns how many failed.
  /// [kind] defaults to photo/other by file type; [reminderId] scopes the
  /// documents to a service.
  Future<int> upload(List<PickedMedia> files, {DocKind? kind, String? reminderId}) async {
    var failed = 0;
    for (final f in files) {
      try {
        await _repo.upload(
          assetId: assetId,
          assetDateId: reminderId,
          fileName: f.name,
          bytes: f.bytes,
          mimeType: f.docMime,
          kind: kind ?? kindForFileName(f.name),
        );
      } catch (e, st) {
        _logger.warning('Upload of ${f.name} failed', error: e, stackTrace: st);
        failed++;
      }
    }
    if (files.isNotEmpty) _ref.invalidate(assetDocumentsProvider(assetId));
    return failed;
  }

  /// Uploads from the documents section: like [upload], but reports partial
  /// failure as a [ServerFailure].
  Future<void> attach(List<PickedMedia> files) async {
    final failed = await upload(files);
    if (failed > 0) {
      throw ServerFailure('$failed of ${files.length} uploads failed.',
          reason: FailureReason.uploadsFailed, args: [failed, files.length]);
    }
  }

  Future<void> delete(DocumentMeta doc) async {
    await _repo.delete(doc);
    _ref.invalidate(assetDocumentsProvider(assetId));
  }

  Future<String> viewUrl(DocumentMeta doc) => _repo.viewUrl(doc);

  Future<Uint8List> download(DocumentMeta doc) => _repo.download(doc);
}

final assetDocumentsControllerProvider = Provider.family<AssetDocumentsController, String>(
  (ref, assetId) => AssetDocumentsController(ref, assetId),
);

/// Builds the controller for an asset created mid-operation (its id isn't
/// known until after an `await`, when `ref` may no longer be usable).
final assetDocumentsControllerFactoryProvider = Provider<AssetDocumentsController Function(String assetId)>(
  (ref) => (assetId) => ref.read(assetDocumentsControllerProvider(assetId)),
);
