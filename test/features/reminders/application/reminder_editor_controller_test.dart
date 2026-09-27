import 'dart:typed_data';

import 'package:docsbuddy/core/media/picked_media.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_inputs.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/documents/data/fake_document_repository.dart';
import 'package:docsbuddy/features/documents/domain/document_models.dart';
import 'package:docsbuddy/features/reminders/application/reminder_editor_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  late FakeCatalogRepository catalog;
  late FakeDocumentRepository documents;
  late ProviderContainer container;

  setUp(() {
    catalog = FakeCatalogRepository(latency: Duration.zero);
    documents = FakeDocumentRepository();
    container = makeContainer(overrides: testOverrides(catalog: catalog, documents: documents));
    container.listen(reminderEditorControllerProvider, (_, _) {});
  });

  PickedMedia file(String name) => PickedMedia(name: name, bytes: Uint8List.fromList([1, 2]));

  group('ReminderEditorController', () {
    test('saves the service and scopes attachments to it', () async {
      final asset = (await catalog.assets()).first;
      final reminder = await container.read(reminderEditorControllerProvider.notifier).save(
            assetId: asset.id,
            draft: ReminderDraft(
              kind: ReminderKind.insurance,
              dueDate: DateTime.now().add(const Duration(days: 40)),
              recurrence: Recurrence.yearly,
              notifyOffsets: const {7, 30},
              cost: '4,200',
            ),
            attachments: [file('policy.pdf')],
          );

      expect(reminder.notifyOffsets, [30, 7]);
      expect(reminder.cost, 4200);
      final doc = (await documents.forAsset(asset.id)).single;
      expect(doc.assetDateId, reminder.id);
      expect(doc.kind, DocKind.insurance);
    });
  });
}
