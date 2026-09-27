import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/feedback.dart';
import '../application/reminder_providers.dart';
import '../../../core/widgets/settings_list.dart';
import 'package:go_router/go_router.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';

/// The bell's inbox: what needs attention now (overdue) and what's inside a
/// notify window (a reminder whose days-left has crossed one of its own
/// offsets). Derived client-side from the reminder set — mirrors what the
/// local scheduler fires.
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inbox = ref.watch(notificationInboxProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: Text(context.l10n.commonNotifications, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: inbox.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.failureText(e))),
        data: (box) {
          final overdue = box.overdue;
          final alerts = box.comingUp;
          if (overdue.isEmpty && alerts.isEmpty) {
            return Center(
                child: Text(context.l10n.inboxAllCaughtUp, style: const TextStyle(color: AppColors.muted)));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              if (overdue.isNotEmpty) ...[
                SectionLabel(context.l10n.inboxOverdue),
                for (final r in overdue) _AlertRow(reminder: r),
              ],
              if (alerts.isNotEmpty) ...[
                SectionLabel(context.l10n.inboxComingUp),
                for (final r in alerts) _AlertRow(reminder: r),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final d = reminder.daysLeft;
    final phrase = d < 0
        ? context.l10n.dueOverdueBy(-d)
        : d == 0
            ? context.l10n.dueToday
            : context.l10n.inboxDueIn(d, context.formatShortDate(reminder.dueDate));
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push(AppRoutes.asset(reminder.assetId)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppColors.paper, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            IconBubble(kind: reminder.kind, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${reminder.assetName} — ${reminder.label}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  Text(phrase,
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: d <= 0 ? FontWeight.w700 : FontWeight.w400,
                          color: d < 0 ? AppColors.red : AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
