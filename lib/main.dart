import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'bootstrap/crash_reporting.dart';
import 'bootstrap/dependencies.dart';
import 'core/config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseReady = await initFirebase();
  final logger = createLogger(firebaseReady: firebaseReady);
  reportUncaughtErrors(logger);

  final backend = await createBackend(Env.backend, logger: logger);
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        ...platformOverrides(prefs, logger: logger, firebaseReady: firebaseReady),
        ...backendOverrides(backend),
      ],
      child: const DocsBuddyApp(),
    ),
  );
}
