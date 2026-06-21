import 'package:supabase_flutter/supabase_flutter.dart';

import 'family_models.dart';
import 'family_repository.dart';

/// Real backend implementation. `create_family` / `create_invite` are
/// SECURITY DEFINER RPCs (see supabase/migrations/0002_family_rpcs.sql) because
/// the first owner insert would otherwise be blocked by the membership RLS
/// policy; `accept_invite` already exists in 0001.
class SupabaseFamilyRepository implements FamilyRepository {
  SupabaseFamilyRepository(this._client);

  final SupabaseClient _client;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on PostgrestException catch (e) {
      throw FamilyFailure(e.message);
    } on AuthException catch (e) {
      throw FamilyFailure(e.message);
    } catch (e) {
      final s = e.toString();
      if (s.contains('SocketException') || s.contains('Failed host lookup') || s.contains('ClientException') || s.contains('Connection')) {
        throw const FamilyFailure('Can’t reach the server. Check your internet connection.');
      }
      throw const FamilyFailure('Something went wrong. Please try again.');
    }
  }

  Family _family(Map<String, dynamic> row) =>
      Family(id: row['id'] as String, name: row['name'] as String, ownerId: row['owner_id'] as String);

  @override
  Future<Family?> currentFamily() => _guard(() async {
        final rows = await _client.from('families').select('id, name, owner_id').limit(1);
        if (rows.isEmpty) return null;
        return _family(rows.first);
      });

  @override
  Future<List<FamilyMember>> members(String familyId) => _guard(() async {
        final rows = await _client
            .from('family_members')
            .select('user_id, role, users(display_name)')
            .eq('family_id', familyId);
        return rows.map((r) {
          final user = r['users'] as Map<String, dynamic>?;
          return FamilyMember(
            userId: r['user_id'] as String,
            displayName: (user?['display_name'] as String?) ?? 'Member',
            role: FamilyRole.fromName(r['role'] as String?),
          );
        }).toList();
      });

  @override
  Future<Family> createFamily(String name) => _guard(() async {
        final row = await _client.rpc('create_family', params: {'p_name': name}) as Map<String, dynamic>;
        return _family(row);
      });

  @override
  Future<FamilyInvite> createInvite({required String familyId, required FamilyRole role}) => _guard(() async {
        final row = await _client.rpc('create_invite', params: {
          'p_family_id': familyId,
          'p_role': role.name,
        }) as Map<String, dynamic>;
        return FamilyInvite(
          code: row['code'] as String,
          role: FamilyRole.fromName(row['role'] as String?),
          expiresAt: DateTime.parse(row['expires_at'] as String),
        );
      });

  @override
  Future<Family> acceptInvite(String code) => _guard(() async {
        await _client.rpc('accept_invite', params: {'p_code': code});
        final family = await currentFamily();
        if (family == null) throw const FamilyFailure('Could not load the joined family.');
        return family;
      });

  @override
  Future<void> leaveFamily(String familyId) => _guard(() async {
        final uid = _client.auth.currentUser?.id;
        await _client.from('family_members').delete().eq('family_id', familyId).eq('user_id', uid!);
      });
}
