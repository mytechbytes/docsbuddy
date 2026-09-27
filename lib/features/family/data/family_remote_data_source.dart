import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/file_storage.dart';

/// Raw family tables/RPCs. `create_family` / `create_invite` are SECURITY
/// DEFINER RPCs (0002_family_rpcs.sql) because the first owner insert would
/// otherwise be blocked by the membership RLS policy.
abstract interface class FamilyRemoteDataSource {
  String? get currentUserId;
  Future<Json?> firstFamily();

  /// Members with their profile fields joined (`users(...)`).
  Future<List<Json>> members(String familyId);
  Future<void> updateMember(String familyId, String userId, Json values);
  Future<void> deleteMember(String familyId, String userId);
  Future<Json> createFamily(String name);
  Future<Json> createInvite(String familyId, String role);
  Future<void> acceptInvite(String code);
}

class SupabaseFamilyRemoteDataSource implements FamilyRemoteDataSource {
  SupabaseFamilyRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  Future<Json?> firstFamily() async {
    final rows = await _client.from('families').select('id, name, owner_id').limit(1);
    return rows.isEmpty ? null : rows.first;
  }

  /// Co-member profile fields are readable thanks to the "family members
  /// read profiles" policy (0008).
  @override
  Future<List<Json>> members(String familyId) => _client
      .from('family_members')
      .select('user_id, role, users(display_name, phone, avatar_url)')
      .eq('family_id', familyId);

  @override
  Future<void> updateMember(String familyId, String userId, Json values) =>
      _client.from('family_members').update(values).eq('family_id', familyId).eq('user_id', userId);

  @override
  Future<void> deleteMember(String familyId, String userId) =>
      _client.from('family_members').delete().eq('family_id', familyId).eq('user_id', userId);

  @override
  Future<Json> createFamily(String name) async =>
      await _client.rpc('create_family', params: {'p_name': name}) as Json;

  @override
  Future<Json> createInvite(String familyId, String role) async =>
      await _client.rpc('create_invite', params: {'p_family_id': familyId, 'p_role': role}) as Json;

  @override
  Future<void> acceptInvite(String code) => _client.rpc('accept_invite', params: {'p_code': code});
}
