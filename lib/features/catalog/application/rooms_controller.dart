import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/media/picked_media.dart';
import '../domain/catalog_models.dart';
import '../domain/catalog_repository.dart';
import 'catalog_providers.dart';

/// Rooms (`public.locations`) with their asset counts, plus room mutations.
/// Reordering is optimistic: the new order shows immediately and reverts if
/// saving fails. Mutations throw [AppFailure].
class RoomsController extends AsyncNotifier<List<Location>> {
  CatalogRepository get _repo => ref.read(catalogRepositoryProvider);

  @override
  Future<List<Location>> build() => ref.watch(catalogRepositoryProvider).locations();

  Future<void> refresh() async {
    ref.invalidateSelf();
    ref.invalidate(assetsProvider);
    await future;
  }

  /// Creates a room (and uploads its optional photo).
  Future<Location> create(String name, {PickedMedia? photo}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw const ValidationFailure('Please name the room.');
    final room = await _repo.createLocation(trimmed);
    if (photo != null) {
      await _repo.setLocationImage(room.id, bytes: photo.bytes, fileName: photo.name, mimeType: photo.imageMime);
    }
    ref.invalidateSelf();
    return room;
  }

  /// Moves the room at [oldIndex] to [newIndex] (already adjusted for the
  /// removed item, as `onReorderItem` reports it).
  Future<void> reorder(int oldIndex, int newIndex) async {
    final previous = state.value;
    if (previous == null) return;
    final next = [...previous];
    next.insert(newIndex, next.removeAt(oldIndex));
    state = AsyncData(next);
    try {
      await _repo.reorderLocations([for (final l in next) l.id]);
    } catch (e) {
      state = AsyncData(previous);
      throw AppFailure.from(e);
    }
  }

  Future<void> rename(Location room, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed == room.name) return;
    await _repo.updateLocation(room.id, name: trimmed);
    ref.invalidateSelf();
    ref.invalidate(assetsProvider);
  }

  Future<void> setPhoto(Location room, PickedMedia photo) async {
    await _repo.setLocationImage(room.id, bytes: photo.bytes, fileName: photo.name, mimeType: photo.imageMime);
    ref.invalidateSelf();
  }
}

final locationsProvider = AsyncNotifierProvider<RoomsController, List<Location>>(RoomsController.new);
