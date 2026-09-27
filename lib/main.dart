import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'bootstrap/dependencies.dart';
import 'core/config/env.dart';
import 'core/storage/secure_supabase_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase only when credentials are supplied via --dart-define; otherwise
  // the in-memory fake backend is used.
  final backend = Env.hasSupabase ? supabaseBackendOverrides(await _initSupabase()) : fakeBackendOverrides();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [...platformOverrides(prefs), ...backend],
      child: const DocsBuddyApp(),
    ),
  );
}

Future<SupabaseClient> _initSupabase() async {
  final supabase = await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
    // Review #9: persist the session + PKCE verifier in Keychain/Keystore
    // rather than the SDK's default SharedPreferences.
    authOptions: const FlutterAuthClientOptions(
      localStorage: SecureLocalStorage(),
      pkceAsyncStorage: SecurePkceStorage(),
    ),
  );
  return supabase.client;
}
