/// One OS-level local notification to schedule. Feature-agnostic: features
/// translate their own records (e.g. reminders) into these.
class LocalAlert {
  const LocalAlert({
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
int? minutesOfDay(String? hhmm) {
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
  final qs = minutesOfDay(quietStart);
  final qe = minutesOfDay(quietEnd);
  if (qs == null || qe == null || qs == qe) return when;

  final tod = when.hour * 60 + when.minute;
  final wraps = qs > qe;
  final inWindow = wraps ? (tod >= qs || tod < qe) : (tod >= qs && tod < qe);
  if (!inWindow) return when;

  final bumpDay = wraps && tod >= qs ? 1 : 0;
  return DateTime(when.year, when.month, when.day + bumpDay, qe ~/ 60, qe % 60);
}

/// Deterministic 31-bit id so re-scheduling replaces the same notification.
int stableAlertId(String key, int variant) => (key.hashCode ^ (variant * 2654435761)) & 0x7fffffff;
