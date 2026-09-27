import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/file_storage.dart';

/// Raw `public.users` access plus the auth-side facts the profile shows.
abstract interface class ProfileRemoteDataSource {
  String? get currentUserId;
  String? get authEmail;
  bool get emailConfirmed;
  Future<String?> firstFamilyId();
  Future<Json> fetch(String userId);
  Future<Json> update(String userId, Json values);
}

class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  SupabaseProfileRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const columns = 'id, display_name, email, avatar_url, phone, timezone';

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  String? get authEmail => _client.auth.currentUser?.email;

  @override
  bool get emailConfirmed => _client.auth.currentUser?.emailConfirmedAt != null;

  @override
  Future<String?> firstFamilyId() async {
    final rows = await _client.from('families').select('id').limit(1);
    return rows.isEmpty ? null : rows.first['id'] as String;
  }

  @override
  Future<Json> fetch(String userId) => _client.from('users').select(columns).eq('id', userId).single();

  @override
  Future<Json> update(String userId, Json values) =>
      _client.from('users').update(values).eq('id', userId).select(columns).single();
}
