import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/env.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/db_logo.dart';
import '../../auth/application/auth_controller.dart';
import '../../onboarding/application/onboarding_controller.dart';

/// Minimal post-login surface so the full auth flow can be exercised end to end
/// (sign in/up → here → sign out). The real upcoming-reminders dashboard
/// (design 01) replaces this with the home feature.
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  Future<void> _signOut() async {
    final ok = await ref.read(authControllerProvider.notifier).signOut();
    if (ok && mounted) context.go('/sign-in');
  }

  Future<void> _replayOnboarding() async {
    await ref.read(onboardingControllerProvider.notifier).reset();
    if (mounted) context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider).isLoading;
    final backend = Env.hasSupabase ? 'Supabase' : 'Local (fake auth)';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        titleSpacing: 20,
        title: const Align(alignment: Alignment.centerLeft, child: DbLogo(size: 20)),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout, color: AppColors.ink),
            onPressed: loading ? null : _signOut,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(color: AppColors.greenSoft, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, size: 36, color: AppColors.green),
              ),
              const SizedBox(height: 20),
              const Text("You're signed in", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 8),
              const Text(
                'Auth works end to end. The reminders dashboard lands here next, per the shipping order.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.line)),
                child: Text('Backend: $backend', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink2)),
              ),
              const SizedBox(height: 28),
              GhostButton(label: 'Manage family', onPressed: () => context.push('/family')),
              const SizedBox(height: 10),
              PrimaryButton(label: 'Sign out', isLoading: loading, onPressed: _signOut),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _replayOnboarding,
                child: const Text('Replay onboarding', style: TextStyle(color: AppColors.chipBlue, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
