import '../domain/notification_prefs.dart';
import '../domain/notification_prefs_repository.dart';

/// In-memory prefs for local dev / tests / the offline build.
class FakeNotificationPrefsRepository implements NotificationPrefsRepository {
  NotificationPrefs _prefs = const NotificationPrefs();

  @override
  Future<NotificationPrefs> get() async => _prefs;

  @override
  Future<NotificationPrefs> update(NotificationPrefs prefs) async => _prefs = prefs;
}
