import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../domain/auth_repository.dart';
import '../domain/password_policy.dart';
import 'auth_providers.dart';

/// Drives the auth screens' async actions. `state` is the in-flight status;
/// pages watch `isLoading` for the CTA spinner and show `state.error`
/// (always an [AppFailure]). Actions return true on success so the page can
/// navigate.
class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<bool> _run(FutureOr<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } catch (e, st) {
      if (ref.mounted) state = AsyncError(AppFailure.from(e), st);
      return false;
    }
  }

  Future<bool> signIn(String email, String password) =>
      _run(() => _repo.signInWithPassword(email: email.trim(), password: password));

  /// [acceptedTerms] must be true — the sign-up form's checkbox.
  Future<bool> signUp(String name, String email, String password, {required bool acceptedTerms}) => _run(() {
        if (!acceptedTerms) throw const ValidationFailure('Please accept the Terms to continue.', reason: FailureReason.termsRequired);
        return _repo.signUp(name: name.trim(), email: email.trim(), password: password);
      });

  Future<bool> google() => _run(_repo.signInWithGoogle);

  Future<bool> apple() => _run(_repo.signInWithApple);

  Future<bool> sendResetCode(String email) => _run(() => _repo.sendPasswordResetCode(email.trim()));

  Future<bool> verifyResetCode(String email, String token) =>
      _run(() => _repo.verifyResetCode(email: email.trim(), token: token.trim()));

  /// Validates against the reset rules before calling the backend.
  Future<bool> resetPassword(String password, String confirmation) => _run(() {
        validateResetPassword(password, confirmation);
        return _repo.updatePassword(password);
      });

  Future<bool> signOut() => _run(_repo.signOut);
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(AuthController.new);
