import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/env.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/application/auth_controller.dart';
import '../../onboarding/application/onboarding_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(authControllerProvider).isLoading;

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
          _Card(children: [
            _Row(
              icon: Icons.cloud_outlined,
              title: 'Backend',
              trailing: Text(Env.hasSupabase ? 'Supabase' : 'Local (fake)', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
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
