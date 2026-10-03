import 'package:supabase_flutter/supabase_flutter.dart';

import '../../error/app_failure.dart';

/// Runs a backend call and translates Supabase/transport exceptions into
/// [AppFailure]s, so nothing SDK-specific leaks past the data layer.
Future<T> guardBackend<T>(Future<T> Function() run) async {
  try {
    return await run();
  } on AppFailure {
    rethrow;
  } catch (e) {
    throw translateBackendError(e);
  }
}

/// The single translation from SDK exceptions to [AppFailure]. GoTrue's stable `code` becomes a
/// [FailureReason] so the message is localised; an unrecognised message passes through as the server wrote it.
AppFailure translateBackendError(Object e) {
  switch (e) {
    case AppFailure():
      return e;
    case AuthRetryableFetchException():
      return const NetworkFailure(); // transport trouble, not a verdict from the server
    case AuthSessionMissingException():
      return AuthFailure(e.message, reason: FailureReason.notSignedIn);
    case AuthException():
      return AuthFailure(e.message, reason: _authReason(e));
    case PostgrestException():
      return ServerFailure(e.message);
    case StorageException():
      return ServerFailure(e.message);
  }
  return isNetworkError(e) ? const NetworkFailure() : UnknownFailure(e);
}

FailureReason? _authReason(AuthException e) {
  final byCode = switch (e.code) {
    'invalid_credentials' => FailureReason.invalidCredentials,
    'email_not_confirmed' => FailureReason.emailNotConfirmed,
    'user_already_exists' || 'email_exists' => FailureReason.userExists,
    'weak_password' => FailureReason.weakPassword,
    'over_request_rate_limit' || 'over_email_send_rate_limit' || 'over_sms_send_rate_limit' => FailureReason.rateLimited,
    'otp_expired' => FailureReason.codeInvalid,
    'same_password' => FailureReason.samePassword,
    'session_expired' || 'session_not_found' || 'refresh_token_not_found' || 'bad_jwt' => FailureReason.notSignedIn,
    _ => null,
  };
  if (byCode != null) return byCode;
  if (e is AuthWeakPasswordException) return FailureReason.weakPassword;
  // Older servers answer without a code.
  return switch (e.message.toLowerCase()) {
    'invalid login credentials' => FailureReason.invalidCredentials,
    'user already registered' => FailureReason.userExists,
    'email not confirmed' => FailureReason.emailNotConfirmed,
    _ => null,
  };
}

/// Heuristic for socket/DNS/HTTP-client failures, which surface as several
/// unrelated exception types depending on platform.
bool isNetworkError(Object e) {
  final s = e.toString();
  return s.contains('SocketException') ||
      s.contains('Failed host lookup') ||
      s.contains('ClientException') ||
      s.contains('Connection');
}
