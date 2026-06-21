import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/_placeholders/placeholder_page.dart';
import '../features/auth/presentation/forgot_password_page.dart';
import '../features/auth/presentation/otp_verify_page.dart';
import '../features/auth/presentation/reset_password_page.dart';
import '../features/auth/presentation/sign_in_page.dart';
import '../features/auth/presentation/sign_up_page.dart';
import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/presentation/onboarding_page.dart';

/// App router. The first-launch guard sends users to `/onboarding` until the
/// walkthrough has been completed on this device; afterwards the auth flow is
/// the entry point until a session exists (dashboard guard arrives with the
/// home feature).
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/sign-in',
    redirect: (context, state) {
      final seen = ref.read(onboardingControllerProvider);
      final atOnboarding = state.matchedLocation == '/onboarding';
      if (!seen && !atOnboarding) return '/onboarding';
      if (seen && atOnboarding) return '/sign-in';
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingPage()),

      // ── Auth ──
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (_, _) => const SignUpPage()),
      GoRoute(path: '/forgot-password', builder: (_, _) => const ForgotPasswordPage()),
      GoRoute(
        path: '/verify-otp',
        builder: (_, state) => OtpVerifyPage(email: state.uri.queryParameters['email'] ?? ''),
      ),
      GoRoute(path: '/reset-password', builder: (_, _) => const ResetPasswordPage()),

      GoRoute(
        path: '/home',
        builder: (_, _) => const PlaceholderPage(
          title: 'You’re all set',
          subtitle: 'The dashboard lands here next. Auth is wired up — assets, reminders and family sharing follow the shipping order in the handoff.',
          icon: Icons.dashboard_outlined,
        ),
      ),
    ],
  );
});
