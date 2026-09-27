import '../../../core/notifications/local_alert.dart';
import 'catalog_models.dart';

/// Pure: turn reminders into the local notifications to schedule. Each
/// reminder fires at its own `notifyOffsets` thresholds (days before due,
/// plus the due day itself) at [hour] local time, shifted out of the quiet
/// window when one is set. Past thresholds are skipped; the soonest [cap]
/// are kept (iOS and Android cap pending local notifications around 64).
List<LocalAlert> buildReminderAlerts(
  List<Reminder> reminders, {
  DateTime? now,
  int hour = 9,
  int cap = 60,
  String? quietStart,
  String? quietEnd,
}) {
  final base = now ?? DateTime.now();
  final out = <LocalAlert>[];

  for (final r in reminders) {
    for (final off in {...r.notifyOffsets, 0}) {
      final day = r.dueDate.subtract(Duration(days: off));
      final when =
          applyQuietHours(DateTime(day.year, day.month, day.day, hour), quietStart: quietStart, quietEnd: quietEnd);
      if (!when.isAfter(base)) continue;
      out.add(LocalAlert(
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
