import 'catalog_models.dart';
import 'catalog_inputs.dart';

/// Pure: expands a category's `default_dates` into the services to create. Dues fall [DefaultReminder.startMonths] after
/// [purchaseDate] (else [now]); past dues roll forward by the recurrence until upcoming, and past one-offs are skipped.
/// [amcDate] overrides the AMC default's due date, and adds a yearly AMC when the category has none.
List<ReminderInput> expandDefaultReminders(
  AssetCategory? category, {
  DateTime? purchaseDate,
  DateTime? amcDate,
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final base = purchaseDate ?? today;
  final out = <ReminderInput>[];
  var sawAmc = false;

  for (final d in category?.defaults ?? const <DefaultReminder>[]) {
    var due = DateTime(base.year, base.month + d.startMonths, base.day);
    if (d.kind == ReminderKind.amc && amcDate != null) {
      due = amcDate;
      sawAmc = true;
    } else if (d.recurrence.stepMonths == 0) {
      if (!due.isAfter(today)) continue; // expired one-off (e.g. old warranty)
    } else {
      while (!due.isAfter(today)) {
        due = DateTime(due.year, due.month + d.recurrence.stepMonths, due.day);
      }
    }
    out.add(ReminderInput(kind: d.kind, label: d.label, dueDate: due, recurrence: d.recurrence));
  }

  if (amcDate != null && !sawAmc) {
    out.add(ReminderInput(
        kind: ReminderKind.amc, label: 'AMC', dueDate: amcDate, recurrence: Recurrence.yearly));
  }
  return out;
}
