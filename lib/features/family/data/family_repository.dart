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
  /// The caller's active family, or null if they aren't in one yet.
  Future<Family?> currentFamily();

  Future<List<FamilyMember>> members(String familyId);

  Future<Family> createFamily(String name);

  Future<FamilyInvite> createInvite({required String familyId, required FamilyRole role});

  /// Redeems an invite [code] and returns the joined family.
  Future<Family> acceptInvite(String code);

  Future<void> leaveFamily(String familyId);
}
