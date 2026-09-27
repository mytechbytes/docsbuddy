import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/catalog/domain/catalog_models.dart';
import '../features/catalog/domain/reminder_filters.dart';

/// Every route in the app, in one place. Screens navigate with these
/// builders (or the [AppNavigation] helpers for routes that carry an
/// object) — never with hand-written path strings.
abstract final class AppRoutes {
  // ── Route patterns (used by the router) ──
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const verifyOtpPattern = '/verify-otp';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const appliancePickerPattern = '/appliance-picker';
  static const assetNewPattern = '/asset-new';
  static const assetPattern = '/asset/:id';
  static const assetEdit = '/asset-edit';
  static const addReminderPattern = '/asset/:id/add-reminder';
  static const roomPattern = '/room/:id';
  static const search = '/search';
  static const notifications = '/notifications';
  static const remindersPattern = '/reminders/:filter';
  static const profile = '/profile';
  static const changePassword = '/change-password';
  static const security = '/security';
  static const familyManage = '/family-manage';
  static const roadmap = '/roadmap';

  /// Routes reachable while signed out.
  static const authRoutes = {signIn, signUp, forgotPassword, verifyOtpPattern, resetPassword};

  // ── Parameter / query keys ──
  static const idParam = 'id';
  static const filterParam = 'filter';
  static const emailQuery = 'email';
  static const locationQuery = 'location';

  // ── Locations ──
  static String verifyOtp(String email) => _withQuery(verifyOtpPattern, {emailQuery: email});
  static String appliancePicker({String? location}) => _withQuery(appliancePickerPattern, {locationQuery: location});
  static String assetNew({String? location}) => _withQuery(assetNewPattern, {locationQuery: location});
  static String asset(String id) => '/asset/$id';
  static String addReminder(String assetId) => '/asset/$assetId/add-reminder';
  static String room(String id) => '/room/$id';
  static String reminders(ReminderFilter filter) => '/reminders/${filter.name}';

  static String _withQuery(String path, Map<String, String?> query) {
    final params = {
      for (final e in query.entries)
        if (e.value != null && e.value!.isNotEmpty) e.key: e.value!,
    };
    return params.isEmpty ? path : Uri(path: path, queryParameters: params).toString();
  }
}

/// Typed navigation for routes that carry an object as `extra`, so the
/// type travels with the route instead of being cast at the other end.
extension AppNavigation on BuildContext {
  Future<void> pushEditAsset(Asset asset) => push(AppRoutes.assetEdit, extra: asset);

  Future<void> pushAddReminder(String assetId) => push(AppRoutes.addReminder(assetId));

  Future<void> pushEditReminder(Reminder reminder) =>
      push(AppRoutes.addReminder(reminder.assetId), extra: reminder);

  /// Replaces the appliance picker with Add-asset, optionally pre-typed.
  void replaceWithNewAsset({AssetCategory? preset, String? location}) =>
      pushReplacement(AppRoutes.assetNew(location: location), extra: preset);
}
