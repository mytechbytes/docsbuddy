import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Per-user notification preferences — maps `public.notification_prefs`
/// (channels, default notify offsets, quiet hours).
@immutable
class NotificationPrefs {
  const NotificationPrefs({
    this.channels = const ['push', 'local'],
    this.defaultOffsets = const [30, 7, 1],
    this.quietStart = '22:00',
    this.quietEnd = '07:00',
  });

  /// Enabled delivery channels: `push` | `local` | `email`.
  final List<String> channels;

  /// Days-before-due used to pre-fill new reminders.
  final List<int> defaultOffsets;

  /// Quiet hours as `HH:mm` local time.
  final String quietStart;
  final String quietEnd;

  bool hasChannel(String c) => channels.contains(c);

  NotificationPrefs copyWith({
    List<String>? channels,
    List<int>? defaultOffsets,
    String? quietStart,
    String? quietEnd,
  }) =>
      NotificationPrefs(
        channels: channels ?? this.channels,
        defaultOffsets: defaultOffsets ?? this.defaultOffsets,
        quietStart: quietStart ?? this.quietStart,
        quietEnd: quietEnd ?? this.quietEnd,
      );
}

abstract interface class NotificationPrefsRepository {
  Future<NotificationPrefs> get();
  Future<NotificationPrefs> update(NotificationPrefs prefs);
}

/// In-memory prefs for local dev / tests / the offline build.
class FakeNotificationPrefsRepository implements NotificationPrefsRepository {
  NotificationPrefs _prefs = const NotificationPrefs();

  @override
  Future<NotificationPrefs> get() async => _prefs;

  @override
  Future<NotificationPrefs> update(NotificationPrefs prefs) async => _prefs = prefs;
}

/// Real prefs: one `notification_prefs` row per user, upserted on save.
class SupabaseNotificationPrefsRepository implements NotificationPrefsRepository {
  SupabaseNotificationPrefsRepository(this._client);

  final SupabaseClient _client;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Postgres `time` comes back as `HH:mm:ss` — keep `HH:mm` for the UI.
  static String _hhmm(String? t, String fallback) =>
      t == null ? fallback : (t.length >= 5 ? t.substring(0, 5) : t);

  NotificationPrefs _prefs(Map<String, dynamic> r) => NotificationPrefs(
        channels: (r['channels'] as List?)?.cast<String>() ?? const ['push', 'local'],
        defaultOffsets: (r['default_offsets'] as List?)?.cast<int>() ?? const [30, 7, 1],
        quietStart: _hhmm(r['quiet_start'] as String?, '22:00'),
        quietEnd: _hhmm(r['quiet_end'] as String?, '07:00'),
      );

  @override
  Future<NotificationPrefs> get() => _guard(() async {
        final rows = await _client.from('notification_prefs').select().limit(1);
        return rows.isEmpty ? const NotificationPrefs() : _prefs(rows.first);
      });

  @override
  Future<NotificationPrefs> update(NotificationPrefs prefs) => _guard(() async {
        final userId = _client.auth.currentUser?.id;
        if (userId == null) throw Exception('Not signed in.');
        final row = await _client
            .from('notification_prefs')
            .upsert({
              'user_id': userId,
              'channels': prefs.channels,
              'default_offsets': prefs.defaultOffsets,
              'quiet_start': prefs.quietStart,
              'quiet_end': prefs.quietEnd,
            })
            .select()
            .single();
        return _prefs(row);
      });
}
