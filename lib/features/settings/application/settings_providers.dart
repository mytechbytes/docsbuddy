import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/notifications/notification_service.dart';
import '../domain/notification_prefs.dart';
import '../domain/notification_prefs_repository.dart';

final notificationPrefsRepositoryProvider = Provider<NotificationPrefsRepository>(
  (ref) => throw UnimplementedError('notificationPrefsRepositoryProvider must be overridden'),
);

/// The user's notification preferences, with the edits Settings offers.
/// Each edit persists and emits the saved prefs; failures throw [AppFailure].
class NotificationPrefsController extends AsyncNotifier<NotificationPrefs> {
  NotificationPrefsRepository get _repo => ref.read(notificationPrefsRepositoryProvider);

  @override
  Future<NotificationPrefs> build() => ref.watch(notificationPrefsRepositoryProvider).get();

  NotificationPrefs get _current => state.value ?? const NotificationPrefs();

  Future<void> _save(NotificationPrefs next) async {
    state = AsyncData(await _repo.update(next));
  }

  Future<void> setChannel(NotificationChannel channel, bool enabled) =>
      _save(_current.withChannel(channel, enabled: enabled));

  Future<void> setDefaultOffsets(Set<int> offsets) {
    if (offsets.isEmpty) throw const ValidationFailure('Pick at least one reminder offset.', reason: FailureReason.offsetsRequired);
    return _save(_current.copyWith(defaultOffsets: offsets.toList()..sort((a, b) => b.compareTo(a))));
  }

  Future<void> setQuietHours(ClockTime start, ClockTime end) =>
      _save(_current.copyWith(quietStart: formatClockTime(start), quietEnd: formatClockTime(end)));
}

final notificationPrefsProvider =
    AsyncNotifierProvider<NotificationPrefsController, NotificationPrefs>(NotificationPrefsController.new);

/// Offsets new reminders start with (the user's default, else 30/7/1).
final defaultNotifyOffsetsProvider = Provider<List<int>>(
  (ref) => ref.watch(notificationPrefsProvider).value?.defaultOffsets ?? const NotificationPrefs().defaultOffsets,
);

/// Asks for permission and fires a test notification; false when blocked.
final sendTestNotificationProvider = Provider<Future<bool> Function()>((ref) {
  return () async {
    final service = ref.read(notificationServiceProvider);
    final granted = await service.requestPermission();
    await service.showTest();
    return granted;
  };
});
