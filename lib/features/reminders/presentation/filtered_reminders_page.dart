import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/adaptive_layout.dart';
import '../../../core/widgets/feedback.dart';
import '../domain/reminder_filters.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../../routing/app_routes.dart';
import '../application/reminder_providers.dart';
import '../../../core/l10n/l10n.dart';
import 'reminder_names.dart';
import '../../../core/theme/app_theme.dart';

/// Deep-link target of the dashboard stat cards' "View ›" — the reminder
/// subset a card counts (e.g. Expired → everything overdue).
class FilteredRemindersPage extends ConsumerWidget {
  const FilteredRemindersPage({super.key, required this.filter});
  final ReminderFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(filteredRemindersProvider(filter));
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.palette.text),
        title: Text(filter.displayName(context), style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
      ),
      body: reminders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.failureText(e))),
        data: (filtered) {
          if (filtered.isEmpty) {
            return Center(child: Text(context.l10n.remindersEmpty, style: TextStyle(color: context.palette.textMuted)));
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
            color: context.palette.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.palette.border)),
        child: BadgedTile(
          leading: AssetThumb(
            imageRef: reminder.assetImageUrl,
            size: 44,
            fallback: IconBubble(kind: reminder.kind, size: 44),
          ),
          badge: DayPill(daysLeft: reminder.daysLeft),
          body: (wrap) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reminder.assetName,
                  maxLines: wrap ? null : 1,
                  overflow: wrap ? null : TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.palette.text)),
              const SizedBox(height: 3),
              Text('${reminder.label} · ${context.formatDate(reminder.dueDate)}',
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
