import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/fcm_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../catalog/presentation/assets_page.dart';
import '../../dashboard/presentation/dashboard_tab.dart';
import '../../family/presentation/family_page.dart';
import '../../settings/presentation/settings_page.dart';

/// Signed-in app shell with bottom navigation.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  static const _tabs = [DashboardTab(), AssetsPage(), FamilyPage(), SettingsPage()];

  @override
  void initState() {
    super.initState();
    // Register for silent push once signed in (no-op without Firebase config).
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(fcmServiceProvider).init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.paper,
        indicatorColor: const Color(0xFFEEF3FB),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Assets'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Family'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
