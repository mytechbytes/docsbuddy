import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/_placeholders/placeholder_page.dart';
import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/presentation/onboarding_page.dart';

/// App router. The first-launch guard sends users to `/onboarding` until the
/// walkthrough has been completed on this device.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final seen = ref.read(onboardingControllerProvider);
      final atOnboarding = state.matchedLocation == '/onboarding';
      if (!seen && !atOnboarding) return '/onboarding';
      if (seen && atOnboarding) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingPage()),
      GoRoute(
        path: '/home',
        builder: (_, _) => const PlaceholderPage(
          title: 'You’re all set',
          subtitle: 'The dashboard lands here next. Onboarding is wired up — assets, reminders and family sharing follow the shipping order in the handoff.',
          icon: Icons.dashboard_outlined,
        ),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (_, _) => const PlaceholderPage(
          title: 'Sign in',
          subtitle: 'Supabase auth (email · Google · Apple) is the next feature to build, per ADR-0001 and the shipping order.',
          icon: Icons.lock_outline,
        ),
      ),
    ],
  );
});
