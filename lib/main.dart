import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/error/failure_reporter.dart';
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
      appBuilder: (boot) {
        // One reporter for the whole app, so a failure seen by the provider
        // observer and again by a screen is still logged once.
        final reporter = FailureReporter(boot.logger);
        return ProviderScope(
          observers: [FailureObserver(reporter)],
          overrides: [
            failureReporterProvider.overrideWithValue(reporter),
            ...platformOverrides(boot.prefs, logger: boot.logger, firebaseReady: boot.firebaseReady),
            ...backendOverrides(boot.backend),
          ],
          child: const DocsBuddyApp(),
        );
      },
    ),
  );
}
