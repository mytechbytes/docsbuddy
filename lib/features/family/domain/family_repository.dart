import 'family_models.dart';

/// Backend-agnostic family/sharing contract. Every method throws an
/// `AppFailure` on error.
abstract interface class FamilyRepository {
  /// The signed-in user's id — decides which management actions to show.
  String? get currentUserId;

  /// The caller's active family, or null if they aren't in one yet.
  Future<Family?> currentFamily();

  Future<List<FamilyMember>> members(String familyId);

  /// Changes a member's role (admin+ only; the owner's role can't change).
  Future<void> updateMemberRole({required String familyId, required String userId, required FamilyRole role});

  /// Removes a member from the family (admin+ only; not the owner).
  Future<void> removeMember({required String familyId, required String userId});

  Future<Family> createFamily(String name);

  Future<FamilyInvite> createInvite({required String familyId, required FamilyRole role});

  /// Redeems an invite [code] and returns the joined family.
  Future<Family> acceptInvite(String code);

  Future<void> leaveFamily(String familyId);
}
