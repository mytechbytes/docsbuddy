import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/media/picked_media.dart';
import '../domain/catalog_models.dart';
import '../domain/catalog_repository.dart';
import 'catalog_providers.dart';

/// Mutations available from an asset's detail page. Each refreshes the
/// affected reads; failures surface as `AppFailure`.
class AssetActions {
  AssetActions(this._ref, this.assetId);

  final Ref _ref;
  final String assetId;

  CatalogRepository get _repo => _ref.read(catalogRepositoryProvider);
  void _refresh() => _ref.read(catalogRefresherProvider).asset(assetId);

  Future<void> setPhoto(PickedMedia photo) async {
    await _repo.setAssetImage(assetId, bytes: photo.bytes, fileName: photo.name, mimeType: photo.imageMime);
    _refresh();
  }

  /// Marks a service done — recurring ones roll their due date forward.
  Future<void> completeService(Reminder reminder) async {
    await _repo.completeReminder(reminder.id);
    _refresh();
  }

  Future<void> deleteService(Reminder reminder) async {
    await _repo.deleteReminder(reminder.id);
    _refresh();
  }

  Future<void> deleteAsset() async {
    await _repo.deleteAsset(assetId);
    _ref.read(catalogRefresherProvider).all();
  }

  /// Call after returning from an edit screen that may have changed data.
  void refresh() => _refresh();
}

final assetActionsProvider = Provider.family<AssetActions, String>((ref, assetId) => AssetActions(ref, assetId));
