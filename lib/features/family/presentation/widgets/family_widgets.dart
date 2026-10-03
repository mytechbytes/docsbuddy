import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/adaptive_layout.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../domain/family_models.dart';
import '../../../../core/l10n/l10n.dart';
import '../family_names.dart';
import '../../../../core/theme/app_theme.dart';

class FamilyEmptyState extends StatelessWidget {
  const FamilyEmptyState({super.key, required this.onCreate, required this.onJoin});
  final VoidCallback onCreate;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: context.palette.accentSoft, shape: BoxShape.circle),
              child: Icon(Icons.groups_outlined, size: 34, color: context.palette.accent),
            ),
            const SizedBox(height: 20),
            Text(context.l10n.familyEmptyTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: context.palette.text)),
            const SizedBox(height: 8),
            Text(
              context.l10n.familyEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: context.palette.textMuted),
            ),
            const SizedBox(height: 28),
            PrimaryButton(label: context.l10n.familyCreateTitle, onPressed: onCreate),
            const SizedBox(height: 10),
            GhostButton(label: context.l10n.familyJoinWithCode, onPressed: onJoin),
          ],
        ),
      ),
    );
  }
}

class FamilyOverview extends StatelessWidget {
  const FamilyOverview({super.key, 
    required this.view,
    required this.onInvite,
    required this.onLeave,
    required this.onChangeRole,
    required this.onRemove,
  });
  final FamilyView view;
  final VoidCallback onInvite;
  final VoidCallback onLeave;
  final ValueChanged<FamilyMember> onChangeRole;
  final ValueChanged<FamilyMember> onRemove;

  @override
  Widget build(BuildContext context) {
    final family = view.family!;
    final members = view.members;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.palette.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.home_outlined, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(family.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: context.palette.text)),
                    Text(context.l10n.memberCount(members.length), style: TextStyle(fontSize: 13, color: context.palette.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 4, bottom: 8),
          child: Text(context.l10n.familyMembers, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.textMuted, letterSpacing: context.tracking(1))),
        ),
        for (final m in members)
          MemberTile(
            member: m,
            canManage: view.canManage(m),
            onChangeRole: () => onChangeRole(m),
            onRemove: () => onRemove(m),
          ),
        const SizedBox(height: 22),
        PrimaryButton(label: context.l10n.familyInviteMember, onPressed: onInvite),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onLeave,
          child: Text(context.l10n.familyLeaveFamily, style: TextStyle(color: context.palette.danger, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class MemberTile extends StatelessWidget {
  const MemberTile({super.key, 
    required this.member,
    required this.canManage,
    required this.onChangeRole,
    required this.onRemove,
  });
  final FamilyMember member;
  final bool canManage;
  final VoidCallback onChangeRole;
  final VoidCallback onRemove;

  Future<void> _launch(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) context.showFailure(const UnavailableFailure('Could not open that app.', reason: FailureReason.appOpenFailed));
  }

  /// Narrowest the tile can be (at the default font size) and still keep the
  /// name, the contact buttons and the role on one line.
  static const _singleRowWidth = 280.0;

  Widget _avatar(BuildContext context) => AssetThumb(
        imageRef: member.avatarUrl,
        size: 40,
        radius: 20,
        fallback: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: context.palette.successSoft, shape: BoxShape.circle),
          child: Text(member.initial,
              textScaler: TextScaler.noScaling,
              style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.successStrong)),
        ),
      );

  /// Name over phone. One line each in the single row; free to wrap when
  /// stacked, because a name cut to "Anan…" is no use to the person reading it.
  Widget _info(BuildContext context, {required bool wrap}) {
    final phone = member.phone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(member.displayName,
            maxLines: wrap ? null : 1,
            overflow: wrap ? null : TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.palette.text)),
        if (phone != null) ...[
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: wrap ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: wrap ? 3 : 0),
                child: Icon(Icons.phone_outlined, size: 12, color: context.palette.textMuted),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(phone,
                    maxLines: wrap ? null : 1,
                    overflow: wrap ? null : TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  List<Widget> _contactButtons(BuildContext context) {
    final phone = member.phone;
    if (phone == null) return const [];
    return [
      IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: () => _launch(context, Uri.parse('tel:$phone')),
        icon: Icon(Icons.call_outlined, size: 18, color: context.palette.accent),
        tooltip: context.l10n.familyCall,
      ),
      IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: () => _launch(context, Uri.parse('https://wa.me/${member.whatsappNumber}')),
        icon: Icon(Icons.chat_outlined, size: 18, color: context.palette.successStrong),
        tooltip: context.l10n.familyWhatsapp,
      ),
    ];
  }

  Widget _roleChip(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: context.palette.background, borderRadius: BorderRadius.circular(999)),
        child: Text(member.role.displayName(context), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.palette.textSecondary)),
      );

  Widget _menu(BuildContext context) => PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.more_vert, size: 18, color: context.palette.textMuted),
        onSelected: (v) => v == 'role' ? onChangeRole() : onRemove(),
        itemBuilder: (_) => [
          PopupMenuItem(value: 'role', child: Text(context.l10n.familyChangeRole)),
          PopupMenuItem(value: 'remove', child: Text(context.l10n.familyRemoveFromFamily, style: TextStyle(color: context.palette.danger))),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.palette.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (fitsAtScale(context, constraints.maxWidth, _singleRowWidth)) {
            return Row(
              children: [
                _avatar(context),
                const SizedBox(width: 12),
                Expanded(child: _info(context, wrap: false)),
                ..._contactButtons(context),
                _roleChip(context),
                if (canManage) _menu(context),
              ],
            );
          }
          // Not enough room for everything on one line: the person on top, their
          // role and actions on a line of their own beneath the name.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _avatar(context),
                  const SizedBox(width: 12),
                  Expanded(child: _info(context, wrap: true)),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 52),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _roleChip(context),
                    ..._contactButtons(context),
                    if (canManage) _menu(context),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class InviteSheet extends StatelessWidget {
  const InviteSheet({super.key, required this.invite});
  final FamilyInvite invite;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // A bottom sheet is only part of the screen tall, so large text scrolls it.
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: context.palette.border, borderRadius: BorderRadius.circular(999))),
            const SizedBox(height: 18),
            Text(context.l10n.familyInviteTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.palette.text)),
            const SizedBox(height: 6),
            Text(context.l10n.familyInviteBody(invite.role.displayName(context)),
                textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: context.palette.textMuted)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: context.palette.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.palette.fieldBorder),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  invite.code,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 6, color: context.palette.text),
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: context.l10n.familyCopyCode,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: invite.code));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.familyCodeCopied), backgroundColor: AppColors.green),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FamilyErrorState extends StatelessWidget {
  const FamilyErrorState({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: context.palette.danger, size: 36),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: context.palette.textMuted)),
            const SizedBox(height: 16),
            TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
          ],
        ),
      ),
    );
  }
}
