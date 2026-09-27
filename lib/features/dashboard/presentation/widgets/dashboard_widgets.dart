import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routing/app_routes.dart';
import '../../../catalog/domain/catalog_models.dart';
import '../../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../../reminders/domain/reminder_filters.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';

class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton(this.icon, {super.key, this.dot = false, this.onTap});
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
          Icon(icon, color: context.palette.textSecondary, size: 23),
          if (dot)
            Positioned(
              right: 1,
              top: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: context.palette.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.palette.background, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 2×2 grid of coloured summary cards — every tile counts **services**
/// (asset_dates rows) and deep-links to its filtered list — plus a
/// full-width total-appliances card.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.counts, required this.assetCount});
  final Map<ReminderFilter, int> counts;
  final int assetCount;

  @override
  Widget build(BuildContext context) {
    int count(ReminderFilter f) => counts[f] ?? 0;
    return Column(
      children: [
        Row(
          children: [
            StatCard(
                value: '${count(ReminderFilter.active)}',
                label: context.l10n.filterActive,
                icon: Icons.description_outlined,
                bg: AppColors.navy,
                fg: Colors.white,
                filter: ReminderFilter.active),
            const SizedBox(width: 12),
            StatCard(
                value: '${count(ReminderFilter.secured)}',
                label: context.l10n.filterSecured,
                icon: Icons.shield_outlined,
                bg: AppColors.teal,
                fg: Colors.white,
                filter: ReminderFilter.secured),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            StatCard(
                value: '${count(ReminderFilter.soon)}',
                label: context.l10n.filterSoon,
                icon: Icons.hourglass_bottom,
                bg: AppColors.statSoonBg,
                fg: AppColors.ink,
                filter: ReminderFilter.soon),
            const SizedBox(width: 12),
            StatCard(
                value: '${count(ReminderFilter.expired)}',
                label: context.l10n.filterExpired,
                icon: Icons.error_outline,
                bg: AppColors.statExpiredBg,
                fg: AppColors.ink,
                filter: ReminderFilter.expired),
          ],
        ),
        const SizedBox(height: 12),
        AppliancesCard(count: assetCount),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard(
      {super.key, required this.value,
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
                  Text(context.l10n.commonView, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sub)),
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
class AppliancesCard extends StatelessWidget {
  const AppliancesCard({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: context.palette.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: context.palette.border)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: context.palette.accentSoft, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.kitchen_outlined, color: context.palette.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(context.l10n.dashboardTotalAppliances,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.palette.text)),
          ),
          Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: context.palette.text)),
        ],
      ),
    );
  }
}

class UpcomingReminderTile extends StatelessWidget {
  const UpcomingReminderTile({super.key, required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push(AppRoutes.asset(reminder.assetId)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: context.palette.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.palette.border)),
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
                  Text(reminder.assetName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.palette.text, height: 1.15)),
                  const SizedBox(height: 3),
                  Text('${reminder.label} · ${context.formatShortDate(reminder.dueDate)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: context.palette.textMuted)),
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
class AssetGroupCard extends StatelessWidget {
  const AssetGroupCard({super.key, required this.reminders, required this.asset});
  final List<Reminder> reminders;
  final Asset? asset;

  @override
  Widget build(BuildContext context) {
    final first = reminders.first;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: context.palette.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.palette.border)),
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
                      decoration: BoxDecoration(color: context.palette.background, borderRadius: BorderRadius.circular(14)),
                      child: Icon(asset?.category.icon ?? Icons.category_outlined,
                          size: 22, color: context.palette.textSecondary),
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
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800, color: context.palette.text, height: 1.15)),
                        const SizedBox(height: 3),
                        Text(asset?.typeName(context) ?? context.l10n.dashboardAsset,
                            style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  DayPill(daysLeft: first.daysLeft),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: context.palette.border),
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
                      child: Text('${r.label} · ${context.formatShortDate(r.dueDate)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: context.palette.text)),
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
