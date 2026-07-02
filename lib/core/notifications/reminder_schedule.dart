import '../../features/catalog/data/catalog_models.dart';

/// One OS-level local notification to fire for a reminder threshold.
class ScheduledAlert {
  const ScheduledAlert({
    required this.id,
    required this.when,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final DateTime when;
  final String title;
  final String body;
  final String payload;
}

/// Parses `HH:mm` (or `HH:mm:ss`) into minutes-since-midnight; null on junk.
int? _minutesOf(String? hhmm) {
  if (hhmm == null) return null;
  final parts = hhmm.split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null || h > 23 || m > 59) return null;
  return h * 60 + m;
}

/// Pure: pushes [when] out of the user's quiet window (`HH:mm` bounds).
/// A wrapping window (22:00–07:00) moves late-evening times to the next
/// morning; a same-day window moves them to its end. Outside the window,
/// [when] is returned unchanged.
DateTime applyQuietHours(DateTime when, {String? quietStart, String? quietEnd}) {
  final qs = _minutesOf(quietStart);
  final qe = _minutesOf(quietEnd);
  if (qs == null || qe == null || qs == qe) return when;

  final tod = when.hour * 60 + when.minute;
  final wraps = qs > qe;
  final inWindow = wraps ? (tod >= qs || tod < qe) : (tod >= qs && tod < qe);
  if (!inWindow) return when;

  final bumpDay = wraps && tod >= qs ? 1 : 0;
  return DateTime(when.year, when.month, when.day + bumpDay, qe ~/ 60, qe % 60);
}

/// Pure: turn reminders into the local notifications to schedule. Each
/// reminder fires at its own `notifyOffsets` thresholds (days before due,
/// plus the due day itself) at [hour] local time, shifted out of the quiet
/// window when one is set. Past thresholds are skipped; the soonest [cap]
/// are kept (iOS and Android cap pending local notifications around 64).
List<ScheduledAlert> buildAlerts(
  List<Reminder> reminders, {
  DateTime? now,
  int hour = 9,
  int cap = 60,
  String? quietStart,
  String? quietEnd,
}) {
  final base = now ?? DateTime.now();
  final out = <ScheduledAlert>[];

  for (final r in reminders) {
    for (final off in {...r.notifyOffsets, 0}) {
      final day = r.dueDate.subtract(Duration(days: off));
      final when =
          applyQuietHours(DateTime(day.year, day.month, day.day, hour), quietStart: quietStart, quietEnd: quietEnd);
      if (!when.isAfter(base)) continue;
      out.add(ScheduledAlert(
        id: stableAlertId(r.id, off),
        when: when,
        title: '${r.assetName} — ${r.label}',
        body: off == 0 ? 'Due today' : 'Due in $off day${off == 1 ? '' : 's'}',
        payload: 'asset/${r.assetId}',
      ));
    }
  }

  out.sort((a, b) => a.when.compareTo(b.when));
  return out.length > cap ? out.sublist(0, cap) : out;
}

/// Deterministic 31-bit id so re-scheduling replaces the same notification.
int stableAlertId(String reminderId, int offset) =>
    (reminderId.hashCode ^ (offset * 2654435761)) & 0x7fffffff;
