// Every screen, as the real page widget wired to the fake backend. Data-backed
// screens come in the four states a user meets (Populated, Empty, Loading,
// Error); forms and static screens have one entry. Navigation out of a screen
// lands on a placeholder that names the route, and a screen that closes itself
// shows "This screen closed itself" with a way back in.
import 'package:docsbuddy/features/auth/presentation/forgot_password_page.dart';
import 'package:docsbuddy/features/auth/presentation/otp_verify_page.dart';
import 'package:docsbuddy/features/auth/presentation/reset_password_page.dart';
import 'package:docsbuddy/features/auth/presentation/sign_in_page.dart';
import 'package:docsbuddy/features/auth/presentation/sign_up_page.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/catalog/domain/common_categories.dart';
import 'package:docsbuddy/features/catalog/presentation/add_asset_page.dart';
import 'package:docsbuddy/features/catalog/presentation/appliance_picker_page.dart';
import 'package:docsbuddy/features/catalog/presentation/asset_detail_page.dart';
import 'package:docsbuddy/features/catalog/presentation/assets_page.dart';
import 'package:docsbuddy/features/catalog/presentation/room_detail_page.dart';
import 'package:docsbuddy/features/catalog/presentation/rooms_page.dart';
import 'package:docsbuddy/features/catalog/presentation/search_page.dart';
import 'package:docsbuddy/features/dashboard/presentation/dashboard_tab.dart';
import 'package:docsbuddy/features/family/presentation/family_page.dart';
import 'package:docsbuddy/features/onboarding/presentation/onboarding_page.dart';
import 'package:docsbuddy/features/profile/presentation/profile_page.dart';
import 'package:docsbuddy/features/reminders/domain/reminder_filters.dart';
import 'package:docsbuddy/features/reminders/presentation/add_reminder_page.dart';
import 'package:docsbuddy/features/reminders/presentation/filtered_reminders_page.dart';
import 'package:docsbuddy/features/reminders/presentation/notifications_page.dart';
import 'package:docsbuddy/features/roadmap/presentation/roadmap_page.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:docsbuddy/features/security/presentation/lock_screen.dart';
import 'package:docsbuddy/features/security/presentation/mfa_challenge_screen.dart';
import 'package:docsbuddy/features/security/presentation/security_page.dart';
import 'package:docsbuddy/features/settings/presentation/change_password_page.dart';
import 'package:docsbuddy/features/settings/presentation/settings_page.dart';
import 'package:docsbuddy/features/shell/presentation/home_shell.dart';
import 'package:widgetbook/widgetbook.dart';

import '../support/scenario.dart';
import '../support/use_cases.dart';

const _ac = 'Daikin Inverter AC';
const _car = 'Honda City ZX';
const _overduePhone = 'iPhone 15 Pro';

WidgetbookCategory screens() => WidgetbookCategory(
      name: 'Screens',
      children: [
        WidgetbookFolder(name: 'First launch', children: [
          WidgetbookComponent(name: 'OnboardingPage', useCases: [
            screen('Four-slide walkthrough', (_) => const OnboardingPage(), root: true),
          ]),
        ]),
        WidgetbookFolder(name: 'Sign in and recovery', children: [
          WidgetbookComponent(name: 'SignInPage', useCases: [screen('Default', (_) => const SignInPage(), root: true)]),
          WidgetbookComponent(name: 'SignUpPage', useCases: [screen('Default', (_) => const SignUpPage())]),
          WidgetbookComponent(name: 'ForgotPasswordPage', useCases: [screen('Default', (_) => const ForgotPasswordPage())]),
          WidgetbookComponent(name: 'OtpVerifyPage', useCases: [
            screen('Default', (_) => const OtpVerifyPage(email: 'anand.kumar@example.com')),
          ]),
          WidgetbookComponent(name: 'ResetPasswordPage', useCases: [screen('Default', (_) => const ResetPasswordPage())]),
        ]),
        WidgetbookFolder(name: 'Home', children: [
          WidgetbookComponent(name: 'HomeShell', useCases: [
            screen('Populated', (_) => const HomeShell(), root: true),
            screen('Empty', (_) => const HomeShell(), scenario: Scenario.empty, root: true),
            screen('Locked', (_) => const HomeShell(), options: const WorldOptions(appLock: true), root: true),
          ]),
          WidgetbookComponent(name: 'DashboardTab', useCases: screenStates((_) => const DashboardTab(), root: true)),
          WidgetbookComponent(name: 'RoomsPage', useCases: screenStates((_) => const RoomsPage(), root: true)),
          WidgetbookComponent(name: 'AssetsPage', useCases: screenStates((_) => const AssetsPage(), root: true)),
          WidgetbookComponent(name: 'FamilyPage', useCases: screenStates((_) => const FamilyPage(), root: true)),
          WidgetbookComponent(name: 'SettingsPage', useCases: screenStates((_) => const SettingsPage(), root: true)),
        ]),
        WidgetbookFolder(name: 'Assets and rooms', children: [
          WidgetbookComponent(name: 'AppliancePickerPage', useCases: [
            screen('Default', (_) => const AppliancePickerPage()),
            screen('Adding to a room', (_) => const AppliancePickerPage(locationName: 'Kitchen')),
          ]),
          WidgetbookComponent(name: 'AddAssetPage', useCases: [
            screen('New', (_) => const AddAssetPage()),
            screen('New from a picked type', (_) => AddAssetPage(preset: _category('cat_ac'))),
            screen('New in a room', (_) => AddAssetPage(preset: _category('cat_fridge'), initialLocation: 'Kitchen')),
            screen('Edit existing', (refs) => AddAssetPage(editing: refs.asset(_ac))),
          ]),
          WidgetbookComponent(name: 'AssetDetailPage', useCases: [
            screen('Appliance with upcoming services', (refs) => AssetDetailPage(assetId: refs.assetId(_ac))),
            screen('Vehicle', (refs) => AssetDetailPage(assetId: refs.assetId(_car))),
            screen('Overdue service', (refs) => AssetDetailPage(assetId: refs.assetId(_overduePhone))),
            screen('Loading', (refs) => AssetDetailPage(assetId: refs.assetId(_ac)), scenario: Scenario.loading),
            screen('Error', (refs) => AssetDetailPage(assetId: refs.assetId(_ac)), scenario: Scenario.error),
            screen('Asset not found', (_) => const AssetDetailPage(assetId: DemoRefs.missing), scenario: Scenario.empty),
          ]),
          WidgetbookComponent(name: 'RoomDetailPage', useCases: [
            screen('Room with several appliances', (refs) => RoomDetailPage(locationId: refs.roomId('Living Room'))),
            screen('Garage', (refs) => RoomDetailPage(locationId: refs.roomId('Garage'))),
            screen('Loading', (refs) => RoomDetailPage(locationId: refs.roomId('Living Room')), scenario: Scenario.loading),
            screen('Error', (refs) => RoomDetailPage(locationId: refs.roomId('Living Room')), scenario: Scenario.error),
            screen('Room not found', (_) => const RoomDetailPage(locationId: DemoRefs.missing), scenario: Scenario.empty),
          ]),
          WidgetbookComponent(name: 'SearchPage', useCases: screenStates((_) => const SearchPage())),
        ]),
        WidgetbookFolder(name: 'Reminders', children: [
          WidgetbookComponent(name: 'AddReminderPage', useCases: [
            screen('New reminder', (refs) => AddReminderPage(assetId: refs.assetId(_ac))),
            screen('Edit reminder',
                (refs) => AddReminderPage(assetId: refs.assetId(_ac), editing: refs.reminder(_ac, 'Service'))),
            screen('Asset not found', (_) => const AddReminderPage(assetId: DemoRefs.missing), scenario: Scenario.empty),
          ]),
          WidgetbookComponent(name: 'FilteredRemindersPage', useCases: [
            for (final filter in ReminderFilter.values)
              screen(filter.title, (_) => FilteredRemindersPage(filter: filter)),
            for (final s in const [Scenario.empty, Scenario.loading, Scenario.error])
              screen('Active services, ${s.label.toLowerCase()}', (_) => const FilteredRemindersPage(filter: ReminderFilter.active),
                  scenario: s),
          ]),
          WidgetbookComponent(name: 'NotificationsPage', useCases: screenStates((_) => const NotificationsPage())),
        ]),
        WidgetbookFolder(name: 'Account', children: [
          WidgetbookComponent(name: 'ProfilePage', useCases: screenStates((_) => const ProfilePage())),
          WidgetbookComponent(name: 'ChangePasswordPage', useCases: [screen('Default', (_) => const ChangePasswordPage())]),
          WidgetbookComponent(name: 'SecurityPage', useCases: [
            screen('Two-step verification off', (_) => const SecurityPage()),
            screen('Two-step verification on', (_) => const SecurityPage(), options: const WorldOptions(totpEnabled: true)),
            screen('App lock on', (_) => const SecurityPage(), options: const WorldOptions(appLock: true)),
          ]),
          WidgetbookComponent(name: 'LockScreen', useCases: [
            screen('Default', (_) => const LockScreen(), root: true),
            screen('Not recognised', (_) => const LockScreen(),
                root: true, options: const WorldOptions(unlockResult: BiometricResult.failed)),
            screen('Too many attempts', (_) => const LockScreen(),
                root: true, options: const WorldOptions(unlockResult: BiometricResult.lockedOut)),
            screen('Device has no screen lock', (_) => const LockScreen(),
                root: true, options: const WorldOptions(unlockResult: BiometricResult.unavailable)),
          ]),
          WidgetbookComponent(name: 'MfaChallengeScreen', useCases: [screen('Default', (_) => const MfaChallengeScreen(), root: true)]),
          WidgetbookComponent(name: 'RoadmapPage', useCases: [screen('Default', (_) => const RoadmapPage())]),
        ]),
      ],
    );

/// A built-in asset type by id, for screens that open pre-typed.
AssetCategory _category(String id) => commonAssetCategories.firstWhere((c) => c.id == id);
