import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';

/// The bell's inbox: what needs attention now (overdue) and what's inside a
/// notify window (a reminder whose days-left has crossed one of its own
/// offsets). Derived client-side from the reminder set — mirrors what the
/// local scheduler fires.
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  /// True when [r] is inside one of its notify offsets (or due today).
  static bool inAlertWindow(Reminder r) =>
      r.daysLeft >= 0 && (r.daysLeft == 0 || r.notifyOffsets.any((o) => r.daysLeft <= o));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(upcomingRemindersProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: reminders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          final overdue = list.where((r) => r.daysLeft < 0).toList();
          final alerts = list.where(inAlertWindow).toList();
          if (overdue.isEmpty && alerts.isEmpty) {
            return const Center(
                child: Text("You're all caught up 🎉", style: TextStyle(color: AppColors.muted)));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              if (overdue.isNotEmpty) ...[
                const _SectionLabel('Overdue'),
                for (final r in overdue) _AlertRow(reminder: r),
              ],
              if (alerts.isNotEmpty) ...[
                const _SectionLabel('Coming up'),
                for (final r in alerts) _AlertRow(reminder: r),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Text(text.toUpperCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
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
        ? 'Overdue by ${-d} day${d == -1 ? '' : 's'}'
        : d == 0
            ? 'Due today'
            : 'Due in $d day${d == 1 ? '' : 's'} — ${DateFormat('d MMM').format(reminder.dueDate)}';
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push('/asset/${reminder.assetId}'),
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
