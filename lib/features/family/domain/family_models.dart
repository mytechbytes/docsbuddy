import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_models.freezed.dart';

/// Roles within a family, ordered most → least privileged.
enum FamilyRole {
  owner('Owner'),
  admin('Admin'),
  member('Member'),
  viewer('Viewer');

  const FamilyRole(this.label);
  final String label;

  bool get canManageMembers => this == owner || this == admin;

  /// Roles an admin can assign (the owner role is never assignable).
  static const assignable = [admin, member, viewer];

  static FamilyRole fromName(String? name) => FamilyRole.values.asNameMap()[name] ?? FamilyRole.member;
}

@freezed
abstract class Family with _$Family {
  const factory Family({required String id, required String name, required String ownerId}) = _Family;
}

@freezed
abstract class FamilyMember with _$FamilyMember {
  const FamilyMember._();

  const factory FamilyMember({
    required String userId,
    required String displayName,
    required FamilyRole role,

    /// Contact number (E.164) — shown on the member tile.
    String? phone,

    /// Profile photo reference (bucket path or URL).
    String? avatarUrl,
  }) = _FamilyMember;

  /// First-letter avatar fallback.
  String get initial => displayName.trim().isEmpty ? '?' : displayName.trim()[0].toUpperCase();

  /// Digits-only phone for `wa.me` links (E.164 without the +).
  String? get whatsappNumber => phone?.replaceAll(RegExp(r'[^0-9]'), '');
}

@freezed
abstract class FamilyInvite with _$FamilyInvite {
  const factory FamilyInvite({required String code, required FamilyRole role, required DateTime expiresAt}) =
      _FamilyInvite;
}

/// The caller's family as the Family screen sees it, with the permission
/// rules the UI needs.
@freezed
abstract class FamilyView with _$FamilyView {
  const FamilyView._();

  const factory FamilyView({
    Family? family,
    @Default(<FamilyMember>[]) List<FamilyMember> members,
    String? myUserId,
  }) = _FamilyView;

  bool get hasFamily => family != null;

  FamilyMember? get me => members.where((m) => m.userId == myUserId).firstOrNull;

  /// Admin+ can manage other, non-owner members.
  bool canManage(FamilyMember target) =>
      (me?.role.canManageMembers ?? false) && target.userId != myUserId && target.role != FamilyRole.owner;
}
