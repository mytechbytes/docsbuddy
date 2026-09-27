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
import '../features/catalog/domain/catalog_models.dart';
import '../features/catalog/presentation/add_asset_page.dart';
import '../features/reminders/domain/reminder_filters.dart';
import '../features/reminders/presentation/add_reminder_page.dart';
import '../features/catalog/presentation/appliance_picker_page.dart';
import '../features/catalog/presentation/asset_detail_page.dart';
import '../features/reminders/presentation/filtered_reminders_page.dart';
import '../features/reminders/presentation/notifications_page.dart';
import '../features/catalog/presentation/room_detail_page.dart';
import '../features/catalog/presentation/search_page.dart';
import '../features/family/presentation/family_page.dart';
import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/roadmap/presentation/roadmap_page.dart';
import '../features/security/presentation/security_page.dart';
import '../features/settings/presentation/change_password_page.dart';
import '../features/shell/presentation/home_shell.dart';
import 'app_routes.dart';

/// App router with two guards:
///  1. first-launch onboarding (until completed on this device), then
///  2. authentication — unauthenticated users are kept in the auth flow,
///     authenticated users are sent to the dashboard.
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  final refresh = _GoRouterRefreshStream(auth.authStateChanges());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    refreshListenable: refresh,
    redirect: (context, state) {
      final seenOnboarding = ref.read(onboardingControllerProvider);
      final signedIn = auth.isSignedIn;
      final loc = state.matchedLocation;
      final atOnboarding = loc == AppRoutes.onboarding;
      final inAuth = AppRoutes.authRoutes.contains(loc);

      if (!seenOnboarding) return atOnboarding ? null : AppRoutes.onboarding;
      if (!signedIn) return inAuth ? null : AppRoutes.signIn;
      // Signed in: keep out of onboarding/auth.
      if (atOnboarding || inAuth) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.onboarding, builder: (_, _) => const OnboardingPage()),

      // ── Auth ──
      GoRoute(path: AppRoutes.signIn, builder: (_, _) => const SignInPage()),
      GoRoute(path: AppRoutes.signUp, builder: (_, _) => const SignUpPage()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (_, _) => const ForgotPasswordPage()),
      GoRoute(
        path: AppRoutes.verifyOtpPattern,
        builder: (_, state) => OtpVerifyPage(email: state.uri.queryParameters[AppRoutes.emailQuery] ?? ''),
      ),
      GoRoute(path: AppRoutes.resetPassword, builder: (_, _) => const ResetPasswordPage()),

      // ── App ──
      GoRoute(path: AppRoutes.dashboard, builder: (_, _) => const HomeShell()),
      GoRoute(
        path: AppRoutes.appliancePickerPattern,
        builder: (_, state) => AppliancePickerPage(locationName: state.uri.queryParameters[AppRoutes.locationQuery]),
      ),
      GoRoute(
        path: AppRoutes.assetNewPattern,
        builder: (_, state) => AddAssetPage(
          preset: state.extra as AssetCategory?,
          initialLocation: state.uri.queryParameters[AppRoutes.locationQuery],
        ),
      ),
      GoRoute(path: AppRoutes.assetPattern, builder: (_, state) => AssetDetailPage(assetId: state.pathParameters[AppRoutes.idParam]!)),
      GoRoute(
        path: AppRoutes.assetEdit,
        builder: (_, state) => AddAssetPage(editing: state.extra as Asset?),
      ),
      GoRoute(
        path: AppRoutes.addReminderPattern,
        builder: (_, state) => AddReminderPage(
          assetId: state.pathParameters[AppRoutes.idParam]!,
          editing: state.extra as Reminder?,
        ),
      ),
      GoRoute(path: AppRoutes.roomPattern, builder: (_, state) => RoomDetailPage(locationId: state.pathParameters[AppRoutes.idParam]!)),
      GoRoute(path: AppRoutes.search, builder: (_, _) => const SearchPage()),
      GoRoute(path: AppRoutes.notifications, builder: (_, _) => const NotificationsPage()),
      GoRoute(
        path: AppRoutes.remindersPattern,
        builder: (_, state) => FilteredRemindersPage(filter: ReminderFilter.fromName(state.pathParameters[AppRoutes.filterParam])),
      ),
      GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfilePage()),
      GoRoute(path: AppRoutes.changePassword, builder: (_, _) => const ChangePasswordPage()),
      GoRoute(path: AppRoutes.security, builder: (_, _) => const SecurityPage()),
      GoRoute(path: AppRoutes.familyManage, builder: (_, _) => const FamilyPage()),
      GoRoute(path: AppRoutes.roadmap, builder: (_, _) => const RoadmapPage()),
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
