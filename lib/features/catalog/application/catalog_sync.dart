import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/push/push_messaging_service.dart';
import '../../settings/application/settings_providers.dart';
import '../domain/reminder_alerts.dart';
import 'catalog_providers.dart';

/// Keeps OS-level local notifications in step with the reminder set and the
/// user's quiet hours. Watch it from the signed-in shell to activate.
final reminderNotificationSyncProvider = Provider<void>((ref) {
  void reschedule() {
    final reminders = ref.read(upcomingRemindersProvider).value;
    if (reminders == null) return;
    final prefs = ref.read(notificationPrefsProvider).value;
    final alerts = buildReminderAlerts(
      reminders,
      now: ref.read(clockProvider)(),
      quietStart: prefs?.quietStart,
      quietEnd: prefs?.quietEnd,
    );
    ref.read(notificationServiceProvider).replaceAll(alerts);
  }

  ref.listen(upcomingRemindersProvider, (_, _) => reschedule(), fireImmediately: true);
  ref.listen(notificationPrefsProvider, (_, _) => reschedule());
});

/// Refreshes catalog reads when a silent push says another family member
/// changed something. Watch it from the signed-in shell to activate.
final remoteChangeSyncProvider = Provider<void>((ref) {
  final sub = ref.watch(pushMessagingServiceProvider).remoteChanges.listen((_) {
    ref.read(catalogRefresherProvider).all();
  });
  ref.onDispose(sub.cancel);
});
