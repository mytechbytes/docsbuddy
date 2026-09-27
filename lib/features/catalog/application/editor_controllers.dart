import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/media/picked_media.dart';
import '../../documents/application/document_providers.dart';
import '../../documents/domain/document_models.dart';
import '../domain/catalog_inputs.dart';
import '../domain/catalog_models.dart';
import '../domain/default_reminders.dart';
import 'catalog_providers.dart';

/// Shared submit plumbing: `state` is the in-flight status the form watches
/// (spinner / disabled CTA); failures are normalised to [AppFailure], stored
/// in `state` and rethrown so the caller can show them.
///
/// Subclasses resolve their dependencies *before* the first `await`: these
/// providers auto-dispose, so `ref` may be gone by the time the save ends.
abstract class _SubmitController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<T> submit<T>(Future<T> Function() action) async {
    state = const AsyncLoading();
    try {
      final result = await action();
      if (ref.mounted) state = const AsyncData(null);
      return result;
    } catch (e, st) {
      final failure = AppFailure.from(e);
      if (ref.mounted) state = AsyncError(failure, st);
      throw failure;
    }
  }
}

/// Creates or edits an asset. On create it also seeds the type's default
/// services and attaches invoices; the photo is uploaded in both modes.
/// Photo/invoice/seed failures don't fail the save — they can be redone from
/// the asset page.
class AssetEditorController extends _SubmitController {
  Future<Asset> save({
    required AssetDraft draft,
    Asset? editing,
    PickedMedia? photo,
    List<PickedMedia> invoices = const [],
    DateTime? amcDate,
  }) =>
      submit(() async {
        final input = draft.toInput();
        final repo = ref.read(catalogRepositoryProvider);
        final refresher = ref.read(catalogRefresherProvider);
        final documentsFor = ref.read(assetDocumentsControllerFactoryProvider);
        final asset = editing == null ? await repo.addAsset(input) : await repo.updateAsset(editing.id, input);

        if (editing == null) {
          try {
            final seeds = expandDefaultReminders(draft.type, purchaseDate: asset.purchaseDate, amcDate: amcDate);
            for (final s in seeds) {
              await repo.addReminder(asset.id, s);
            }
          } catch (_) {/* asset saved; services can be added manually */}
          if (invoices.isNotEmpty) await documentsFor(asset.id).upload(invoices, kind: DocKind.invoice);
        }

        if (photo != null) {
          try {
            await repo.setAssetImage(asset.id, bytes: photo.bytes, fileName: photo.name, mimeType: photo.imageMime);
          } catch (_) {/* retry from the asset page */}
        }

        refresher.asset(asset.id);
        return asset;
      });
}

final assetEditorControllerProvider =
    AsyncNotifierProvider.autoDispose<AssetEditorController, void>(AssetEditorController.new);

/// Creates or edits a service on an asset, then attaches the picked files to
/// that service (`documents.asset_date_id`).
class ReminderEditorController extends _SubmitController {
  Future<Reminder> save({
    required String assetId,
    required ReminderDraft draft,
    Reminder? editing,
    List<PickedMedia> attachments = const [],
  }) =>
      submit(() async {
        final input = draft.toInput();
        final repo = ref.read(catalogRepositoryProvider);
        final refresher = ref.read(catalogRefresherProvider);
        final documents = ref.read(assetDocumentsControllerProvider(assetId));
        final reminder =
            editing == null ? await repo.addReminder(assetId, input) : await repo.updateReminder(editing.id, input);

        if (attachments.isNotEmpty) {
          await documents.upload(
            attachments,
            kind: input.kind == ReminderKind.insurance ? DocKind.insurance : DocKind.other,
            reminderId: reminder.id,
          );
        }

        refresher.asset(assetId);
        return reminder;
      });
}

final reminderEditorControllerProvider =
    AsyncNotifierProvider.autoDispose<ReminderEditorController, void>(ReminderEditorController.new);
