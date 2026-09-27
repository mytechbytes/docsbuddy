import '../../catalog/domain/catalog_models.dart';

/// The dashboard stat-card segments (and the filtered-list deep links).
enum ReminderFilter {
  active('Active Services'),
  secured('Secured'),
  soon('Expiring Soon'),
  expired('Expired');

  const ReminderFilter(this.title);
  final String title;

  static ReminderFilter fromName(String? name) =>
      ReminderFilter.values.asNameMap()[name] ?? ReminderFilter.active;
}

/// Pure: the subset of [reminders] a stat card counts/links to.
List<Reminder> filterReminders(List<Reminder> reminders, ReminderFilter filter) => switch (filter) {
      ReminderFilter.active => reminders,
      ReminderFilter.secured => reminders.where((r) => r.daysLeft > 30).toList(),
      ReminderFilter.soon => reminders.where((r) => r.daysLeft >= 0 && r.daysLeft <= 30).toList(),
      ReminderFilter.expired => reminders.where((r) => r.daysLeft < 0).toList(),
    };

/// Pure: reminders restricted to [kinds] (empty set = no kind filter).
List<Reminder> filterByKinds(List<Reminder> reminders, Set<ReminderKind> kinds) =>
    kinds.isEmpty ? reminders : reminders.where((r) => kinds.contains(r.kind)).toList();

/// Pure: buckets already-sorted reminders by asset, keeping groups ordered by
/// their soonest expiration.
List<List<Reminder>> groupByAsset(List<Reminder> sorted) {
  final byAsset = <String, List<Reminder>>{};
  for (final r in sorted) {
    byAsset.putIfAbsent(r.assetId, () => []).add(r);
  }
  return byAsset.values.toList();
}

/// True when [r] is inside one of its notify offsets (or due today) — what
/// the bell inbox and the local scheduler consider "coming up".
bool inAlertWindow(Reminder r) {
  final d = r.daysLeft;
  return d >= 0 && (d == 0 || r.notifyOffsets.any((o) => d <= o));
}

bool isOverdue(Reminder r) => r.daysLeft < 0;
