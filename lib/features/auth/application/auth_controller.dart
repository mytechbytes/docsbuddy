import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import 'auth_providers.dart';

/// Drives the auth screens' async actions. `state` is the in-flight status;
/// pages watch `isLoading` to disable/spinner the CTA and surface `error`.
class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Runs [action], routing exceptions into `state.error`. Returns true on
  /// success so the page can navigate.
  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on AuthFailure catch (e, st) {
      state = AsyncError(e.message, st);
      return false;
    } catch (e, st) {
      state = AsyncError('Something went wrong. Please try again.', st);
      return false;
    }
  }

  Future<bool> signIn(String email, String password) =>
      _run(() => _repo.signInWithPassword(email: email.trim(), password: password));

  Future<bool> signUp(String name, String email, String password) =>
      _run(() => _repo.signUp(name: name.trim(), email: email.trim(), password: password));

  Future<bool> google() => _run(_repo.signInWithGoogle);

  Future<bool> apple() => _run(_repo.signInWithApple);

  Future<bool> sendResetCode(String email) =>
      _run(() => _repo.sendPasswordResetCode(email.trim()));

  Future<bool> verifyResetCode(String email, String token) =>
      _run(() => _repo.verifyResetCode(email: email.trim(), token: token));

  Future<bool> updatePassword(String newPassword) =>
      _run(() => _repo.updatePassword(newPassword));

  Future<bool> signOut() => _run(_repo.signOut);
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);
