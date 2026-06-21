import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/catalog_models.dart';
import '../data/catalog_repository.dart';
import '../data/fake_catalog_repository.dart';

/// Single catalog repository instance (seeded fake for now; a Supabase-backed
/// implementation can replace this behind the same interface).
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) => FakeCatalogRepository());

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

/// Refreshes every catalog list view after a mutation.
void refreshCatalog(WidgetRef ref) {
  ref.invalidate(upcomingRemindersProvider);
  ref.invalidate(assetsProvider);
}
