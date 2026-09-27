import '../data/catalog_models.dart';
import '../data/catalog_repository.dart';

/// A concrete service to create for a new asset (a resolved
/// [DefaultReminder]).
class SeededReminder {
  const SeededReminder({required this.kind, required this.label, required this.dueDate, required this.recurrence});
  final ReminderKind kind;
  final String label;
  final DateTime dueDate;
  final Recurrence recurrence;
}

/// Pure: expand a category's `default_dates` into the services to create.
/// Dues are [DefaultReminder.startMonths] after [purchaseDate] (falling back
/// to [now]); dues already in the past roll forward by the recurrence until
/// they're upcoming (a 2-year-old car still gets a *future* PUC date), and
/// one-off defaults whose date has passed are skipped.
/// [amcDate] overrides the AMC default's due date; when the category has no
/// AMC default but [amcDate] is set, a yearly AMC service is added.
List<SeededReminder> expandDefaultReminders(
  AssetCategory? category, {
  DateTime? purchaseDate,
  DateTime? amcDate,
  DateTime? now,
}) {
  final base = purchaseDate ?? now ?? DateTime.now();
  final today = now ?? DateTime.now();
  final out = <SeededReminder>[];
  var sawAmc = false;

  for (final d in category?.defaults ?? const <DefaultReminder>[]) {
    var due = DateTime(base.year, base.month + d.startMonths, base.day);
    if (d.kind == ReminderKind.amc && amcDate != null) {
      due = amcDate;
      sawAmc = true;
    } else {
      final stepMonths = switch (d.recurrence) {
        Recurrence.monthly => 1,
        Recurrence.quarterly => 3,
        Recurrence.halfYearly => 6,
        Recurrence.yearly => 12,
        Recurrence.none => 0,
      };
      if (stepMonths == 0) {
        if (!due.isAfter(today)) continue; // expired one-off (e.g. old warranty)
      } else {
        while (!due.isAfter(today)) {
          due = DateTime(due.year, due.month + stepMonths, due.day);
        }
      }
    }
    out.add(SeededReminder(kind: d.kind, label: d.label, dueDate: due, recurrence: d.recurrence));
  }

  if (amcDate != null && !sawAmc) {
    out.add(SeededReminder(kind: ReminderKind.amc, label: 'AMC', dueDate: amcDate, recurrence: Recurrence.yearly));
  }
  return out;
}

/// Creates the expanded services on the backend.
Future<void> seedDefaultReminders(
  CatalogRepository repo,
  Asset asset,
  AssetCategory? category, {
  DateTime? amcDate,
}) async {
  final seeds = expandDefaultReminders(category, purchaseDate: asset.purchaseDate, amcDate: amcDate);
  for (final s in seeds) {
    await repo.addReminder(
      assetId: asset.id,
      kind: s.kind,
      label: s.label,
      dueDate: s.dueDate,
      recurrence: s.recurrence,
    );
  }
}
