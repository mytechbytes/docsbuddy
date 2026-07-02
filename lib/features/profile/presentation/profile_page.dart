import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../../auth/application/auth_controller.dart';
import '../../family/application/family_controller.dart';
import '../../family/data/family_models.dart';
import '../application/profile_providers.dart';
import '../data/profile_repository.dart';

/// Design screen 14 — Profile: avatar (tap to change), identity + Verified
/// badge, stats row, family card with invite, and account actions.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (p) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Center(child: _Avatar(profile: p, onChange: () => _changeAvatar(context, ref))),
            const SizedBox(height: 12),
            Center(
              child: Text(p.displayName,
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink)),
            ),
            const SizedBox(height: 2),
            Center(child: Text(p.email, style: const TextStyle(fontSize: 13, color: AppColors.muted))),
            if (p.verified) ...[
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(999)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_outlined, size: 14, color: AppColors.greenLeaf),
                      SizedBox(width: 4),
                      Text('Verified',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.greenLeaf)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 18),
            const _StatsRow(),
            const SizedBox(height: 14),
            const _FamilyCard(),
            const SizedBox(height: 16),
            _MenuCard(children: [
              _MenuRow(
                icon: Icons.person_outline,
                title: 'Edit personal info',
                onTap: () => _editInfo(context, ref, p),
              ),
              _MenuRow(
                icon: Icons.lock_outline,
                title: 'Change password',
                onTap: () => context.push('/change-password'),
              ),
              _MenuRow(
                icon: Icons.notifications_none,
                title: 'Notification preferences',
                onTap: () => context.pop(), // managed on the Settings tab
                subtitle: 'Managed in Settings',
              ),
            ]),
            const SizedBox(height: 16),
            _MenuCard(children: [
              _MenuRow(
                icon: Icons.logout,
                title: 'Sign out',
                danger: true,
                onTap: () async {
                  final ok = await ref.read(authControllerProvider.notifier).signOut();
                  if (ok && context.mounted) context.go('/sign-in');
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _changeAvatar(BuildContext context, WidgetRef ref) async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    final f = res?.files.firstOrNull;
    final bytes = f?.bytes;
    if (f == null || bytes == null) return;
    try {
      await ref.read(profileRepositoryProvider).setAvatar(
            bytes: bytes,
            fileName: f.name,
            mimeType: switch (f.extension?.toLowerCase()) {
              'png' => 'image/png',
              'webp' => 'image/webp',
              'heic' => 'image/heic',
              _ => 'image/jpeg',
            },
          );
      ref.invalidate(profileProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Avatar upload failed: $e'), backgroundColor: AppColors.red));
      }
    }
  }

  Future<void> _editInfo(BuildContext context, WidgetRef ref, Profile p) async {
    final name = TextEditingController(text: p.displayName);
    final phone = TextEditingController(text: p.phone ?? '');
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit personal info',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 16),
                AppTextField(label: 'Display name', controller: name, icon: Icons.person_outline),
                const SizedBox(height: 12),
                AppTextField(
                    label: 'Phone (for WhatsApp reminders)',
                    controller: phone,
                    icon: Icons.phone_outlined,
                    hint: '+91 98…',
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 18),
                PrimaryButton(label: 'Save', onPressed: () => Navigator.of(context).pop(true)),
              ],
            ),
          ),
        ),
      ),
    );
    if (saved == true) {
      await ref.read(profileRepositoryProvider).update(displayName: name.text, phone: phone.text);
      ref.invalidate(profileProvider);
    }
    name.dispose();
    phone.dispose();
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile, required this.onChange});
  final Profile profile;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onChange,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AssetThumb(
            imageRef: profile.avatarUrl,
            size: 96,
            radius: 48,
            fallback: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFFF1C27D), Color(0xFFD68B5C)]),
              ),
              alignment: Alignment.center,
              child: Text(profile.initial,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.ink,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bg, width: 2.5),
              ),
              child: const Icon(Icons.photo_camera_outlined, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(profileStatsProvider).valueOrNull;
    Widget cell(String value, String label) => Expanded(
          child: Column(
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
          color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: Row(
        children: [
          cell('${stats?.$1 ?? '—'}', 'Assets'),
          cell('${stats?.$2 ?? '—'}', 'Reminders'),
          cell('${stats?.$3 ?? '—'}', 'Documents'),
        ],
      ),
    );
  }
}

class _FamilyCard extends ConsumerWidget {
  const _FamilyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(familyControllerProvider).valueOrNull;
    final family = view?.family;
    final members = view?.members ?? const <FamilyMember>[];
    if (family == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(family.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text('${members.length} member${members.length == 1 ? '' : 's'}',
                    style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: Stack(
                    children: [
                      for (var i = 0; i < members.length && i < 5; i++)
                        Positioned(
                          left: i * 20.0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.chipBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.paper, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Text(members[i].initial,
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => context.push('/family-manage'),
            icon: const Icon(Icons.person_add_alt_outlined, size: 16),
            label: const Text('Invite', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: Column(children: children),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.title, this.subtitle, this.onTap, this.danger = false});
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.red : AppColors.ink;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      subtitle: subtitle == null ? null : Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
      trailing: danger ? null : const Icon(Icons.chevron_right, color: AppColors.muted),
    );
  }
}
