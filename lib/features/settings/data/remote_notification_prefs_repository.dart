import '../../../core/data/file_storage.dart';
import '../../../core/data/supabase/supabase_guard.dart';
import '../../../core/error/app_failure.dart';
import '../domain/notification_prefs.dart';
import '../domain/notification_prefs_repository.dart';
import 'notification_prefs_remote_data_source.dart';

/// Pure row → model conversion.
abstract final class NotificationPrefsMapper {
  /// Postgres `time` comes back as `HH:mm:ss` — keep `HH:mm` for the UI.
  static String hhmm(String? t, String fallback) => t == null ? fallback : (t.length >= 5 ? t.substring(0, 5) : t);

  static NotificationPrefs fromRow(Json r) => NotificationPrefs(
        channels: (r['channels'] as List?)?.cast<String>() ?? const ['push', 'local'],
        defaultOffsets: (r['default_offsets'] as List?)?.cast<int>() ?? const [30, 7, 1],
        quietStart: hhmm(r['quiet_start'] as String?, '22:00'),
        quietEnd: hhmm(r['quiet_end'] as String?, '07:00'),
      );
}

/// One `notification_prefs` row per user, upserted on save.
class RemoteNotificationPrefsRepository implements NotificationPrefsRepository {
  RemoteNotificationPrefsRepository(this._remote);

  final NotificationPrefsRemoteDataSource _remote;

  @override
  Future<NotificationPrefs> get() => guardBackend(() async {
        final row = await _remote.fetch();
        return row == null ? const NotificationPrefs() : NotificationPrefsMapper.fromRow(row);
      });

  @override
  Future<NotificationPrefs> update(NotificationPrefs prefs) => guardBackend(() async {
        final userId = _remote.currentUserId;
        if (userId == null) throw const AuthFailure('Not signed in.', reason: FailureReason.notSignedIn);
        final row = await _remote.upsert({
          'user_id': userId,
          'channels': prefs.channels,
          'default_offsets': prefs.defaultOffsets,
          'quiet_start': prefs.quietStart,
          'quiet_end': prefs.quietEnd,
        });
        return NotificationPrefsMapper.fromRow(row);
      });
}
