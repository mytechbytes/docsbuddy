import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/file_storage.dart';

/// Raw `notification_prefs` access — one row per user.
abstract interface class NotificationPrefsRemoteDataSource {
  String? get currentUserId;
  Future<Json?> fetch();
  Future<Json> upsert(Json values);
}

class SupabaseNotificationPrefsRemoteDataSource implements NotificationPrefsRemoteDataSource {
  SupabaseNotificationPrefsRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  Future<Json?> fetch() async {
    final rows = await _client.from('notification_prefs').select().limit(1);
    return rows.isEmpty ? null : rows.first;
  }

  @override
  Future<Json> upsert(Json values) => _client.from('notification_prefs').upsert(values).select().single();
}
