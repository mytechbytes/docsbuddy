// Play Store screenshot harness — the real app on the in-memory fakes (no
// Supabase), pre-seeded with a signed-in user, a family, documents and a
// realistic home inventory (see `bootstrap/backends/demo_backend.dart`) so
// every screen looks lived-in.
// NOT shipped — run it only to capture store screenshots:
//
//   flutter run -t lib/main_store_screenshots.dart -d <simulator>
//
// Everything here is fictional demo data.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'bootstrap/backends/demo_backend.dart';
import 'bootstrap/dependencies.dart';
import 'core/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Test-only API, used deliberately: this harness is never shipped.
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({'onboarding_complete': true});
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        ...platformOverrides(prefs, logger: const DebugAppLogger(), firebaseReady: false),
        ...backendOverrides(await createDemoBackend()),
      ],
      child: const DocsBuddyApp(),
    ),
  );
}
