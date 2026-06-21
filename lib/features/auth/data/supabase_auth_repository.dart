import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import 'auth_repository.dart';

/// Real backend implementation, active when SUPABASE_URL + SUPABASE_ANON_KEY
/// are provided (see `core/config/env.dart`). A thin pass-through to GoTrue.
///
/// NOTE: OAuth (Google/Apple) additionally requires the providers to be enabled
/// in the Supabase dashboard and a deep-link redirect configured per platform;
/// the recovery-code flow assumes email OTP is enabled.
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      if (_isNetworkError(e)) {
        throw const AuthFailure('Can’t reach the server. Check your internet connection.');
      }
      throw const AuthFailure('Something went wrong. Please try again.');
    }
  }

  static bool _isNetworkError(Object e) {
    final s = e.toString();
    return s.contains('SocketException') ||
        s.contains('Failed host lookup') ||
        s.contains('ClientException') ||
        s.contains('Connection');
  }

  @override
  Stream<bool> authStateChanges() =>
      _auth.onAuthStateChange.map((state) => state.session != null);

  @override
  bool get isSignedIn => _auth.currentSession != null;

  @override
  Future<void> signInWithPassword({required String email, required String password}) =>
      _guard(() => _auth.signInWithPassword(email: email, password: password));

  @override
  Future<void> signUp({required String name, required String email, required String password}) =>
      _guard(() => _auth.signUp(
            email: email,
            password: password,
            data: {'full_name': name},
            // Sends the confirm-email link back into the app instead of the
            // project's Site URL (which defaults to http://localhost:3000).
            emailRedirectTo: Env.authRedirectUrl,
          ));

  @override
  Future<void> signInWithGoogle() =>
      _guard(() => _auth.signInWithOAuth(OAuthProvider.google, redirectTo: Env.authRedirectUrl));

  @override
  Future<void> signInWithApple() =>
      _guard(() => _auth.signInWithOAuth(OAuthProvider.apple, redirectTo: Env.authRedirectUrl));

  @override
  Future<void> sendPasswordResetCode(String email) =>
      _guard(() => _auth.signInWithOtp(email: email));

  @override
  Future<void> verifyResetCode({required String email, required String token}) =>
      _guard(() => _auth.verifyOTP(email: email, token: token, type: OtpType.email));

  @override
  Future<void> updatePassword(String newPassword) =>
      _guard(() => _auth.updateUser(UserAttributes(password: newPassword)));

  @override
  Future<void> signOut() => _guard(() => _auth.signOut());
}
