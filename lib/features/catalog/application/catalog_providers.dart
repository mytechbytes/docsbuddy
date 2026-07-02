import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/catalog_models.dart';
import '../data/catalog_repository.dart';
import '../data/fake_catalog_repository.dart';
import '../data/supabase_catalog_repository.dart';

/// Catalog repository: Supabase-backed when configured, else a seeded fake so
/// the app runs and is testable without a backend.
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  if (Env.hasSupabase) {
    return SupabaseCatalogRepository(Supabase.instance.client);
  }
  return FakeCatalogRepository();
});

final upcomingRemindersProvider = FutureProvider<List<Reminder>>((ref) {
  return ref.watch(catalogRepositoryProvider).upcomingReminders();
});

final assetsProvider = FutureProvider<List<Asset>>((ref) {
  return ref.watch(catalogRepositoryProvider).assets();
});

final assetProvider = FutureProvider.family<Asset, String>((ref, id) {
  return ref.watch(catalogRepositoryProvider).asset(id);
});

final assetRemindersProvider = FutureProvider.family<List<Reminder>, String>((ref, assetId) {
  return ref.watch(catalogRepositoryProvider).remindersFor(assetId);
});

/// The appliance/vehicle type catalog (only specific types — generic group
/// rows are filtered out; they exist for the enum backfill).
final categoriesProvider = FutureProvider<List<AssetCategory>>((ref) async {
  final all = await ref.watch(catalogRepositoryProvider).categories();
  return all.where((c) => !c.isGeneric).toList();
});

/// Displayable URL for a stored image reference (signed for bucket paths),
/// cached per reference so list rows don't re-sign on every rebuild.
final assetImageUrlProvider = FutureProvider.family<String?, String>((ref, imageRef) {
  return ref.watch(catalogRepositoryProvider).resolveImageUrl(imageRef);
});

/// Refreshes every catalog list view after a mutation.
void refreshCatalog(WidgetRef ref) {
  ref.invalidate(upcomingRemindersProvider);
  ref.invalidate(assetsProvider);
}
