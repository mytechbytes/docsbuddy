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
