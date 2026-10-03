import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/loader.dart';
import '../../../core/widgets/db_logo.dart';
import '../../../core/widgets/feedback.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/widgets/catalog_widgets.dart';
import '../application/dashboard_controller.dart';
import '../../../routing/app_routes.dart';
import '../../reminders/application/reminder_providers.dart';
import 'widgets/dashboard_widgets.dart';
import '../../profile/presentation/widgets/profile_avatar_button.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  Future<void> _openFilter(BuildContext context, WidgetRef ref) async {
    final selected = {...ref.read(dashboardControllerProvider).kinds};
    final applied = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(context.l10n.dashboardFilterByType,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
                    ),
                    TextButton(
                      onPressed: () => setSheetState(selected.clear),
                      child: Text(context.l10n.commonClear, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final k in ReminderKind.values)
                      FilterChip(
                        selected: selected.contains(k),
                        onSelected: (v) => setSheetState(() => v ? selected.add(k) : selected.remove(k)),
                        avatar: selected.contains(k) ? null : Icon(k.icon, size: 15, color: k.fg),
                        label: Text(k.displayName(context)),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: selected.contains(k) ? k.fg : context.palette.textSecondary),
                        selectedColor: k.bg,
                        checkmarkColor: k.fg,
                        backgroundColor: context.palette.background,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999), side: BorderSide(color: context.palette.border)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: context.palette.inverseSurface),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(context.l10n.commonApply, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (applied == true) ref.read(dashboardControllerProvider.notifier).setKinds(selected);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardViewProvider);
    final overdue = ref.watch(hasOverdueProvider);

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        titleSpacing: 20,
        title: const Align(alignment: AlignmentDirectional.centerStart, child: DbLogo(size: 20)),
        actions: [
          AppBarIconButton(Icons.search, onTap: () => context.push(AppRoutes.search)),
          AppBarIconButton(Icons.notifications_none, dot: overdue, onTap: () => context.push(AppRoutes.notifications)),
          const Padding(padding: EdgeInsetsDirectional.only(start: 8), child: ProfileAvatarButton()),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Tabs share an IndexedStack, so the default hero tag would collide.
        heroTag: null,
        onPressed: () => context.push(AppRoutes.appliancePicker()),
        backgroundColor: context.palette.accent,
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(catalogRefresherProvider).all();
          await ref.read(dashboardViewProvider.future);
        },
        child: dashboard.when(
          loading: () => LoadingView(message: context.l10n.loadingDashboard),
          error: (e, _) => Center(child: Text(context.failureText(e))),
          data: (view) {
            final filter = view.filter;
            final visible = view.visible;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
              children: [
                StatGrid(counts: view.counts, assetCount: view.assetCount),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(context.l10n.dashboardUpcoming,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: context.palette.text)),
                    ),
                    PopupMenuButton<bool>(
                      tooltip: context.l10n.dashboardGroupBy,
                      onSelected: (v) => ref.read(dashboardControllerProvider.notifier).setGroupByAsset(v),
                      itemBuilder: (_) => [
                        CheckedPopupMenuItem(
                            value: false, checked: !filter.groupByAsset, child: Text(context.l10n.dashboardGroupNone)),
                        CheckedPopupMenuItem(
                            value: true, checked: filter.groupByAsset, child: Text(context.l10n.dashboardGroupAsset)),
                      ],
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: filter.groupByAsset ? context.palette.inverseSurface : context.palette.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: context.palette.border),
                        ),
                        child: Icon(Icons.layers_outlined,
                            size: 17, color: filter.groupByAsset ? context.palette.onInverse : context.palette.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _openFilter(context, ref),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: filter.kinds.isEmpty ? context.palette.surface : context.palette.inverseSurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: context.palette.border),
                        ),
                        child: Icon(Icons.tune, size: 17, color: filter.kinds.isEmpty ? context.palette.textSecondary : context.palette.onInverse),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (visible.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                        child: Text(
                            filter.kinds.isEmpty
                                ? context.l10n.dashboardEmpty
                                : context.l10n.dashboardNoMatches,
                            style: TextStyle(color: context.palette.textMuted))),
                  )
                else if (filter.groupByAsset)
                  for (final group in view.groups) AssetGroupCard(reminders: group, asset: view.assetsById[group.first.assetId])
                else
                  for (final r in visible) UpcomingReminderTile(reminder: r),
              ],
            );
          },
        ),
      ),
    );
  }
}
