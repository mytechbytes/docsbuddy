import 'dart:typed_data';

import 'package:docsbuddy/features/documents/data/document_models.dart';
import 'package:docsbuddy/features/documents/data/fake_document_repository.dart';
import 'package:docsbuddy/features/documents/presentation/asset_documents_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fake document repo: upload then list', () async {
    final repo = FakeDocumentRepository();
    expect(await repo.forAsset('a1'), isEmpty);

    final doc = await repo.upload(
      assetId: 'a1',
      fileName: 'invoice.pdf',
      bytes: Uint8List.fromList([1, 2, 3]),
      mimeType: 'application/pdf',
      kind: DocKind.invoice,
    );
    expect(doc.title, 'invoice.pdf');
    expect(doc.sizeBytes, 3);

    final list = await repo.forAsset('a1');
    expect(list, hasLength(1));
    expect(list.first.kind, DocKind.invoice);

    await repo.delete(doc);
    expect(await repo.forAsset('a1'), isEmpty);
  });

  testWidgets('documents section renders its empty state', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: Scaffold(body: AssetDocumentsSection(assetId: 'a1'))),
    ));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('DOCUMENTS'), findsOneWidget);
    expect(find.textContaining('No documents yet'), findsOneWidget);
    expect(find.text('+ Add'), findsOneWidget);
  });
}
