import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_prefs.freezed.dart';

/// Delivery channels a user can enable (`notification_prefs.channels`).
/// WhatsApp delivery is the `send-reminders-whatsapp` Edge Function.
enum NotificationChannel { push, local, email, whatsapp }

/// Days-before-due offsets the pickers offer.
const notifyOffsetOptions = [60, 30, 14, 7, 3, 1];

/// Per-user notification preferences — maps `public.notification_prefs`.
@freezed
abstract class NotificationPrefs with _$NotificationPrefs {
  const NotificationPrefs._();

  const factory NotificationPrefs({
    @Default(<String>['push', 'local']) List<String> channels,

    /// Days-before-due used to pre-fill new reminders, largest first.
    @Default(<int>[30, 7, 1]) List<int> defaultOffsets,

    /// Quiet hours as `HH:mm` local time.
    @Default('22:00') String quietStart,
    @Default('07:00') String quietEnd,
  }) = _NotificationPrefs;

  bool has(NotificationChannel c) => channels.contains(c.name);

  NotificationPrefs withChannel(NotificationChannel c, {required bool enabled}) {
    final next = {...channels};
    enabled ? next.add(c.name) : next.remove(c.name);
    return copyWith(channels: next.toList());
  }
}

/// A wall-clock time without a date (quiet-hours bounds).
typedef ClockTime = ({int hour, int minute});

/// `HH:mm` → [ClockTime]; [fallback] when unparsable.
ClockTime parseClockTime(String hhmm, ClockTime fallback) {
  final parts = hhmm.split(':');
  final h = int.tryParse(parts[0]);
  final m = parts.length > 1 ? int.tryParse(parts[1]) : null;
  return h == null || m == null ? fallback : (hour: h, minute: m);
}

String formatClockTime(ClockTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
