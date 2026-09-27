import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/submit_controller.dart';
import '../../../core/media/picked_media.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_inputs.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../documents/application/document_providers.dart';
import '../../documents/domain/document_models.dart';

/// Creates or edits a service on an asset, then attaches the picked files to
/// that service (`documents.asset_date_id`).
class ReminderEditorController extends SubmitController {
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
