import 'dart:typed_data';

import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/media/picked_media.dart';
import 'package:docsbuddy/features/catalog/application/catalog_providers.dart';
import 'package:docsbuddy/features/catalog/application/editor_controllers.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_inputs.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/documents/data/fake_document_repository.dart';
import 'package:docsbuddy/features/documents/domain/document_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/catalog_fixtures.dart';
import '../../../helpers/test_app.dart';

void main() {
  late FakeCatalogRepository catalog;
  late FakeDocumentRepository documents;
  late ProviderContainer container;

  setUp(() {
    catalog = FakeCatalogRepository(latency: Duration.zero);
    documents = FakeDocumentRepository();
    container = makeContainer(overrides: testOverrides(catalog: catalog, documents: documents));
    // The form watches its controller for the whole save, as here.
    container.listen(assetEditorControllerProvider, (_, _) {});
  });

  PickedMedia file(String name) => PickedMedia(name: name, bytes: Uint8List.fromList([1, 2]));

  group('AssetEditorController', () {
    test('an invalid draft fails with a ValidationFailure and stores it in state', () async {
      final sub = container.listen(assetEditorControllerProvider, (_, _) {});
      final controller = container.read(assetEditorControllerProvider.notifier);

      await expectLater(
        controller.save(draft: const AssetDraft(name: '', category: AssetCategoryKind.vehicle)),
        throwsA(isA<ValidationFailure>()),
      );
      expect(sub.read().error, isA<ValidationFailure>());
    });

    test('create seeds the type’s default services, attaches invoices, uploads the photo', () async {
      final sub = container.listen(assetEditorControllerProvider, (_, _) {});
      final asset = await container.read(assetEditorControllerProvider.notifier).save(
            draft: const AssetDraft(name: 'Bedroom AC', category: AssetCategoryKind.appliance, type: acCategory),
            photo: file('ac.jpg'),
            invoices: [file('invoice.pdf')],
          );

      expect(sub.read(), isA<AsyncData<void>>());
      final services = await catalog.remindersFor(asset.id);
      expect(services.map((r) => r.label), containsAll(['AMC', 'Wet Service', 'Warranty']));
      final docs = await documents.forAsset(asset.id);
      expect(docs.single.kind, DocKind.invoice);
      expect((await catalog.asset(asset.id)).imageUrl, isNotNull);
    });

    test('edit updates without seeding or attaching', () async {
      final existing = (await catalog.assets()).first;
      final before = (await catalog.remindersFor(existing.id)).length;

      final updated = await container.read(assetEditorControllerProvider.notifier).save(
            draft: AssetDraft(name: 'Renamed', category: existing.category, type: acCategory),
            editing: existing,
            invoices: [file('ignored.pdf')],
          );

      expect(updated.name, 'Renamed');
      expect(await catalog.remindersFor(existing.id), hasLength(before));
      expect(await documents.forAsset(existing.id), isEmpty);
    });

    test('saving refreshes catalog reads', () async {
      final initial = await container.read(assetsProvider.future);
      await container
          .read(assetEditorControllerProvider.notifier)
          .save(draft: const AssetDraft(name: 'Kettle', category: AssetCategoryKind.appliance));
      expect(await container.read(assetsProvider.future), hasLength(initial.length + 1));
    });
  });
}
