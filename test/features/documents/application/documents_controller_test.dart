import 'dart:typed_data';

import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/media/picked_media.dart';
import 'package:docsbuddy/features/documents/application/document_providers.dart';
import 'package:docsbuddy/features/documents/data/fake_document_repository.dart';
import 'package:docsbuddy/features/documents/domain/document_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

/// Rejects files named `bad*` to exercise partial failure.
class _PickyDocuments extends FakeDocumentRepository {
  @override
  Future<DocumentMeta> upload({
    required String assetId,
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    required DocKind kind,
    String? assetDateId,
  }) {
    if (fileName.startsWith('bad')) throw const ServerFailure('rejected');
    return super.upload(
        assetId: assetId, fileName: fileName, bytes: bytes, mimeType: mimeType, kind: kind, assetDateId: assetDateId);
  }
}

void main() {
  PickedMedia file(String name) => PickedMedia(name: name, bytes: Uint8List(2));

  test('upload infers the kind from the file type and keeps going past failures', () async {
    final container = makeContainer(overrides: testOverrides(documents: _PickyDocuments()));
    final docs = container.read(assetDocumentsControllerProvider('a1'));

    final failed = await docs.upload([file('photo.JPG'), file('bad.pdf'), file('manual.pdf')]);
    expect(failed, 1);
    final stored = await container.read(assetDocumentsProvider('a1').future);
    expect({for (final d in stored) d.title: d.kind}, {'photo.JPG': DocKind.photo, 'manual.pdf': DocKind.other});
  });

  test('attach reports partial failure as a user-safe message', () async {
    final container = makeContainer(overrides: testOverrides(documents: _PickyDocuments()));
    await expectLater(
      container.read(assetDocumentsControllerProvider('a1')).attach([file('ok.pdf'), file('bad.pdf')]),
      throwsA(isA<ServerFailure>().having((f) => f.message, 'message', '1 of 2 uploads failed.')),
    );
  });

  test('offline, viewing a file is Unavailable and the URL provider yields null', () async {
    final container = makeContainer();
    final docs = container.read(assetDocumentsControllerProvider('a1'));
    await docs.upload([file('x.pdf')]);
    final doc = (await container.read(assetDocumentsProvider('a1').future)).single;
    await expectLater(docs.viewUrl(doc), throwsA(isA<UnavailableFailure>()));
    expect(await container.read(documentUrlProvider(doc).future), isNull);
  });

  test('document helpers', () {
    expect(fileExtension('a.b.PDF'), 'pdf');
    expect(isImageFileName('x.heic'), isTrue);
    expect(kindForFileName('scan.png'), DocKind.photo);
    expect(formatBytes(2048), '2 KB');
    expect(formatBytes(3 * 1024 * 1024 + 1), '3.0 MB');
  });
}
