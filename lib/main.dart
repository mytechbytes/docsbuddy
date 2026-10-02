import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'bootstrap/app_startup.dart';
import 'bootstrap/dependencies.dart';
import 'bootstrap/startup_gate.dart';

/// Draws a launch screen immediately; [AppStartup] runs the init steps behind
/// it (Firebase, backend, preferences) and hands the results to the real app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    StartupGate(
      startup: AppStartup(),
      appBuilder: (boot) => ProviderScope(
        overrides: [
          ...platformOverrides(boot.prefs, logger: boot.logger, firebaseReady: boot.firebaseReady),
          ...backendOverrides(boot.backend),
        ],
        child: const DocsBuddyApp(),
      ),
    ),
  );
}
