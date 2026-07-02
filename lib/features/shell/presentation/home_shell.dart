import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/fcm_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../catalog/presentation/assets_page.dart';
import '../../catalog/presentation/rooms_page.dart';
import '../../dashboard/presentation/dashboard_tab.dart';
import '../../family/presentation/family_page.dart';
import '../../security/application/security_providers.dart';
import '../../security/presentation/lock_screen.dart';
import '../../settings/presentation/settings_page.dart';

/// Signed-in app shell with bottom navigation and the optional app lock:
/// when enabled, reopening the app after the auto-lock window (or a fresh
/// launch) shows the biometric [LockScreen] first.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> with WidgetsBindingObserver {
  int _index = 0;
  bool _locked = false;
  DateTime? _pausedAt;

  static const _tabs = [DashboardTab(), RoomsPage(), AssetsPage(), FamilyPage(), SettingsPage()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locked = ref.read(securityPrefsProvider).appLock;
    // Register for silent push once signed in (no-op without Firebase config).
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(fcmServiceProvider).init());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final prefs = ref.read(securityPrefsProvider);
    if (!prefs.appLock) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _pausedAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final away = _pausedAt == null ? Duration.zero : DateTime.now().difference(_pausedAt!);
      _pausedAt = null;
      if (away >= Duration(minutes: prefs.autoLockMinutes)) {
        setState(() => _locked = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_locked) {
      return LockScreen(onUnlocked: () => setState(() => _locked = false));
    }
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.paper,
        indicatorColor: const Color(0xFFEEF3FB),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.meeting_room_outlined), selectedIcon: Icon(Icons.meeting_room), label: 'Rooms'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Assets'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Family'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
