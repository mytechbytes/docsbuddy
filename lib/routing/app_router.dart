import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_providers.dart';
import '../features/auth/presentation/forgot_password_page.dart';
import '../features/auth/presentation/otp_verify_page.dart';
import '../features/auth/presentation/reset_password_page.dart';
import '../features/auth/presentation/sign_in_page.dart';
import '../features/auth/presentation/sign_up_page.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/family/presentation/family_page.dart';
import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/presentation/onboarding_page.dart';

const _authRoutes = {
  '/sign-in',
  '/sign-up',
  '/forgot-password',
  '/verify-otp',
  '/reset-password',
};

/// App router with two guards:
///  1. first-launch onboarding (until completed on this device), then
///  2. authentication — unauthenticated users are kept in the auth flow,
///     authenticated users are sent to the dashboard.
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  final refresh = _GoRouterRefreshStream(auth.authStateChanges());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: refresh,
    redirect: (context, state) {
      final seenOnboarding = ref.read(onboardingControllerProvider);
      final signedIn = auth.isSignedIn;
      final loc = state.matchedLocation;
      final atOnboarding = loc == '/onboarding';
      final inAuth = _authRoutes.contains(loc);

      if (!seenOnboarding) return atOnboarding ? null : '/onboarding';
      if (!signedIn) return inAuth ? null : '/sign-in';
      // Signed in: keep out of onboarding/auth.
      if (atOnboarding || inAuth) return '/dashboard';
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

      // ── App ──
      GoRoute(path: '/dashboard', builder: (_, _) => const DashboardPage()),
      GoRoute(path: '/family', builder: (_, _) => const FamilyPage()),
    ],
  );
});

/// Bridges a [Stream] to a [Listenable] so GoRouter re-evaluates `redirect`
/// whenever auth state changes.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
