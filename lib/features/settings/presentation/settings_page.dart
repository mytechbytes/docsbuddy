import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/env.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/application/auth_controller.dart';
import '../../family/application/family_controller.dart';
import '../../onboarding/application/onboarding_controller.dart';
import '../../profile/application/profile_providers.dart';
import '../application/settings_providers.dart';
import '../data/notification_prefs_repository.dart';

/// Design screen 15 — Settings: Account / Notifications / Family sections
/// (notification toggles + default offsets are backed by
/// `notification_prefs`), plus app utilities and sign out.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(authControllerProvider).isLoading;
    final profile = ref.watch(profileProvider).valueOrNull;
    final prefs = ref.watch(notificationPrefsProvider).valueOrNull;
    final members = ref.watch(familyControllerProvider).valueOrNull?.members ?? const [];

    Future<void> setChannel(String channel, bool enabled) async {
      final current = prefs ?? const NotificationPrefs();
      final channels = {...current.channels};
      enabled ? channels.add(channel) : channels.remove(channel);
      await ref.read(notificationPrefsRepositoryProvider).update(current.copyWith(channels: channels.toList()));
      ref.invalidate(notificationPrefsProvider);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const _SectionLabel('Account'),
          _Card(children: [
            _Row(
              icon: Icons.person_outline,
              title: 'Personal information',
              onTap: () => context.push('/profile'),
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
            ),
            _Row(
              icon: Icons.mail_outline,
              title: 'Email',
              trailing: Text(profile?.email ?? '—',
                  style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 12.5)),
            ),
            _Row(
              icon: Icons.lock_outline,
              title: 'Change password',
              onTap: () => context.push('/change-password'),
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
            ),
            _Row(
              icon: Icons.shield_outlined,
              title: 'Security & 2FA',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Security & 2FA is coming in the next update.'))),
              trailing:
                  const Text('Soon', style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 12.5)),
            ),
          ]),
          const _SectionLabel('Notifications'),
          _Card(children: [
            _ToggleRow(
              icon: Icons.notifications_active_outlined,
              title: 'Push notifications',
              value: prefs?.hasChannel('push') ?? true,
              onChanged: (v) => setChannel('push', v),
            ),
            _ToggleRow(
              icon: Icons.mail_outline,
              title: 'Email reminders',
              value: prefs?.hasChannel('email') ?? false,
              onChanged: (v) => setChannel('email', v),
            ),
            _ToggleRow(
              icon: Icons.chat_outlined,
              title: 'WhatsApp reminders',
              value: prefs?.hasChannel('whatsapp') ?? false,
              onChanged: (v) => setChannel('whatsapp', v),
            ),
            _Row(
              icon: Icons.update_outlined,
              title: 'Default offsets',
              onTap: () => _editOffsets(context, ref, prefs ?? const NotificationPrefs()),
              trailing: Text(
                '${(prefs?.defaultOffsets ?? const [30, 7, 1]).join(' · ')}d',
                style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 12.5),
              ),
            ),
          ]),
          const _SectionLabel('Family'),
          _Card(children: [
            _Row(
              icon: Icons.groups_outlined,
              title: 'Manage family',
              onTap: () => context.push('/family-manage'),
              trailing: Text('${members.length} member${members.length == 1 ? '' : 's'}',
                  style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 12.5)),
            ),
          ]),
          const _SectionLabel('App'),
          _Card(children: [
            _Row(
              icon: Icons.cloud_outlined,
              title: 'Backend',
              trailing: Text(Env.hasSupabase ? 'Supabase' : 'Local (fake)',
                  style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 12.5)),
            ),
            _Row(
              icon: Icons.notification_add_outlined,
              title: 'Send test notification',
              onTap: () async {
                final svc = ref.read(notificationServiceProvider);
                final ok = await svc.requestPermission();
                await svc.showTest();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(ok ? 'Sent a test notification.' : 'Notifications are blocked in system settings.'),
                    backgroundColor: ok ? AppColors.green : AppColors.red,
                  ));
                }
              },
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
            ),
            _Row(
              icon: Icons.checklist_outlined,
              title: "What's pending",
              onTap: () => context.push('/roadmap'),
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
            ),
            _Row(
              icon: Icons.replay_outlined,
              title: 'Replay onboarding',
              onTap: () async {
                await ref.read(onboardingControllerProvider.notifier).reset();
                if (context.mounted) context.go('/onboarding');
              },
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
            ),
          ]),
          const SizedBox(height: 16),
          _Card(children: [
            _Row(
              icon: Icons.logout,
              title: 'Sign out',
              danger: true,
              onTap: loading
                  ? null
                  : () async {
                      final ok = await ref.read(authControllerProvider.notifier).signOut();
                      if (ok && context.mounted) context.go('/sign-in');
                    },
            ),
          ]),
        ],
      ),
    );
  }

  /// Multi-select chips over the supported days-before-due offsets.
  Future<void> _editOffsets(BuildContext context, WidgetRef ref, NotificationPrefs prefs) async {
    const options = [60, 30, 14, 7, 3, 1];
    final selected = {...prefs.defaultOffsets};
    final saved = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Default reminder offsets',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 4),
                const Text('Days before a due date to notify — used for new reminders.',
                    style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final d in options)
                      FilterChip(
                        selected: selected.contains(d),
                        onSelected: (v) => setState(() => v ? selected.add(d) : selected.remove(d)),
                        label: Text('${d}d before'),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: selected.contains(d) ? Colors.white : AppColors.ink2),
                        selectedColor: AppColors.chipBlue,
                        checkmarkColor: Colors.white,
                        backgroundColor: AppColors.bg,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                            side: const BorderSide(color: AppColors.line)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.ink),
                    onPressed: selected.isEmpty ? null : () => Navigator.of(context).pop(true),
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (saved == true) {
      final offsets = selected.toList()..sort((a, b) => b.compareTo(a));
      await ref.read(notificationPrefsRepositoryProvider).update(prefs.copyWith(defaultOffsets: offsets));
      ref.invalidate(notificationPrefsProvider);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
      child: Text(text.toUpperCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.title, this.trailing, this.onTap, this.danger = false});
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.red : AppColors.ink;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      trailing: trailing,
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.icon, required this.title, required this.value, required this.onChanged});
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.ink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink)),
      trailing: Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.green),
    );
  }
}
