import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/password_policy.dart';
import '../../profile/application/profile_providers.dart';

/// Change password: validates the new password, verifies the current one by
/// re-authenticating, then updates it. `state` is the in-flight status; the
/// failure (an [AppFailure]) is stored in `state` and rethrown.
class ChangePasswordController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String current, required String fresh, required String confirmation}) async {
    state = const AsyncLoading();
    try {
      validateNewPassword(fresh, confirmation);
      final auth = ref.read(authRepositoryProvider);
      final email = ref.read(profileProvider).value?.email;
      if (email != null && email.isNotEmpty && current.isNotEmpty) {
        try {
          await auth.signInWithPassword(email: email, password: current);
        } on AuthFailure {
          throw const AuthFailure('Current password is incorrect.', reason: FailureReason.currentPasswordIncorrect);
        }
      }
      await auth.updatePassword(fresh);
      if (ref.mounted) state = const AsyncData(null);
    } catch (e, st) {
      final failure = AppFailure.from(e);
      if (ref.mounted) state = AsyncError(failure, st);
      throw failure;
    }
  }
}

final changePasswordControllerProvider =
    AsyncNotifierProvider.autoDispose<ChangePasswordController, void>(ChangePasswordController.new);
