import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'features/onboarding/application/onboarding_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize Supabase when credentials are supplied via --dart-define;
  // otherwise the app uses the in-memory fake auth repository.
  if (Env.hasSupabase) {
    await Supabase.initialize(url: Env.supabaseUrl, publishableKey: Env.supabaseAnonKey);
  }

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const DocsBuddyApp(),
    ),
  );
}
