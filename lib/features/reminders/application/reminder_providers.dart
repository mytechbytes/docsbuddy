import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../domain/reminder_filters.dart';

/// A stat card's reminder subset.
final filteredRemindersProvider = FutureProvider.family<List<Reminder>, ReminderFilter>((ref, filter) async {
  return filterReminders(await ref.watch(upcomingRemindersProvider.future), filter);
});

/// The bell inbox: overdue services and those inside a notify window.
final notificationInboxProvider =
    FutureProvider<({List<Reminder> overdue, List<Reminder> comingUp})>((ref) async {
  final list = await ref.watch(upcomingRemindersProvider.future);
  return (overdue: list.where(isOverdue).toList(), comingUp: list.where(inAlertWindow).toList());
});

final hasOverdueProvider = Provider<bool>(
  (ref) => ref.watch(upcomingRemindersProvider).value?.any(isOverdue) ?? false,
);
