import '../../../core/error/app_failure.dart';

/// Backend-agnostic authentication contract. Every method throws an
/// `AppFailure` (usually `AuthFailure`, whose message is user-safe).
abstract interface class AuthRepository {
  /// Emits `true` when a session exists, `false` when signed out.
  Stream<bool> authStateChanges();

  bool get isSignedIn;

  /// Failures of a browser sign-in (Google / Apple / Microsoft) that failed on the way back; they arrive after the
  /// starting call returned, so they can't be thrown from it.
  Stream<AppFailure> get callbackFailures;

  Future<void> signInWithPassword({required String email, required String password});

  Future<void> signUp({required String name, required String email, required String password});

  Future<void> signInWithGoogle();

  Future<void> signInWithApple();

  /// Microsoft work, school or personal account (Supabase "Azure").
  Future<void> signInWithMicrosoft();

  /// Sends a 6-digit recovery code to [email].
  Future<void> sendPasswordResetCode(String email);

  /// Verifies the recovery [token] sent to [email].
  Future<void> verifyResetCode({required String email, required String token});

  Future<void> updatePassword(String newPassword);

  Future<void> signOut();
}
