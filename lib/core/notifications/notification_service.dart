import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../logging/app_logger.dart';
import 'local_alert.dart';

/// Schedules OS-level [LocalAlert]s. Feature-agnostic and independent of FCM.
/// Implementations never throw — notifications are best-effort.
abstract interface class NotificationService {
  /// Asks for permission (Android 13+, iOS, macOS); false when denied.
  Future<bool> requestPermission();

  /// Cancels everything pending and schedules [alerts].
  Future<void> replaceAll(List<LocalAlert> alerts);

  /// Fires an immediate test notification.
  Future<void> showTest();
}

/// `flutter_local_notifications` implementation.
class LocalNotificationService implements NotificationService {
  LocalNotificationService(this._plugin, {required this._logger});

  final FlutterLocalNotificationsPlugin _plugin;
  final AppLogger _logger;
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
      } catch (e) {
        _logger.warning('Device timezone unavailable; scheduling in UTC', error: e);
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
    } catch (e, st) {
      _logger.warning('Local notifications unavailable', error: e, stackTrace: st);
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      await init();
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final androidOk = await android?.requestNotificationsPermission();
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final iosOk = await ios?.requestPermissions(alert: true, badge: true, sound: true);
      return androidOk ?? iosOk ?? true;
    } catch (e, st) {
      _logger.warning('Notification permission request failed', error: e, stackTrace: st);
      return false;
    }
  }

  @override
  Future<void> replaceAll(List<LocalAlert> alerts) async {
    try {
      await init();
      if (!_ready) return;
      await _plugin.cancelAll();
      for (final a in alerts) {
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
    } catch (e, st) {
      _logger.warning('Scheduling reminders failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> showTest() async {
    try {
      await init();
      await _plugin.show(0, 'DocsBuddy', 'Notifications are working ✅', _details);
    } catch (e, st) {
      _logger.warning('Test notification failed', error: e, stackTrace: st);
    }
  }
}

/// Bound at the composition root (`bootstrap/dependencies.dart`).
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('notificationServiceProvider must be overridden'),
);
