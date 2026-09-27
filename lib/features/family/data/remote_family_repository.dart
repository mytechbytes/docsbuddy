import '../../../core/data/file_storage.dart';
import '../../../core/data/supabase/supabase_guard.dart';
import '../../../core/error/app_failure.dart';
import '../domain/family_models.dart';
import '../domain/family_repository.dart';
import 'family_remote_data_source.dart';

/// Pure row → model conversion.
abstract final class FamilyMapper {
  static Family family(Json r) =>
      Family(id: r['id'] as String, name: r['name'] as String, ownerId: r['owner_id'] as String);

  static FamilyMember member(Json r) {
    final user = (r['users'] as Map?)?.cast<String, dynamic>();
    return FamilyMember(
      userId: r['user_id'] as String,
      displayName: (user?['display_name'] as String?) ?? 'Member',
      role: FamilyRole.fromName(r['role'] as String?),
      phone: user?['phone'] as String?,
      avatarUrl: user?['avatar_url'] as String?,
    );
  }

  static FamilyInvite invite(Json r) => FamilyInvite(
        code: r['code'] as String,
        role: FamilyRole.fromName(r['role'] as String?),
        expiresAt: DateTime.parse(r['expires_at'] as String),
      );
}

class RemoteFamilyRepository implements FamilyRepository {
  RemoteFamilyRepository(this._remote);

  final FamilyRemoteDataSource _remote;

  @override
  String? get currentUserId => _remote.currentUserId;

  @override
  Future<Family?> currentFamily() => guardBackend(() async {
        final row = await _remote.firstFamily();
        return row == null ? null : FamilyMapper.family(row);
      });

  @override
  Future<List<FamilyMember>> members(String familyId) =>
      guardBackend(() async => (await _remote.members(familyId)).map(FamilyMapper.member).toList());

  @override
  Future<void> updateMemberRole({required String familyId, required String userId, required FamilyRole role}) =>
      guardBackend(() => _remote.updateMember(familyId, userId, {'role': role.name}));

  @override
  Future<void> removeMember({required String familyId, required String userId}) =>
      guardBackend(() => _remote.deleteMember(familyId, userId));

  @override
  Future<Family> createFamily(String name) =>
      guardBackend(() async => FamilyMapper.family(await _remote.createFamily(name)));

  @override
  Future<FamilyInvite> createInvite({required String familyId, required FamilyRole role}) =>
      guardBackend(() async => FamilyMapper.invite(await _remote.createInvite(familyId, role.name)));

  @override
  Future<Family> acceptInvite(String code) => guardBackend(() async {
        await _remote.acceptInvite(code);
        final row = await _remote.firstFamily();
        if (row == null) throw const ServerFailure('Could not load the joined family.', reason: FailureReason.joinedFamilyUnavailable);
        return FamilyMapper.family(row);
      });

  @override
  Future<void> leaveFamily(String familyId) => guardBackend(() async {
        final uid = _remote.currentUserId ?? (throw const AuthFailure('Not signed in.', reason: FailureReason.notSignedIn));
        await _remote.deleteMember(familyId, uid);
      });
}
