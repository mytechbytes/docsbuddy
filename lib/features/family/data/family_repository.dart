import 'family_models.dart';

/// Thrown on a recoverable family-operation error; [message] is user-safe.
class FamilyFailure implements Exception {
  const FamilyFailure(this.message);
  final String message;

  @override
  String toString() => 'FamilyFailure: $message';
}

/// Backend-agnostic family/sharing contract. Method shapes mirror the Postgres
/// schema + RPCs (`create_family`, `accept_invite`) so the Supabase
/// implementation is a thin pass-through.
abstract interface class FamilyRepository {
  /// The signed-in user's id — lets the UI decide which management actions
  /// to show (you can't manage yourself or the owner).
  String? get currentUserId;

  /// The caller's active family, or null if they aren't in one yet.
  Future<Family?> currentFamily();

  Future<List<FamilyMember>> members(String familyId);

  /// Changes a member's role. Backend RLS restricts this to admin+; the
  /// owner's role can't be changed.
  Future<void> updateMemberRole({
    required String familyId,
    required String userId,
    required FamilyRole role,
  });

  /// Removes a member from the family (admin+ only; not the owner).
  Future<void> removeMember({required String familyId, required String userId});

  Future<Family> createFamily(String name);

  Future<FamilyInvite> createInvite({required String familyId, required FamilyRole role});

  /// Redeems an invite [code] and returns the joined family.
  Future<Family> acceptInvite(String code);

  Future<void> leaveFamily(String familyId);
}
