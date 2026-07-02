import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../../../core/widgets/db_logo.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/data/catalog_models.dart';

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Re-arm local notifications whenever the reminder set changes.
    ref.listen(upcomingRemindersProvider, (_, next) {
      next.whenData((list) => ref.read(notificationServiceProvider).rescheduleFor(list));
    });
    final reminders = ref.watch(upcomingRemindersProvider);
    final assetCount = ref.watch(assetsProvider).valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        titleSpacing: 20,
        title: const Align(alignment: Alignment.centerLeft, child: DbLogo(size: 20)),
        actions: const [
          _BarIcon(Icons.search),
          _BarIcon(Icons.notifications_none, dot: true),
          _Avatar(),
          SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/appliance-picker'),
        backgroundColor: AppColors.chipBlue,
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(upcomingRemindersProvider);
          ref.invalidate(assetsProvider);
        },
        child: reminders.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
            children: [
              _StatGrid(reminders: list, assetCount: assetCount),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(
                    child: Text('Upcoming Expirations',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink)),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Icon(Icons.tune, size: 17, color: AppColors.ink2),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('No reminders yet. Add an asset to get started.', style: TextStyle(color: AppColors.muted))),
                )
              else
                for (final r in list) _ReminderTile(reminder: r),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarIcon extends StatelessWidget {
  const _BarIcon(this.icon, {this.dot = false});
  final IconData icon;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Stack(
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

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Color(0xFFF1C27D), Color(0xFFD68B5C)]),
        ),
        child: const Icon(Icons.person, color: Colors.white, size: 18),
      ),
    );
  }
}

/// 2×2 grid of coloured summary cards — every tile counts **services**
/// (asset_dates rows) — plus a full-width total-appliances card.
class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.reminders, required this.assetCount});
  final List<Reminder> reminders;
  final int assetCount;

  @override
  Widget build(BuildContext context) {
    final active = reminders.length;
    final secured = reminders.where((r) => r.daysLeft > 30).length;
    final soon = reminders.where((r) => r.daysLeft >= 0 && r.daysLeft <= 30).length;
    final expired = reminders.where((r) => r.daysLeft < 0).length;
    return Column(
      children: [
        Row(
          children: [
            _StatCard(value: '$active', label: 'Active Services', icon: Icons.description_outlined, bg: AppColors.navy, fg: Colors.white),
            const SizedBox(width: 12),
            _StatCard(value: '$secured', label: 'Secured', icon: Icons.shield_outlined, bg: AppColors.teal, fg: Colors.white),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _StatCard(value: '$soon', label: 'Expiring Soon', icon: Icons.hourglass_bottom, bg: const Color(0xFFC9D6E0), fg: AppColors.ink),
            const SizedBox(width: 12),
            _StatCard(value: '$expired', label: 'Expired', icon: Icons.error_outline, bg: const Color(0xFFE89098), fg: AppColors.ink),
          ],
        ),
        const SizedBox(height: 12),
        _AppliancesCard(count: assetCount),
      ],
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.icon, required this.bg, required this.fg});
  final String value;
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final sub = fg.withValues(alpha: 0.72);
    return Expanded(
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
                Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: sub, height: 1.1))),
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
      onTap: () => context.push('/asset/${reminder.assetId}'),
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
