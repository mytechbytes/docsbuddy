import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/db_logo.dart';
import '../onboarding/application/onboarding_controller.dart';

/// Temporary landing surface for routes whose feature isn't built yet
/// (auth, dashboard). The onboarding flow is the real deliverable here; these
/// just prove navigation + the first-launch guard work end to end.
class PlaceholderPage extends ConsumerWidget {
  const PlaceholderPage({super.key, required this.title, required this.subtitle, required this.icon});

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        title: const DbLogo(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
                child: Icon(icon, color: AppColors.teal),
              ),
              const SizedBox(height: 20),
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 8),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.muted)),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () async {
                  await ref.read(sharedPreferencesProvider).remove('onboarding_complete');
                  ref.invalidate(onboardingControllerProvider);
                  if (context.mounted) context.go('/onboarding');
                },
                child: const Text('Replay onboarding', style: TextStyle(color: AppColors.chipBlue, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
