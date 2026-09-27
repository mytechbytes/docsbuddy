import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/feedback.dart';
import '../application/family_controller.dart';
import '../domain/family_models.dart';
import 'widgets/family_widgets.dart';

class FamilyPage extends ConsumerWidget {
  const FamilyPage({super.key});

  FamilyController _family(WidgetRef ref) => ref.read(familyControllerProvider.notifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text('Family', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(familyControllerProvider.notifier).refresh(),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => FamilyErrorState(message: failureMessage(e), onRetry: () => _family(ref).refresh()),
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
        title: const Text('Create a family'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Kumar Family'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Create')),
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
        title: const Text('Join a family'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(hintText: 'Invite code (e.g. AB12CD34)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Join')),
        ],
      ),
    );
    if (code == null || code.trim().isEmpty || !context.mounted) return;
    await runAction(
      context,
      () => _family(ref).acceptInvite(code),
      success: 'Joined! Family rooms, assets and reminders are syncing.',
    );
  }

  Future<void> _inviteSheet(BuildContext context, WidgetRef ref) async {
    FamilyInvite? invite;
    await runAction(context, () async => invite = await _family(ref).invite());
    if (invite == null || !context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => InviteSheet(invite: invite!),
    );
  }

  Future<void> _changeRole(BuildContext context, WidgetRef ref, FamilyMember member) async {
    final role = await showModalBottomSheet<FamilyRole>(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text('Change role — ${member.displayName}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
            ),
            for (final r in FamilyRole.assignable)
              ListTile(
                title: Text(r.label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink)),
                subtitle: Text(
                  switch (r) {
                    FamilyRole.admin => 'Manage members, assets and invites',
                    FamilyRole.viewer => 'Read-only access',
                    _ => 'Add and manage own assets',
                  },
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                trailing: r == member.role ? const Icon(Icons.check, color: AppColors.green) : null,
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
        title: const Text('Remove member?'),
        content: Text('${member.displayName} will lose access to this family’s assets and reminders.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
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
        title: const Text('Leave family?'),
        content: const Text('You will stop receiving this family’s reminders.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    await runAction(context, () => _family(ref).leave());
  }
}
