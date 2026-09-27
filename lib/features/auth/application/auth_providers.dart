import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_repository.dart';

/// Bound at the composition root (`bootstrap/dependencies.dart`).
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => throw UnimplementedError('authRepositoryProvider must be overridden'),
);

/// Reactive signed-in flag for route guards.
final authStateProvider = StreamProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
