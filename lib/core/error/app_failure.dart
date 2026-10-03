/// The single error type that crosses layers. Repositories translate backend exceptions into it, controllers keep
/// it in state, and widgets only read [message], which is always safe to show.
sealed class AppFailure implements Exception {
  const AppFailure(this.message, {this.reason, this.args = const []});

  /// English text; shown as-is when there is no [reason] (e.g. messages
  /// that come from the server).
  final String message;

  /// Stable code for app-originated failures, so the UI can show a
  /// localized message instead of [message].
  final FailureReason? reason;

  /// Values for the localized message (e.g. counts).
  final List<Object> args;

  /// Normalises any thrown object. Already-mapped failures pass through;
  /// anything else becomes an [UnknownFailure] (the cause is kept for logs).
  factory AppFailure.from(Object error) =>
      error is AppFailure ? error : UnknownFailure(error);

  @override
  String toString() => '$runtimeType: $message';
}

/// The device is offline or the server is unreachable.
final class NetworkFailure extends AppFailure {
  const NetworkFailure() : super('Can’t reach the server. Check your internet connection.', reason: FailureReason.network);
}

/// Sign-in/session problems (bad credentials, expired session, MFA).
final class AuthFailure extends AppFailure {
  const AuthFailure(super.message, {super.reason, super.args});
}

/// Input rejected before (or by) the backend — the message says what to fix.
final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, {super.reason, super.args});
}

/// The backend refused or failed the request; [message] comes from it.
final class ServerFailure extends AppFailure {
  const ServerFailure(super.message, {super.reason, super.args});
}

/// The capability needs a backend that isn't configured (e.g. file storage
/// in the offline build).
final class UnavailableFailure extends AppFailure {
  const UnavailableFailure(super.message, {super.reason, super.args});
}

/// Anything unexpected. [cause] is for diagnostics only — never shown.
final class UnknownFailure extends AppFailure {
  const UnknownFailure([this.cause]) : super('Something went wrong. Please try again.', reason: FailureReason.unknown);

  final Object? cause;
}

/// App-originated failure codes. The presentation layer maps each to a
/// localized message (`core/l10n/failure_text.dart`).
enum FailureReason {
  network,
  unknown,
  notSignedIn,
  nameRequired,
  roomNameRequired,
  familyNameRequired,
  inviteCodeInvalid,
  ownerRoleLocked,
  ownerNotRemovable,
  noActiveFamily,
  familyRequired,
  joinedFamilyUnavailable,
  phoneFormat,
  termsRequired,
  passwordRequirements,
  passwordMismatch,
  newPasswordTooShort,
  currentPasswordIncorrect,
  offsetsRequired,
  noAuthenticator,
  totpUnavailable,
  codeLength,
  uploadsFailed,
  filesUnavailable,
  appOpenFailed,
  notificationsBlocked,
  signInIncomplete,
  invalidCredentials,
  emailNotConfirmed,
  userExists,
  weakPassword,
  rateLimited,
  codeInvalid,
  samePassword,
}
