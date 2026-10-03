import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../reminders/application/reminder_notification_sync.dart';
import '../../catalog/presentation/assets_page.dart';
import '../../catalog/presentation/rooms_page.dart';
import '../../dashboard/presentation/dashboard_tab.dart';
import '../../devices/application/push_registration.dart';
import '../../family/presentation/family_page.dart';
import '../../security/application/security_providers.dart';
import '../../security/presentation/mfa_challenge_screen.dart';
import '../../settings/presentation/settings_page.dart';
import '../../catalog/application/catalog_sync.dart';
import '../../../core/l10n/l10n.dart';

/// Signed-in app shell with bottom navigation. Gates on the MFA step-up and
/// keeps the signed-in background syncs alive. (The app lock sits above the
/// whole app — see `AppLockGate` — so it also covers screens pushed over this.)
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  static const _tabs = [DashboardTab(), RoomsPage(), AssetsPage(), FamilyPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    // Signed-in background work: local reminder notifications, refresh on
    // silent push, and push-token registration.
    ref.watch(reminderNotificationSyncProvider);
    ref.watch(remoteChangeSyncProvider);
    ref.watch(pushRegistrationProvider);

    // AAL2 step-up comes before everything: a session with an enrolled
    // authenticator must pass the TOTP check first.
    if (ref.watch(mfaChallengeRequiredProvider).value ?? false) return const MfaChallengeScreen();

    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      // Five labels share one row (64dp each on a small phone), so they stop
      // growing at 1.15×: past that "Settings" would break across lines. The icons
      // carry the meaning from there.
      bottomNavigationBar: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.15,
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: context.l10n.navHome),
            NavigationDestination(
                icon: const Icon(Icons.meeting_room_outlined), selectedIcon: const Icon(Icons.meeting_room), label: context.l10n.navRooms),
            NavigationDestination(
                icon: const Icon(Icons.inventory_2_outlined), selectedIcon: const Icon(Icons.inventory_2), label: context.l10n.navAssets),
            NavigationDestination(icon: const Icon(Icons.groups_outlined), selectedIcon: const Icon(Icons.groups), label: context.l10n.commonFamily),
            NavigationDestination(
                icon: const Icon(Icons.settings_outlined), selectedIcon: const Icon(Icons.settings), label: context.l10n.commonSettings),
          ],
        ),
      ),
    );
  }
}
