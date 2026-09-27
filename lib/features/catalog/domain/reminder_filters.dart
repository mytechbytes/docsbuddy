import '../data/catalog_models.dart';

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
