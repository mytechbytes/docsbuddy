import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/db_logo.dart';
import '../../../core/widgets/feedback.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/domain/reminder_filters.dart';
import '../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../profile/application/profile_providers.dart';
import '../application/dashboard_controller.dart';
import '../../../routing/app_routes.dart';

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  Future<void> _openFilter(BuildContext context, WidgetRef ref) async {
    final selected = {...ref.read(dashboardControllerProvider).kinds};
    final applied = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.paper,
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
                    const Expanded(
                      child: Text('Filter by type',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                    ),
                    TextButton(
                      onPressed: () => setSheetState(selected.clear),
                      child: const Text('Clear', style: TextStyle(fontWeight: FontWeight.w700)),
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
                        label: Text(k.label),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: selected.contains(k) ? k.fg : AppColors.ink2),
                        selectedColor: k.bg,
                        checkmarkColor: k.fg,
                        backgroundColor: AppColors.bg,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999), side: const BorderSide(color: AppColors.line)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.ink),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700)),
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
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        titleSpacing: 20,
        title: const Align(alignment: Alignment.centerLeft, child: DbLogo(size: 20)),
        actions: [
          _BarIcon(Icons.search, onTap: () => context.push(AppRoutes.search)),
          _BarIcon(Icons.notifications_none, dot: overdue, onTap: () => context.push(AppRoutes.notifications)),
          const _ProfileAvatar(),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.appliancePicker()),
        backgroundColor: AppColors.chipBlue,
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(catalogRefresherProvider).all();
          await ref.read(dashboardViewProvider.future);
        },
        child: dashboard.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(failureMessage(e))),
          data: (view) {
            final filter = view.filter;
            final visible = view.visible;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
              children: [
                _StatGrid(counts: view.counts, assetCount: view.assetCount),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Upcoming Expirations',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink)),
                    ),
                    PopupMenuButton<bool>(
                      tooltip: 'Group by',
                      onSelected: (v) => ref.read(dashboardControllerProvider.notifier).setGroupByAsset(v),
                      itemBuilder: (_) => [
                        CheckedPopupMenuItem(
                            value: false, checked: !filter.groupByAsset, child: const Text('Group by: None')),
                        CheckedPopupMenuItem(
                            value: true, checked: filter.groupByAsset, child: const Text('Group by: Asset')),
                      ],
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: filter.groupByAsset ? AppColors.ink : AppColors.paper,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Icon(Icons.layers_outlined,
                            size: 17, color: filter.groupByAsset ? Colors.white : AppColors.ink2),
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
                          color: filter.kinds.isEmpty ? AppColors.paper : AppColors.ink,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Icon(Icons.tune, size: 17, color: filter.kinds.isEmpty ? AppColors.ink2 : Colors.white),
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
                                ? 'No reminders yet. Add an asset to get started.'
                                : 'Nothing matches the selected types.',
                            style: const TextStyle(color: AppColors.muted))),
                  )
                else if (filter.groupByAsset)
                  for (final group in view.groups) _AssetGroupCard(reminders: group, asset: view.assetsById[group.first.assetId])
                else
                  for (final r in visible) _ReminderTile(reminder: r),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BarIcon extends StatelessWidget {
  const _BarIcon(this.icon, {this.dot = false, this.onTap});
  final IconData icon;
  final bool dot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: const EdgeInsets.only(left: 4),
      icon: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(icon, color: AppColors.ink2, size: 23),
          if (dot)
            Positioned(
              right: 1,
              top: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bg, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Real `users.avatar_url`; tap opens Profile.
class _ProfileAvatar extends ConsumerWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.push(AppRoutes.profile),
        child: AssetThumb(
          imageRef: profile?.avatarUrl,
          size: 32,
          radius: 16,
          fallback: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFFF1C27D), Color(0xFFD68B5C)]),
            ),
            alignment: Alignment.center,
            child: profile == null
                ? const Icon(Icons.person, color: Colors.white, size: 18)
                : Text(profile.initial,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

/// 2×2 grid of coloured summary cards — every tile counts **services**
/// (asset_dates rows) and deep-links to its filtered list — plus a
/// full-width total-appliances card.
class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.counts, required this.assetCount});
  final Map<ReminderFilter, int> counts;
  final int assetCount;

  @override
  Widget build(BuildContext context) {
    int count(ReminderFilter f) => counts[f] ?? 0;
    return Column(
      children: [
        Row(
          children: [
            _StatCard(
                value: '${count(ReminderFilter.active)}',
                label: 'Active Services',
                icon: Icons.description_outlined,
                bg: AppColors.navy,
                fg: Colors.white,
                filter: ReminderFilter.active),
            const SizedBox(width: 12),
            _StatCard(
                value: '${count(ReminderFilter.secured)}',
                label: 'Secured',
                icon: Icons.shield_outlined,
                bg: AppColors.teal,
                fg: Colors.white,
                filter: ReminderFilter.secured),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _StatCard(
                value: '${count(ReminderFilter.soon)}',
                label: 'Expiring Soon',
                icon: Icons.hourglass_bottom,
                bg: const Color(0xFFC9D6E0),
                fg: AppColors.ink,
                filter: ReminderFilter.soon),
            const SizedBox(width: 12),
            _StatCard(
                value: '${count(ReminderFilter.expired)}',
                label: 'Expired',
                icon: Icons.error_outline,
                bg: const Color(0xFFE89098),
                fg: AppColors.ink,
                filter: ReminderFilter.expired),
          ],
        ),
        const SizedBox(height: 12),
        _AppliancesCard(count: assetCount),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.value,
      required this.label,
      required this.icon,
      required this.bg,
      required this.fg,
      required this.filter});
  final String value;
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final ReminderFilter filter;

  @override
  Widget build(BuildContext context) {
    final sub = fg.withValues(alpha: 0.72);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push(AppRoutes.reminders(filter)),
        child: Container(
          height: 118,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(label,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: sub, height: 1.1))),
                  Icon(icon, size: 18, color: sub),
                ],
              ),
              const Spacer(),
              Text(value, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: fg, height: 1.0)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sub)),
                  Icon(Icons.chevron_right, size: 15, color: sub),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width "total active appliances" strip under the service stats.
class _AppliancesCard extends StatelessWidget {
  const _AppliancesCard({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: const Color(0xFFEEF3FB), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.kitchen_outlined, color: AppColors.chipBlue, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Total Active Appliances',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
          ),
          Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink)),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push(AppRoutes.asset(reminder.assetId)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            AssetThumb(
              imageRef: reminder.assetImageUrl,
              size: 46,
              fallback: IconBubble(kind: reminder.kind, size: 46),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reminder.assetName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink, height: 1.15)),
                  const SizedBox(height: 3),
                  Text('${reminder.label} · ${DateFormat('d MMM').format(reminder.dueDate)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            DayPill(daysLeft: reminder.daysLeft),
          ],
        ),
      ),
    );
  }
}

/// Design 01 grouped card: asset header (photo, name, soonest pill) with the
/// asset's expirations listed inside.
class _AssetGroupCard extends StatelessWidget {
  const _AssetGroupCard({required this.reminders, required this.asset});
  final List<Reminder> reminders;
  final Asset? asset;

  @override
  Widget build(BuildContext context) {
    final first = reminders.first;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            onTap: () => context.push(AppRoutes.asset(first.assetId)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  AssetThumb(
                    imageRef: first.assetImageUrl,
                    size: 46,
                    fallback: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(14)),
                      child: Icon(asset?.category.icon ?? Icons.category_outlined,
                          size: 22, color: AppColors.ink2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(first.assetName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink, height: 1.15)),
                        const SizedBox(height: 3),
                        Text(asset?.typeLabel ?? 'Asset',
                            style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  DayPill(daysLeft: first.daysLeft),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.line),
          for (final r in reminders)
            InkWell(
              onTap: () => context.push(AppRoutes.asset(r.assetId)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconBubble(kind: r.kind, size: 34),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('${r.label} · ${DateFormat('d MMM').format(r.dueDate)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.ink)),
                    ),
                    DayPill(daysLeft: r.daysLeft),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
