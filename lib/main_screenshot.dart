// Screenshot harness — runs the real app (fakes, no Supabase) but pre-seeds
// onboarding-complete + a signed-in fake auth so the signed-in screens
// (/dashboard, /asset/:id) can be deep-linked for visual comparison.
// NOT shipped — used only to render screens for screenshots.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'features/auth/application/auth_providers.dart';
import 'features/auth/data/fake_auth_repository.dart';
import 'features/onboarding/application/onboarding_controller.dart';

class _SignedInFakeAuth extends FakeAuthRepository {
  @override
  bool get isSignedIn => true;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({'onboarding_complete': true});
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authRepositoryProvider.overrideWithValue(_SignedInFakeAuth()),
      ],
      child: const DocsBuddyApp(),
    ),
  );
}
