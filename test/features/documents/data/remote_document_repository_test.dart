import 'dart:typed_data';

import 'package:docsbuddy/core/data/file_storage.dart';
import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/documents/data/document_mapper.dart';
import 'package:docsbuddy/features/documents/data/document_remote_data_source.dart';
import 'package:docsbuddy/features/documents/data/remote_document_repository.dart';
import 'package:docsbuddy/features/documents/domain/document_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockRemote extends Mock implements DocumentRemoteDataSource {}

class _MockFiles extends Mock implements FileStorage {}

Json _row({String id = 'd1'}) => {
      'id': id,
      'asset_id': 'a1',
      'title': 'invoice.pdf',
      'kind': 'invoice',
      'mime_type': 'application/pdf',
      'size_bytes': 3,
      'storage_path': 'fam/assets/a1/documents/1_invoice.pdf',
      'created_at': '2026-01-01T00:00:00Z',
    };

void main() {
  late _MockRemote remote;
  late _MockFiles files;
  late RemoteDocumentRepository repo;
  final now = DateTime(2026, 1, 1);

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    remote = _MockRemote();
    files = _MockFiles();
    repo = RemoteDocumentRepository(remote, files, clock: () => now);
  });

  test('mapper defaults missing fields', () {
    final d = DocumentMapper.fromRow({
      'id': 'd1',
      'asset_id': 'a1',
      'storage_path': 'p',
      'created_at': '2026-01-01T00:00:00Z',
      'kind': 'nonsense',
    });
    expect(d.title, 'Document');
    expect(d.kind, DocKind.other);
    expect(d.mimeType, 'application/octet-stream');
  });

  test('upload stores bytes under the family path, then the metadata row', () async {
    when(() => remote.currentUserId).thenReturn('u1');
    when(() => remote.familyIdOfAsset('a1')).thenAnswer((_) async => 'fam');
    when(() => files.upload(any(), any(), mimeType: any(named: 'mimeType'))).thenAnswer((_) async {});
    when(() => remote.insert(any())).thenAnswer((_) async => _row());

    final doc = await repo.upload(
        assetId: 'a1',
        fileName: 'my invoice.pdf',
        bytes: Uint8List(3),
        mimeType: 'application/pdf',
        kind: DocKind.invoice,
        assetDateId: 'r1');

    final path = 'fam/assets/a1/documents/${now.millisecondsSinceEpoch}_my_invoice.pdf';
    verify(() => files.upload(path, any(), mimeType: 'application/pdf')).called(1);
    final row = verify(() => remote.insert(captureAny())).captured.single as Json;
    expect(row, containsPair('asset_date_id', 'r1'));
    expect(row, containsPair('size_bytes', 3));
    expect(row, containsPair('uploaded_by', 'u1'));
    expect(doc.kind, DocKind.invoice);
  });

  test('storage errors surface as ServerFailure', () async {
    when(() => files.signedUrl(any(), expiresIn: any(named: 'expiresIn'))).thenThrow(StorageException('gone'));
    await expectLater(repo.viewUrl(DocumentMapper.fromRow(_row())), throwsA(isA<ServerFailure>()));
  });

  test('delete removes the file, then the row', () async {
    when(() => files.remove(any())).thenAnswer((_) async {});
    when(() => remote.delete('d1')).thenAnswer((_) async {});
    await repo.delete(DocumentMapper.fromRow(_row()));
    verifyInOrder([() => files.remove('fam/assets/a1/documents/1_invoice.pdf'), () => remote.delete('d1')]);
  });
}
