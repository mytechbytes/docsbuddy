import 'catalog_models.dart';

/// Assets, locations and reminders. Backend-agnostic, mirroring the Postgres
/// schema so a Supabase implementation can slot in later.
abstract interface class CatalogRepository {
  Future<List<Reminder>> upcomingReminders({int withinDays = 365});
  Future<List<Asset>> assets();
  Future<Asset> asset(String id);
  Future<List<Reminder>> remindersFor(String assetId);
  Future<List<Location>> locations();

  Future<Asset> addAsset({
    required String name,
    required AssetCategoryKind category,
    String? locationName,
    String? brand,
    String? model,
  });

  Future<Reminder> addReminder({
    required String assetId,
    required ReminderKind kind,
    required String label,
    required DateTime dueDate,
    Recurrence recurrence,
  });

  Future<void> completeReminder(String reminderId);
}
