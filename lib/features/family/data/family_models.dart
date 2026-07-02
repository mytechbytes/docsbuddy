/// Roles within a family, ordered most → least privileged.
enum FamilyRole {
  owner,
  admin,
  member,
  viewer;

  String get label => switch (this) {
        FamilyRole.owner => 'Owner',
        FamilyRole.admin => 'Admin',
        FamilyRole.member => 'Member',
        FamilyRole.viewer => 'Viewer',
      };

  static FamilyRole fromName(String? name) =>
      FamilyRole.values.firstWhere((r) => r.name == name, orElse: () => FamilyRole.member);
}

class Family {
  const Family({required this.id, required this.name, required this.ownerId});

  final String id;
  final String name;
  final String ownerId;
}

class FamilyMember {
  const FamilyMember({
    required this.userId,
    required this.displayName,
    required this.role,
    this.phone,
    this.avatarUrl,
  });

  final String userId;
  final String displayName;
  final FamilyRole role;

  /// Contact number (E.164) — shown on the member tile.
  final String? phone;

  /// Profile photo reference (bucket path or URL).
  final String? avatarUrl;

  /// First-letter avatar fallback.
  String get initial => displayName.trim().isEmpty ? '?' : displayName.trim()[0].toUpperCase();
}

class FamilyInvite {
  const FamilyInvite({required this.code, required this.role, required this.expiresAt});

  final String code;
  final FamilyRole role;
  final DateTime expiresAt;
}
