import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/adaptive_layout.dart';
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
      padding: const EdgeInsetsDirectional.only(start: 4),
      icon: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(icon, color: context.palette.textSecondary, size: 23),
          if (dot)
            PositionedDirectional(
              end: 1,
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

/// 2×2 grid of coloured summary cards; each counts **services** (asset_dates rows) and deep-links to its filtered list,
/// plus a full-width total-appliances card. With large text two cards no longer fit side by side, so they stack.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.counts, required this.assetCount});
  final Map<ReminderFilter, int> counts;
  final int assetCount;

  /// Narrowest a card gets (at the default font size) before the grid goes
  /// from two columns to one.
  static const _minCardWidth = 120.0;
  static const _gap = 12.0;

  /// Two cards of equal height, so a label that wraps doesn't leave one shorter.
  Widget _pair(Widget a, Widget b) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(child: a), const SizedBox(width: _gap), Expanded(child: b)],
        ),
      );

  @override
  Widget build(BuildContext context) {
    int count(ReminderFilter f) => counts[f] ?? 0;
    final cards = [
      StatCard(
          value: '${count(ReminderFilter.active)}',
          label: context.l10n.filterActive,
          icon: Icons.description_outlined,
          bg: AppColors.navy,
          fg: Colors.white,
          filter: ReminderFilter.active),
      StatCard(
          value: '${count(ReminderFilter.secured)}',
          label: context.l10n.filterSecured,
          icon: Icons.shield_outlined,
          bg: AppColors.teal,
          fg: Colors.white,
          filter: ReminderFilter.secured),
      StatCard(
          value: '${count(ReminderFilter.soon)}',
          label: context.l10n.filterSoon,
          icon: Icons.hourglass_bottom,
          bg: AppColors.statSoonBg,
          fg: AppColors.ink,
          filter: ReminderFilter.soon),
      StatCard(
          value: '${count(ReminderFilter.expired)}',
          label: context.l10n.filterExpired,
          icon: Icons.error_outline,
          bg: AppColors.statExpiredBg,
          fg: AppColors.ink,
          filter: ReminderFilter.expired),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoUp = fitsAtScale(context, (constraints.maxWidth - _gap) / 2, _minCardWidth);
        final rows = twoUp ? [_pair(cards[0], cards[1]), _pair(cards[2], cards[3])] : cards;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final row in rows) ...[row, const SizedBox(height: _gap)],
            AppliancesCard(count: assetCount),
          ],
        );
      },
    );
  }
}

/// One coloured summary card. Fills the width it is given (a grid cell or the
/// whole column) and is at least [minHeight] tall; it grows with its text
/// rather than clipping it.
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

  static const minHeight = 118.0;

  @override
  Widget build(BuildContext context) {
    final sub = fg.withValues(alpha: 0.72);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push(AppRoutes.reminders(filter)),
      child: Container(
        constraints: const BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A big count shrinks to fit rather than overflowing the card.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(value, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: fg, height: 1.0)),
                  ),
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
          ],
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
    final icon = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: context.palette.accentSoft, borderRadius: BorderRadius.circular(12)),
      child: Icon(Icons.kitchen_outlined, color: context.palette.accent, size: 20),
    );
    final label = Text(context.l10n.dashboardTotalAppliances,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.palette.text));
    final total = Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: context.palette.text));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: context.palette.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: context.palette.border)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (fitsAtScale(context, constraints.maxWidth, 230)) {
            return Row(children: [icon, const SizedBox(width: 12), Expanded(child: label), total]);
          }
          // Icon and count on one line, the label full width beneath.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [icon, const Spacer(), total]),
              const SizedBox(height: 8),
              label,
            ],
          );
        },
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
        child: BadgedTile(
          leading: AssetThumb(
            imageRef: reminder.assetImageUrl,
            size: 46,
            fallback: IconBubble(kind: reminder.kind, size: 46),
          ),
          badge: DayPill(daysLeft: reminder.daysLeft),
          body: (wrap) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reminder.assetName,
                  maxLines: wrap ? null : 1,
                  overflow: wrap ? null : TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.palette.text, height: 1.15)),
              const SizedBox(height: 3),
              Text('${reminder.label} · ${context.formatShortDate(reminder.dueDate)}',
                  maxLines: wrap ? null : 1,
                  overflow: wrap ? null : TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: context.palette.textMuted)),
            ],
          ),
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
              child: BadgedTile(
                leading: AssetThumb(
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
                badge: DayPill(daysLeft: first.daysLeft),
                body: (wrap) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(first.assetName,
                        maxLines: wrap ? null : 1,
                        overflow: wrap ? null : TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800, color: context.palette.text, height: 1.15)),
                    const SizedBox(height: 3),
                    Text(asset?.typeName(context) ?? context.l10n.dashboardAsset,
                        style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1, color: context.palette.border),
          for (final r in reminders)
            InkWell(
              onTap: () => context.push(AppRoutes.asset(r.assetId)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: BadgedTile(
                  gap: 10,
                  badgeGap: 0,
                  leading: IconBubble(kind: r.kind, size: 34),
                  badge: DayPill(daysLeft: r.daysLeft),
                  body: (wrap) => Text('${r.label} · ${context.formatShortDate(r.dueDate)}',
                      maxLines: wrap ? null : 1,
                      overflow: wrap ? null : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: context.palette.text)),
                ),
              ),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
