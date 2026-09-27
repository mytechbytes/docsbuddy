import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/submit_controller.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/media/picked_media.dart';
import '../../documents/application/document_providers.dart';
import '../../documents/domain/document_models.dart';
import '../domain/catalog_inputs.dart';
import '../domain/catalog_models.dart';
import '../domain/default_reminders.dart';
import 'catalog_providers.dart';

/// Creates or edits an asset. On create it also seeds the type's default
/// services and attaches invoices; the photo is uploaded in both modes.
/// Photo/invoice/seed failures don't fail the save — they can be redone from
/// the asset page.
class AssetEditorController extends SubmitController {
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
        final logger = ref.read(appLoggerProvider);
        final asset = editing == null ? await repo.addAsset(input) : await repo.updateAsset(editing.id, input);

        if (editing == null) {
          try {
            final seeds = expandDefaultReminders(draft.type, purchaseDate: asset.purchaseDate, amcDate: amcDate);
            for (final s in seeds) {
              await repo.addReminder(asset.id, s);
            }
          } catch (e, st) {
            // Asset saved; services can be added manually.
            logger.warning('Seeding default services failed', error: e, stackTrace: st);
          }
          if (invoices.isNotEmpty) await documentsFor(asset.id).upload(invoices, kind: DocKind.invoice);
        }

        if (photo != null) {
          try {
            await repo.setAssetImage(asset.id, bytes: photo.bytes, fileName: photo.name, mimeType: photo.imageMime);
          } catch (e, st) {
            // Retry from the asset page.
            logger.warning('Asset photo upload failed', error: e, stackTrace: st);
          }
        }

        refresher.asset(asset.id);
        return asset;
      });
}

final assetEditorControllerProvider =
    AsyncNotifierProvider.autoDispose<AssetEditorController, void>(AssetEditorController.new);
