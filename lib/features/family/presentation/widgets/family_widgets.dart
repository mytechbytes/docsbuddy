import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../domain/family_models.dart';
import '../../../../core/l10n/l10n.dart';
import '../family_names.dart';

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
              decoration: const BoxDecoration(color: AppColors.blueSoft, shape: BoxShape.circle),
              child: const Icon(Icons.groups_outlined, size: 34, color: AppColors.chipBlue),
            ),
            const SizedBox(height: 20),
            Text(context.l10n.familyEmptyTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 8),
            Text(
              context.l10n.familyEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.muted),
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
            color: AppColors.paper,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
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
                    Text(family.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink)),
                    Text(context.l10n.memberCount(members.length), style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(context.l10n.familyMembers, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
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
          child: Text(context.l10n.familyLeaveFamily, style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w700)),
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

  @override
  Widget build(BuildContext context) {
    final phone = member.phone;
    final waDigits = member.whatsappNumber;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          AssetThumb(
            imageRef: member.avatarUrl,
            size: 40,
            radius: 20,
            fallback: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColors.greenSoft, shape: BoxShape.circle),
              child: Text(member.initial, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.greenLeaf)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)),
                if (phone != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 12, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text(phone, style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (phone != null) ...[
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => _launch(context, Uri.parse('tel:$phone')),
              icon: const Icon(Icons.call_outlined, size: 18, color: AppColors.chipBlue),
              tooltip: context.l10n.familyCall,
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => _launch(context, Uri.parse('https://wa.me/$waDigits')),
              icon: const Icon(Icons.chat_outlined, size: 18, color: AppColors.greenLeaf),
              tooltip: context.l10n.familyWhatsapp,
            ),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(999)),
            child: Text(member.role.displayName(context), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink2)),
          ),
          if (canManage)
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, size: 18, color: AppColors.muted),
              onSelected: (v) => v == 'role' ? onChangeRole() : onRemove(),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'role', child: Text(context.l10n.familyChangeRole)),
                PopupMenuItem(value: 'remove', child: Text(context.l10n.familyRemoveFromFamily, style: const TextStyle(color: AppColors.red))),
              ],
            ),
        ],
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(999))),
            const SizedBox(height: 18),
            Text(context.l10n.familyInviteTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 6),
            Text(context.l10n.familyInviteBody(invite.role.displayName(context)),
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  invite.code,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 6, color: AppColors.ink),
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
            const Icon(Icons.error_outline, color: AppColors.red, size: 36),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
            const SizedBox(height: 16),
            TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
          ],
        ),
      ),
    );
  }
}
