import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/asset_search.dart';
import '../domain/catalog_models.dart';
import '../domain/catalog_repository.dart';
import '../domain/common_categories.dart';
import '../domain/reminder_filters.dart';
import 'rooms_controller.dart';

/// Bound at the composition root (`bootstrap/dependencies.dart`).
final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => throw UnimplementedError('catalogRepositoryProvider must be overridden'),
);

// ── Queries ──

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
/// rows exist for the enum backfill). Falls back to the built-in common types
/// when the backend catalog is empty or unreachable, so the picker is never
/// blank.
final categoriesProvider = FutureProvider<List<AssetCategory>>((ref) async {
  try {
    final all = await ref.watch(catalogRepositoryProvider).categories();
    final specific = all.where((c) => !c.isGeneric).toList();
    if (specific.isNotEmpty) return specific;
  } catch (_) {/* fall through to the built-ins */}
  return commonAssetCategories;
});

/// Displayable URL for a stored image reference (signed for bucket paths),
/// cached per reference so list rows don't re-sign on every rebuild.
final assetImageUrlProvider = FutureProvider.family<String?, String>((ref, imageRef) {
  return ref.watch(catalogRepositoryProvider).resolveImageUrl(imageRef);
});

// ── Derived read models ──

/// Search results across assets and services (empty query → nothing).
final catalogSearchProvider =
    Provider.family<({List<Asset> assets, List<Reminder> reminders}), String>((ref, query) {
  if (query.trim().isEmpty) return (assets: const <Asset>[], reminders: const <Reminder>[]);
  final assets = ref.watch(assetsProvider).value ?? const <Asset>[];
  final reminders = ref.watch(upcomingRemindersProvider).value ?? const <Reminder>[];
  return (
    assets: assets.where((a) => assetMatches(a, query)).toList(),
    reminders: reminders.where((r) => reminderMatches(r, query)).toList(),
  );
});

/// The Assets tab list filtered by its search box.
final filteredAssetsProvider = FutureProvider.family<List<Asset>, String>((ref, query) async {
  final assets = await ref.watch(assetsProvider.future);
  return assets.where((a) => assetMatches(a, query)).toList();
});

/// Appliance-picker types filtered by its search box.
final filteredCategoriesProvider = FutureProvider.family<List<AssetCategory>, String>((ref, query) async {
  final categories = await ref.watch(categoriesProvider.future);
  return categories.where((c) => categoryMatches(c, query)).toList();
});

/// A stat card's reminder subset.
final filteredRemindersProvider = FutureProvider.family<List<Reminder>, ReminderFilter>((ref, filter) async {
  return filterReminders(await ref.watch(upcomingRemindersProvider.future), filter);
});

/// The bell inbox: overdue services and those inside a notify window.
final notificationInboxProvider =
    FutureProvider<({List<Reminder> overdue, List<Reminder> comingUp})>((ref) async {
  final list = await ref.watch(upcomingRemindersProvider.future);
  return (overdue: list.where(isOverdue).toList(), comingUp: list.where(inAlertWindow).toList());
});

final hasOverdueProvider = Provider<bool>(
  (ref) => ref.watch(upcomingRemindersProvider).value?.any(isOverdue) ?? false,
);

/// An asset's services, most urgent first, plus the soonest one.
final assetServicesProvider =
    FutureProvider.family<({List<Reminder> all, Reminder? next}), String>((ref, assetId) async {
  final list = await ref.watch(assetRemindersProvider(assetId).future);
  return (all: list, next: soonest(list));
});

/// One room with the appliances in it and each appliance's services.
typedef RoomDetail = ({Location room, List<({Asset asset, List<Reminder> reminders})> appliances});

final roomDetailProvider = FutureProvider.family<RoomDetail?, String>((ref, locationId) async {
  final (rooms, assets, reminders) = await (
    ref.watch(locationsProvider.future),
    ref.watch(assetsProvider.future),
    ref.watch(upcomingRemindersProvider.future),
  ).wait;
  final room = rooms.where((l) => l.id == locationId).firstOrNull;
  if (room == null) return null;
  return (
    room: room,
    appliances: [
      for (final a in assets.where((a) => a.isIn(room))) (asset: a, reminders: remindersForAsset(a.id, reminders)),
    ],
  );
});

// ── Invalidation ──

/// Refreshes catalog reads after a mutation or on pull-to-refresh.
class CatalogRefresher {
  CatalogRefresher(this._ref);
  final Ref _ref;

  void all() {
    _ref.invalidate(upcomingRemindersProvider);
    _ref.invalidate(assetsProvider);
    _ref.invalidate(locationsProvider);
  }

  void asset(String assetId) {
    _ref.invalidate(assetProvider(assetId));
    _ref.invalidate(assetRemindersProvider(assetId));
    all();
  }
}

final catalogRefresherProvider = Provider<CatalogRefresher>((ref) => CatalogRefresher(ref));
