/// The single error type that crosses layer boundaries.
///
/// Repositories translate backend/platform exceptions into an [AppFailure];
/// controllers surface it in their state; widgets only read [message], which
/// is always safe to show to the user.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  /// Normalises any thrown object. Already-mapped failures pass through;
  /// anything else becomes an [UnknownFailure] (the cause is kept for logs).
  factory AppFailure.from(Object error) =>
      error is AppFailure ? error : UnknownFailure(error);

  @override
  String toString() => '$runtimeType: $message';
}

/// The device is offline or the server is unreachable.
final class NetworkFailure extends AppFailure {
  const NetworkFailure() : super('Can’t reach the server. Check your internet connection.');
}

/// Sign-in/session problems (bad credentials, expired session, MFA).
final class AuthFailure extends AppFailure {
  const AuthFailure(super.message);
}

/// Input rejected before (or by) the backend — the message says what to fix.
final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

/// The backend refused or failed the request; [message] comes from it.
final class ServerFailure extends AppFailure {
  const ServerFailure(super.message);
}

/// The capability needs a backend that isn't configured (e.g. file storage
/// in the offline build).
final class UnavailableFailure extends AppFailure {
  const UnavailableFailure(super.message);
}

/// Anything unexpected. [cause] is for diagnostics only — never shown.
final class UnknownFailure extends AppFailure {
  const UnknownFailure([this.cause]) : super('Something went wrong. Please try again.');

  final Object? cause;
}
