/// Thrown by any [AuthRepository] method on a recoverable auth error. The
/// [message] is safe to surface directly to the user.
class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;

  @override
  String toString() => 'AuthFailure: $message';
}

/// Backend-agnostic authentication contract. Method shapes intentionally mirror
/// Supabase GoTrue so `SupabaseAuthRepository` is a thin pass-through and
/// `FakeAuthRepository` can stand in for local dev and tests.
abstract interface class AuthRepository {
  /// Emits `true` when a session exists, `false` when signed out.
  Stream<bool> authStateChanges();

  bool get isSignedIn;

  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<void> signInWithApple();

  /// Sends a 6-digit recovery code to [email].
  Future<void> sendPasswordResetCode(String email);

  /// Verifies the recovery [token] sent to [email].
  Future<void> verifyResetCode({required String email, required String token});

  Future<void> updatePassword(String newPassword);

  Future<void> signOut();
}
