import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/reminders/application/reminder_notification_sync.dart';
import 'package:docsbuddy/features/reminders/application/reminder_providers.dart';
import 'package:docsbuddy/features/reminders/domain/reminder_filters.dart';
import 'package:docsbuddy/features/catalog/application/catalog_providers.dart';
import 'package:docsbuddy/features/settings/application/settings_providers.dart';
import 'package:docsbuddy/features/settings/domain/notification_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  late ProviderContainer container;
  late RecordingNotificationService notifications;

  setUp(() {
    notifications = RecordingNotificationService();
    container = makeContainer(
      overrides: testOverrides(catalog: FakeCatalogRepository(latency: Duration.zero), notifications: notifications),
    );
  });

  test('inbox splits overdue from coming-up; stat filters count services', () async {
    final inbox = await container.read(notificationInboxProvider.future);
    expect(inbox.overdue.single.label, 'AppleCare');
    expect(inbox.comingUp, isNotEmpty);
    expect(await container.read(filteredRemindersProvider(ReminderFilter.expired).future), hasLength(1));
  });

  test('notification sync schedules alerts and re-arms when quiet hours change', () async {
    container.listen(reminderNotificationSyncProvider, (_, _) {});
    await container.read(upcomingRemindersProvider.future);
    await container.read(notificationPrefsProvider.future);
    await pumpEventQueue();
    expect(notifications.scheduled, isNotEmpty);
    expect(notifications.scheduled.last, isNotEmpty);

    final runs = notifications.scheduled.length;
    await container
        .read(notificationPrefsProvider.notifier)
        .setQuietHours((hour: 6, minute: 0), (hour: 10, minute: 0));
    await pumpEventQueue();
    expect(notifications.scheduled.length, greaterThan(runs));
    // 09:00 alerts now fall inside 06:00–10:00 and move to 10:00.
    expect(notifications.scheduled.last.every((a) => a.when.hour == 10), isTrue);
  });

  test('default notify offsets follow the user’s preference', () async {
    expect(container.read(defaultNotifyOffsetsProvider), const NotificationPrefs().defaultOffsets);
    await container.read(notificationPrefsProvider.future);
    await container.read(notificationPrefsProvider.notifier).setDefaultOffsets({1, 60});
    expect(container.read(defaultNotifyOffsetsProvider), [60, 1]);
  });
}
