// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonOn => 'On';

  @override
  String get commonOff => 'Off';

  @override
  String get commonEmail => 'Email';

  @override
  String get commonPassword => 'Password';

  @override
  String get commonEmailHint => 'you@example.com';

  @override
  String get commonSignIn => 'Sign in';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonFamily => 'Family';

  @override
  String get commonNotifications => 'Notifications';

  @override
  String get commonChangePassword => 'Change password';

  @override
  String get commonForgotPassword => 'Forgot password?';

  @override
  String get navHome => 'Home';

  @override
  String get navRooms => 'Rooms';

  @override
  String get navAssets => 'Assets';

  @override
  String get authSignInTitle => 'Welcome back';

  @override
  String get authSignInSubtitle =>
      'Sign in to keep your assets and reminders in sync.';

  @override
  String get authSignInCta => 'Sign In';

  @override
  String get authNoAccountLead => 'Don\'t have an account? ';

  @override
  String get authSignUpAction => 'Sign up';

  @override
  String get authOrContinueWith => 'or continue with';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authSignUpTitle => 'Create your account';

  @override
  String get authSignUpSubtitle =>
      'Track warranties, bills and renewals with your family — never miss a due date.';

  @override
  String get authFullName => 'Full Name';

  @override
  String get authFullNameHint => 'Your name';

  @override
  String get authCreateAccountCta => 'Create Account';

  @override
  String get authHaveAccountLead => 'Already have an account? ';

  @override
  String get authTermsLead => 'I agree to the ';

  @override
  String get authTermsOfService => 'Terms of Service';

  @override
  String get authTermsAnd => ' and ';

  @override
  String get authPrivacyPolicy => 'Privacy Policy';

  @override
  String get authForgotSendCode => 'Send Verification Code';

  @override
  String get authRememberLead => 'Remember it? ';

  @override
  String get authBackToSignIn => 'Back to sign in';

  @override
  String get authOtpTitle => 'Check your inbox';

  @override
  String authOtpSubtitle(String email) {
    return 'We sent a 6-digit code to $email. Enter it below to continue.';
  }

  @override
  String get authOtpVerify => 'Verify';

  @override
  String get authOtpResendIn => 'Didn\'t receive it? Resend in ';

  @override
  String get authOtpNotReceivedLead => 'Didn\'t receive it? ';

  @override
  String get authOtpResend => 'Resend code';

  @override
  String get authResetTitle => 'Set a new password';

  @override
  String get authNewPassword => 'New Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authResetCta => 'Reset Password';

  @override
  String get authPasswordMustHave => 'Password must have';

  @override
  String get authRuleLength => 'At least 8 characters';

  @override
  String get authRuleUpper => 'One uppercase letter';

  @override
  String get authRuleNumber => 'One number';

  @override
  String get authRuleSpecial => 'One special character (!@#\$…)';

  @override
  String get authResetDone => 'Password updated. Please sign in.';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsPersonalInfo => 'Personal information';

  @override
  String get settingsSecurity => 'Security & 2FA';

  @override
  String get settingsPush => 'Push notifications';

  @override
  String get settingsEmailReminders => 'Email reminders';

  @override
  String get settingsWhatsappReminders => 'WhatsApp reminders';

  @override
  String get settingsDefaultOffsets => 'Default offsets';

  @override
  String get settingsQuietHours => 'Quiet hours';

  @override
  String get settingsQuietHoursStart => 'Quiet hours start';

  @override
  String get settingsQuietHoursEnd => 'Quiet hours end';

  @override
  String get settingsManageFamily => 'Manage family';

  @override
  String settingsMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get settingsSectionApp => 'App';

  @override
  String get settingsBackend => 'Backend';

  @override
  String get settingsTestNotification => 'Send test notification';

  @override
  String get settingsTestNotificationSent => 'Sent a test notification.';

  @override
  String get settingsNotificationsBlocked =>
      'Notifications are blocked in system settings.';

  @override
  String get settingsPending => 'What\'s pending';

  @override
  String get settingsReplayOnboarding => 'Replay onboarding';

  @override
  String get settingsOffsetsTitle => 'Default reminder offsets';

  @override
  String get settingsOffsetsSubtitle =>
      'Days before a due date to notify — used for new reminders.';

  @override
  String settingsDaysBefore(int days) {
    return '${days}d before';
  }

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordCurrent => 'Current Password';

  @override
  String get changePasswordConfirm => 'Confirm New Password';

  @override
  String get changePasswordCta => 'Update Password';

  @override
  String get changePasswordDone => 'Password updated.';

  @override
  String get authForgotSubtitle =>
      'No worries. Enter your email and we\'ll send you a 6-digit code to reset it.';

  @override
  String get authResetSubtitle =>
      'Choose a strong password you haven\'t used here before.';

  @override
  String get changePasswordNotice =>
      'For your security, you\'ll be signed out of other devices after changing your password.';
}
