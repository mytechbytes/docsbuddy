import 'notification_prefs.dart';

/// Every method throws an `AppFailure` on error.
abstract interface class NotificationPrefsRepository {
  Future<NotificationPrefs> get();
  Future<NotificationPrefs> update(NotificationPrefs prefs);
}
