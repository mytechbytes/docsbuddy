import 'package:flutter/widgets.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/family_models.dart';

extension FamilyRoleName on FamilyRole {
  String displayName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      FamilyRole.owner => l.roleOwner,
      FamilyRole.admin => l.roleAdmin,
      FamilyRole.member => l.roleMember,
      FamilyRole.viewer => l.roleViewer,
    };
  }

  /// What the role may do (role picker subtitle).
  String description(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      FamilyRole.admin => l.familyRoleAdminHint,
      FamilyRole.viewer => l.familyRoleViewerHint,
      _ => l.familyRoleMemberHint,
    };
  }
}
