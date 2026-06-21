import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../data/family_models.dart';
import '../data/family_repository.dart';
import '../application/family_controller.dart';

class FamilyPage extends ConsumerWidget {
  const FamilyPage({super.key});

  void _error(BuildContext context, Object e) {
    final msg = e is FamilyFailure ? e.message : 'Something went wrong.';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.red));
  }

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
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(message: '$e', onRetry: () => ref.read(familyControllerProvider.notifier).refresh()),
        data: (view) => view.family == null
            ? _EmptyState(
                onCreate: () => _createDialog(context, ref),
                onJoin: () => _joinDialog(context, ref),
              )
            : _FamilyView(
                family: view.family!,
                members: view.members,
                onInvite: () => _inviteSheet(context, ref),
                onLeave: () => _leave(context, ref),
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
    if (name == null || name.trim().isEmpty) return;
    try {
      await ref.read(familyControllerProvider.notifier).createFamily(name);
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
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
          decoration: const InputDecoration(hintText: '6-character code'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Join')),
        ],
      ),
    );
    if (code == null || code.trim().isEmpty) return;
    try {
      await ref.read(familyControllerProvider.notifier).acceptInvite(code.trim().toUpperCase());
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _inviteSheet(BuildContext context, WidgetRef ref) async {
    var role = FamilyRole.member;
    try {
      final invite = await ref.read(familyControllerProvider.notifier).invite(role);
      if (!context.mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.paper,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => _InviteSheet(invite: invite),
      );
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
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
    if (confirm != true) return;
    try {
      await ref.read(familyControllerProvider.notifier).leave();
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate, required this.onJoin});
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
              decoration: const BoxDecoration(color: Color(0xFFEEF3FB), shape: BoxShape.circle),
              child: const Icon(Icons.groups_outlined, size: 34, color: AppColors.chipBlue),
            ),
            const SizedBox(height: 20),
            const Text("You're not in a family yet", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 8),
            const Text(
              'Create a family to share assets and reminders, or join one with an invite code.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.muted),
            ),
            const SizedBox(height: 28),
            PrimaryButton(label: 'Create a family', onPressed: onCreate),
            const SizedBox(height: 10),
            GhostButton(label: 'Join with a code', onPressed: onJoin),
          ],
        ),
      ),
    );
  }
}

class _FamilyView extends StatelessWidget {
  const _FamilyView({required this.family, required this.members, required this.onInvite, required this.onLeave});
  final Family family;
  final List<FamilyMember> members;
  final VoidCallback onInvite;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
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
                    Text('${members.length} member${members.length == 1 ? '' : 's'}', style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text('MEMBERS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
        ),
        for (final m in members) _MemberTile(member: m),
        const SizedBox(height: 22),
        PrimaryButton(label: 'Invite member', onPressed: onInvite),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onLeave,
          child: const Text('Leave family', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});
  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.greenSoft, shape: BoxShape.circle),
            child: Text(member.initial, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.greenLeaf)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(member.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(999)),
            child: Text(member.role.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink2)),
          ),
        ],
      ),
    );
  }
}

class _InviteSheet extends StatelessWidget {
  const _InviteSheet({required this.invite});
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
            const Text('Invite a member', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 6),
            Text('Share this code. They can join as ${invite.role.label}. Expires in 7 days.',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Text(
                invite.code,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 8, color: AppColors.ink),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Copy code',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: invite.code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invite code copied'), backgroundColor: AppColors.green),
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

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
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
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
