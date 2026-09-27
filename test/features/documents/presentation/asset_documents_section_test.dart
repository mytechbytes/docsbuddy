import 'package:docsbuddy/features/documents/presentation/asset_documents_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  testWidgets('documents section renders its empty state', (tester) async {
    await tester.pumpWidget(testApp(const Scaffold(body: AssetDocumentsSection(assetId: 'a1'))));
    await settle(tester);

    expect(find.text('DOCUMENTS'), findsOneWidget);
    expect(find.textContaining('No documents yet'), findsOneWidget);
    expect(find.text('+ Add'), findsOneWidget);
  });
}
