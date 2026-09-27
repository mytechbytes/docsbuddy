import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/feedback.dart';
import '../domain/reminder_filters.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../../routing/app_routes.dart';
import '../application/reminder_providers.dart';
import '../../../core/l10n/l10n.dart';
import 'reminder_names.dart';

/// Deep-link target of the dashboard stat cards' "View ›" — the reminder
/// subset a card counts (e.g. Expired → everything overdue).
class FilteredRemindersPage extends ConsumerWidget {
  const FilteredRemindersPage({super.key, required this.filter});
  final ReminderFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(filteredRemindersProvider(filter));
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: Text(filter.displayName(context), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: reminders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.failureText(e))),
        data: (filtered) {
          if (filtered.isEmpty) {
            return Center(child: Text(context.l10n.remindersEmpty, style: const TextStyle(color: AppColors.muted)));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            itemCount: filtered.length,
            itemBuilder: (context, i) => _Row(reminder: filtered[i]),
          );
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push(AppRoutes.asset(reminder.assetId)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            AssetThumb(
              imageRef: reminder.assetImageUrl,
              size: 44,
              fallback: IconBubble(kind: reminder.kind, size: 44),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reminder.assetName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                  const SizedBox(height: 3),
                  Text('${reminder.label} · ${context.formatDate(reminder.dueDate)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppColors.muted)),
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
