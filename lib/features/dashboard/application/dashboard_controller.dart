import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../reminders/domain/reminder_filters.dart';
import '../../catalog/domain/reminder_ordering.dart';

part 'dashboard_controller.freezed.dart';

/// How the Upcoming list is filtered/grouped.
@freezed
abstract class DashboardFilter with _$DashboardFilter {
  const factory DashboardFilter({
    /// Kind filter (empty = everything).
    @Default(<ReminderKind>{}) Set<ReminderKind> kinds,

    /// Group the list by asset (design 01) instead of a flat list.
    @Default(false) bool groupByAsset,
  }) = _DashboardFilter;
}

class DashboardController extends Notifier<DashboardFilter> {
  @override
  DashboardFilter build() => const DashboardFilter();

  void setKinds(Set<ReminderKind> kinds) => state = state.copyWith(kinds: kinds);

  void setGroupByAsset(bool value) => state = state.copyWith(groupByAsset: value);
}

final dashboardControllerProvider = NotifierProvider<DashboardController, DashboardFilter>(DashboardController.new);

/// Everything the dashboard renders, derived from the reminders, assets and
/// the current filter.
@freezed
abstract class DashboardView with _$DashboardView {
  const factory DashboardView({
    /// Service count per stat card.
    required Map<ReminderFilter, int> counts,
    required int assetCount,

    /// Filtered, soonest first.
    required List<Reminder> visible,

    /// [visible] bucketed by asset (used when grouping).
    required List<List<Reminder>> groups,
    required Map<String, Asset> assetsById,
    required DashboardFilter filter,
  }) = _DashboardView;
}

final dashboardViewProvider = FutureProvider<DashboardView>((ref) async {
  final (reminders, assets) = await (
    ref.watch(upcomingRemindersProvider.future),
    ref.watch(assetsProvider.future),
  ).wait;
  final filter = ref.watch(dashboardControllerProvider);
  final visible = sortedByUrgency(filterByKinds(reminders, filter.kinds));
  return DashboardView(
    counts: {for (final f in ReminderFilter.values) f: filterReminders(reminders, f).length},
    assetCount: assets.length,
    visible: visible,
    groups: groupByAsset(visible),
    assetsById: {for (final a in assets) a.id: a},
    filter: filter,
  );
});
