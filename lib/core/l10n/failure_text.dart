import '../error/app_failure.dart';
import 'l10n.dart';

/// Localized, user-facing text for any error. App-originated failures are
/// translated by [FailureReason]; server messages (no reason) pass through.
String localizeFailure(AppLocalizations l10n, Object error) {
  final failure = AppFailure.from(error);
  return switch (failure.reason) {
    null => failure.message,
    FailureReason.network => l10n.errorNetwork,
    FailureReason.unknown => l10n.errorUnknown,
    FailureReason.notSignedIn => l10n.errorNotSignedIn,
    FailureReason.nameRequired => l10n.errorNameRequired,
    FailureReason.roomNameRequired => l10n.errorRoomNameRequired,
    FailureReason.familyNameRequired => l10n.errorFamilyNameRequired,
    FailureReason.inviteCodeInvalid => l10n.errorInviteCodeInvalid,
    FailureReason.ownerRoleLocked => l10n.errorOwnerRoleLocked,
    FailureReason.ownerNotRemovable => l10n.errorOwnerNotRemovable,
    FailureReason.noActiveFamily => l10n.errorNoActiveFamily,
    FailureReason.familyRequired => l10n.errorFamilyRequired,
    FailureReason.joinedFamilyUnavailable => l10n.errorJoinedFamilyUnavailable,
    FailureReason.phoneFormat => l10n.errorPhoneFormat,
    FailureReason.termsRequired => l10n.errorTermsRequired,
    FailureReason.passwordRequirements => l10n.errorPasswordRequirements,
    FailureReason.passwordMismatch => l10n.errorPasswordMismatch,
    FailureReason.newPasswordTooShort => l10n.errorNewPasswordTooShort,
    FailureReason.currentPasswordIncorrect => l10n.errorCurrentPasswordIncorrect,
    FailureReason.offsetsRequired => l10n.errorOffsetsRequired,
    FailureReason.noAuthenticator => l10n.errorNoAuthenticator,
    FailureReason.totpUnavailable => l10n.errorTotpUnavailable,
    FailureReason.codeLength => l10n.errorCodeLength,
    FailureReason.uploadsFailed => l10n.errorUploadsFailed(failure.args[0] as int, failure.args[1] as int),
    FailureReason.filesUnavailable => l10n.errorFilesUnavailable,
    FailureReason.appOpenFailed => l10n.errorAppOpenFailed,
    FailureReason.notificationsBlocked => l10n.errorNotificationsBlocked,
    FailureReason.signInIncomplete => l10n.errorSignInIncomplete,
  };
}
