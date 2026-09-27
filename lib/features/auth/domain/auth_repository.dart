/// Backend-agnostic authentication contract. Every method throws an
/// `AppFailure` (usually `AuthFailure`, whose message is user-safe).
abstract interface class AuthRepository {
  /// Emits `true` when a session exists, `false` when signed out.
  Stream<bool> authStateChanges();

  bool get isSignedIn;

  Future<void> signInWithPassword({required String email, required String password});

  Future<void> signUp({required String name, required String email, required String password});

  Future<void> signInWithGoogle();

  Future<void> signInWithApple();

  /// Sends a 6-digit recovery code to [email].
  Future<void> sendPasswordResetCode(String email);

  /// Verifies the recovery [token] sent to [email].
  Future<void> verifyResetCode({required String email, required String token});

  Future<void> updatePassword(String newPassword);

  Future<void> signOut();
}
