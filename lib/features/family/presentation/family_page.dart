import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/feedback.dart';
import '../application/family_controller.dart';
import '../domain/family_models.dart';
import 'widgets/family_widgets.dart';
import '../../../core/l10n/l10n.dart';
import 'family_names.dart';
import '../../../core/theme/app_theme.dart';

class FamilyPage extends ConsumerWidget {
  const FamilyPage({super.key});

  FamilyController _family(WidgetRef ref) => ref.read(familyControllerProvider.notifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyControllerProvider);

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        title: Text(context.l10n.commonFamily, style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
        iconTheme: IconThemeData(color: context.palette.text),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(familyControllerProvider.notifier).refresh(),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => FamilyErrorState(message: context.failureText(e), onRetry: () => _family(ref).refresh()),
          data: (view) => !view.hasFamily
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    FamilyEmptyState(
                      onCreate: () => _createDialog(context, ref),
                      onJoin: () => _joinDialog(context, ref),
                    ),
                  ],
                )
              : FamilyOverview(
                  view: view,
                  onInvite: () => _inviteSheet(context, ref),
                  onLeave: () => _leave(context, ref),
                  onChangeRole: (m) => _changeRole(context, ref, m),
                  onRemove: (m) => _removeMember(context, ref, m),
                ),
        ),
      ),
    );
  }

  Future<void> _createDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.familyCreateTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: context.l10n.familyNameHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: Text(context.l10n.commonCreate)),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty || !context.mounted) return;
    await runAction(context, () => _family(ref).createFamily(name));
  }

  Future<void> _joinDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.familyJoinTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(hintText: context.l10n.familyInviteCodeHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: Text(context.l10n.familyJoin)),
        ],
      ),
    );
    if (code == null || code.trim().isEmpty || !context.mounted) return;
    await runAction(
      context,
      () => _family(ref).acceptInvite(code),
      success: context.l10n.familyJoined,
    );
  }

  Future<void> _inviteSheet(BuildContext context, WidgetRef ref) async {
    FamilyInvite? invite;
    await runAction(context, () async => invite = await _family(ref).invite());
    if (invite == null || !context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => InviteSheet(invite: invite!),
    );
  }

  Future<void> _changeRole(BuildContext context, WidgetRef ref, FamilyMember member) async {
    final role = await showModalBottomSheet<FamilyRole>(
      context: context,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(context.l10n.familyChangeRoleTitle(member.displayName),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
            ),
            for (final r in FamilyRole.assignable)
              ListTile(
                title: Text(r.displayName(context), style: TextStyle(fontWeight: FontWeight.w600, color: context.palette.text)),
                subtitle: Text(
                  r.description(context),
                  style: TextStyle(fontSize: 12, color: context.palette.textMuted),
                ),
                trailing: r == member.role ? Icon(Icons.check, color: context.palette.success) : null,
                onTap: () => Navigator.pop(ctx, r),
              ),
          ],
        ),
      ),
    );
    if (role == null || !context.mounted) return;
    await runAction(context, () => _family(ref).changeRole(member, role));
  }

  Future<void> _removeMember(BuildContext context, WidgetRef ref, FamilyMember member) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.familyRemoveTitle),
        content: Text(context.l10n.familyRemoveMessage(member.displayName)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.commonCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.familyRemove),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    await runAction(context, () => _family(ref).removeMember(member));
  }

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.familyLeaveTitle),
        content: Text(context.l10n.familyLeaveMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.commonCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.familyLeave),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    await runAction(context, () => _family(ref).leave());
  }
}
