import '../../../core/notifications/local_alert.dart';
import '../../catalog/domain/catalog_models.dart';

/// Pure: turns reminders into the local notifications to schedule. Each reminder fires at its own `notifyOffsets`
/// thresholds (days before due, plus the due day) at [hour] local time, shifted out of the quiet window; past thresholds
/// are skipped and the soonest [cap] kept (iOS and Android cap pending notifications around 64).
/// [dueText] words the countdown ("Due in 7 days") for a given days-before (0 = the day itself); the caller supplies it
/// because the wording belongs to the user's language, which this pure function must not know about.
List<LocalAlert> buildReminderAlerts(
  List<Reminder> reminders, {
  required String Function(int daysBefore) dueText,
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
        body: dueText(off),
        payload: 'asset/${r.assetId}',
      ));
    }
  }

  out.sort((a, b) => a.when.compareTo(b.when));
  return out.length > cap ? out.sublist(0, cap) : out;
}
