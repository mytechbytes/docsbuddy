import 'catalog_models.dart';

/// Pure: soonest first (overdue first). Returns a new list.
List<Reminder> sortedByUrgency(Iterable<Reminder> reminders) =>
    [...reminders]..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));

/// Pure: the most urgent reminder, or null.
Reminder? soonest(Iterable<Reminder> reminders) =>
    reminders.isEmpty ? null : sortedByUrgency(reminders).first;

/// Pure: an asset's reminders, most urgent first.
List<Reminder> remindersForAsset(String assetId, Iterable<Reminder> reminders) =>
    sortedByUrgency(reminders.where((r) => r.assetId == assetId));
