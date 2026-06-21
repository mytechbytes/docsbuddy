import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/auth_repository.dart';
import '../data/fake_auth_repository.dart';
import '../data/supabase_auth_repository.dart';

/// Binds the active [AuthRepository]: the real Supabase one when credentials are
/// configured, otherwise an in-memory fake so the app runs without a backend.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (Env.hasSupabase) {
    return SupabaseAuthRepository(Supabase.instance.client);
  }
  return FakeAuthRepository();
});

/// Reactive signed-in flag for route guards.
final authStateProvider = StreamProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
