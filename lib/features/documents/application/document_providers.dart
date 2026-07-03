import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/document_models.dart';
import '../data/document_repository.dart';
import '../data/fake_document_repository.dart';
import '../data/supabase_document_repository.dart';

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  if (Env.hasSupabase) {
    return SupabaseDocumentRepository(Supabase.instance.client);
  }
  return FakeDocumentRepository();
});

final assetDocumentsProvider = FutureProvider.family<List<DocumentMeta>, String>((ref, assetId) {
  return ref.watch(documentRepositoryProvider).forAsset(assetId);
});

/// Signed display URL for a document's storage path, cached per path so
/// thumbnail grids don't re-sign on every rebuild (15-min expiry from the
/// repository is fine for a viewing session).
final documentUrlProvider = FutureProvider.family<String?, DocumentMeta>((ref, doc) {
  return ref.watch(documentRepositoryProvider).viewUrl(doc);
});
