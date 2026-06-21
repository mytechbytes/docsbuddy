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

/// Pure: turn reminders into the local notifications to schedule. For each
/// reminder we fire at each [offsets] threshold (days before due) at [hour]
/// local time. Past thresholds are skipped; the soonest [cap] are kept (iOS and
/// Android cap pending local notifications around 64).
List<ScheduledAlert> buildAlerts(
  List<Reminder> reminders, {
  List<int> offsets = const [30, 7, 1, 0],
  DateTime? now,
  int hour = 9,
  int cap = 60,
}) {
  final base = now ?? DateTime.now();
  final out = <ScheduledAlert>[];

  for (final r in reminders) {
    for (final off in offsets) {
      final day = r.dueDate.subtract(Duration(days: off));
      final when = DateTime(day.year, day.month, day.day, hour);
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
