import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../features/catalog/data/catalog_models.dart';
import 'reminder_schedule.dart';

/// Schedules OS-level local notifications for upcoming reminders — the offline
/// "never miss a renewal" delivery. Independent of FCM.
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Reminders',
      channelDescription: 'Asset due-date reminders',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
    macOS: DarwinNotificationDetails(),
  );

  /// All plugin calls are guarded so the app degrades to a no-op on platforms
  /// without the plugin (e.g. widget tests) rather than throwing.
  Future<void> init() async {
    if (_ready) return;
    try {
      tzdata.initializeTimeZones();
      try {
        tz.setLocalLocation(tz.getLocation(await FlutterTimezone.getLocalTimezone()));
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }
      await _plugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
          macOS: DarwinInitializationSettings(),
        ),
      );
      _ready = true;
    } catch (_) {/* platform unavailable */}
  }

  /// Asks the user for notification permission (Android 13+, iOS, macOS).
  Future<bool> requestPermission() async {
    try {
      await init();
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final androidOk = await android?.requestNotificationsPermission();
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final iosOk = await ios?.requestPermissions(alert: true, badge: true, sound: true);
      return androidOk ?? iosOk ?? true;
    } catch (_) {
      return false;
    }
  }

  /// Cancels everything and re-arms the soonest reminders, honouring the
  /// user's quiet hours when provided.
  Future<void> rescheduleFor(List<Reminder> reminders, {String? quietStart, String? quietEnd}) async {
    try {
      await init();
      if (!_ready) return;
      await _plugin.cancelAll();
      for (final a in buildAlerts(reminders, quietStart: quietStart, quietEnd: quietEnd)) {
        await _plugin.zonedSchedule(
          a.id,
          a.title,
          a.body,
          tz.TZDateTime.from(a.when, tz.local),
          _details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          payload: a.payload,
        );
      }
    } catch (_) {/* no-op on failure */}
  }

  /// Fires an immediate test notification.
  Future<void> showTest() async {
    try {
      await init();
      await _plugin.show(0, 'DocsBuddy', 'Notifications are working ✅', _details);
    } catch (_) {/* no-op */}
  }
}

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService(FlutterLocalNotificationsPlugin()));
