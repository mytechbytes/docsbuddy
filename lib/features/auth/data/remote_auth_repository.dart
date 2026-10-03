import '../../../core/data/supabase/supabase_guard.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/logging/app_logger.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

/// Auth over GoTrue. The data source is a thin SDK wrapper; this class owns input normalisation and error translation.
/// OAuth needs the providers enabled in the Supabase dashboard and a deep-link redirect per platform; the recovery-code
/// flow assumes email OTP is enabled.
class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(
    this._remote, {
    required this.redirectUrl,
    this._logger,
    this._callbackGrace = const Duration(seconds: 1),
  });

  final AuthRemoteDataSource _remote;
  final AppLogger? _logger;

  /// How long a callback error waits before it is believed (see [callbackFailures]).
  final Duration _callbackGrace;

  /// Where confirm-email / OAuth flows return to (the app's deep link).
  final String redirectUrl;

  @override
  Stream<bool> authStateChanges() => _remote.sessionChanges();

  @override
  bool get isSignedIn => _remote.hasSession;

  @override
  Stream<AppFailure> get callbackFailures async* {
    await for (final error in _remote.callbackErrors()) {
      // The hosted redirect page can deliver the same link twice and the second exchange always fails; wait for the
      // first to land and only report a failure if there is still no session.
      await Future<void>.delayed(_callbackGrace);
      if (isSignedIn) continue;
      _logger?.warning('Sign-in callback failed', error: error);
      yield isNetworkError(error)
          ? const NetworkFailure()
          : const AuthFailure('Sign-in didn’t finish. Please try again.', reason: FailureReason.signInIncomplete);
    }
  }

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
  Future<void> signInWithMicrosoft() =>
      guardBackend(() => _remote.signInWithOAuth(OAuthProviderKind.microsoft, redirectUrl));

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
