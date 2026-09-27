import '../../../core/data/supabase_guard.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

/// Auth over GoTrue. The data source is a thin SDK wrapper; this class owns
/// input normalisation and error translation (`guardBackend` maps GoTrue's
/// `AuthException` to a user-safe `AuthFailure`).
///
/// NOTE: OAuth (Google/Apple) additionally requires the providers to be enabled
/// in the Supabase dashboard and a deep-link redirect configured per platform;
/// the recovery-code flow assumes email OTP is enabled.
class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._remote, {required this.redirectUrl});

  final AuthRemoteDataSource _remote;

  /// Where confirm-email / OAuth flows return to (the app's deep link).
  final String redirectUrl;

  @override
  Stream<bool> authStateChanges() => _remote.sessionChanges();

  @override
  bool get isSignedIn => _remote.hasSession;

  @override
  Future<void> signInWithPassword({required String email, required String password}) =>
      guardBackend(() => _remote.signInWithPassword(email.trim(), password));

  @override
  Future<void> signUp({required String name, required String email, required String password}) =>
      guardBackend(() => _remote.signUp(
            email: email.trim(),
            password: password,
            fullName: name.trim(),
            // Sends the confirm-email link back into the app instead of the
            // project's Site URL (which defaults to http://localhost:3000).
            redirectTo: redirectUrl,
          ));

  @override
  Future<void> signInWithGoogle() => guardBackend(() => _remote.signInWithOAuth(OAuthProviderKind.google, redirectUrl));

  @override
  Future<void> signInWithApple() => guardBackend(() => _remote.signInWithOAuth(OAuthProviderKind.apple, redirectUrl));

  @override
  Future<void> sendPasswordResetCode(String email) => guardBackend(() => _remote.sendEmailOtp(email.trim()));

  @override
  Future<void> verifyResetCode({required String email, required String token}) =>
      guardBackend(() => _remote.verifyEmailOtp(email.trim(), token.trim()));

  @override
  Future<void> updatePassword(String newPassword) => guardBackend(() => _remote.updatePassword(newPassword));

  @override
  Future<void> signOut() => guardBackend(_remote.signOut);
}
