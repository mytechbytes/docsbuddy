import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get commonOn;

  /// No description provided for @commonOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get commonOff;

  /// No description provided for @commonEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get commonEmail;

  /// No description provided for @commonPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get commonPassword;

  /// No description provided for @commonEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get commonEmailHint;

  /// No description provided for @commonSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get commonSignIn;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @commonFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get commonFamily;

  /// No description provided for @commonNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get commonNotifications;

  /// No description provided for @commonChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get commonChangePassword;

  /// No description provided for @commonForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get commonForgotPassword;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get navRooms;

  /// No description provided for @navAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get navAssets;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep your assets and reminders in sync.'**
  String get authSignInSubtitle;

  /// No description provided for @authSignInCta.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignInCta;

  /// No description provided for @authNoAccountLead.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNoAccountLead;

  /// No description provided for @authSignUpAction.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUpAction;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authSignUpTitle;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track warranties, bills and renewals with your family — never miss a due date.'**
  String get authSignUpSubtitle;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get authFullNameHint;

  /// No description provided for @authCreateAccountCta.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccountCta;

  /// No description provided for @authHaveAccountLead.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccountLead;

  /// No description provided for @authTermsLead.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get authTermsLead;

  /// No description provided for @authTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get authTermsOfService;

  /// No description provided for @authTermsAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get authTermsAnd;

  /// No description provided for @authPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authPrivacyPolicy;

  /// No description provided for @authForgotSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get authForgotSendCode;

  /// No description provided for @authRememberLead.
  ///
  /// In en, this message translates to:
  /// **'Remember it? '**
  String get authRememberLead;

  /// No description provided for @authBackToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get authBackToSignIn;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}. Enter it below to continue.'**
  String authOtpSubtitle(String email);

  /// No description provided for @authOtpVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authOtpVerify;

  /// No description provided for @authOtpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive it? Resend in '**
  String get authOtpResendIn;

  /// No description provided for @authOtpNotReceivedLead.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive it? '**
  String get authOtpNotReceivedLead;

  /// No description provided for @authOtpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authOtpResend;

  /// No description provided for @authResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get authResetTitle;

  /// No description provided for @authNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authResetCta.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetCta;

  /// No description provided for @authPasswordMustHave.
  ///
  /// In en, this message translates to:
  /// **'Password must have'**
  String get authPasswordMustHave;

  /// No description provided for @authRuleLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get authRuleLength;

  /// No description provided for @authRuleUpper.
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter'**
  String get authRuleUpper;

  /// No description provided for @authRuleNumber.
  ///
  /// In en, this message translates to:
  /// **'One number'**
  String get authRuleNumber;

  /// No description provided for @authRuleSpecial.
  ///
  /// In en, this message translates to:
  /// **'One special character (!@#\$…)'**
  String get authRuleSpecial;

  /// No description provided for @authResetDone.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Please sign in.'**
  String get authResetDone;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// No description provided for @settingsPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get settingsPersonalInfo;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & 2FA'**
  String get settingsSecurity;

  /// No description provided for @settingsPush.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get settingsPush;

  /// No description provided for @settingsEmailReminders.
  ///
  /// In en, this message translates to:
  /// **'Email reminders'**
  String get settingsEmailReminders;

  /// No description provided for @settingsWhatsappReminders.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp reminders'**
  String get settingsWhatsappReminders;

  /// No description provided for @settingsDefaultOffsets.
  ///
  /// In en, this message translates to:
  /// **'Default offsets'**
  String get settingsDefaultOffsets;

  /// No description provided for @settingsQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get settingsQuietHours;

  /// No description provided for @settingsQuietHoursStart.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours start'**
  String get settingsQuietHoursStart;

  /// No description provided for @settingsQuietHoursEnd.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours end'**
  String get settingsQuietHoursEnd;

  /// No description provided for @settingsManageFamily.
  ///
  /// In en, this message translates to:
  /// **'Manage family'**
  String get settingsManageFamily;

  /// No description provided for @settingsMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String settingsMemberCount(int count);

  /// No description provided for @settingsSectionApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsSectionApp;

  /// No description provided for @settingsBackend.
  ///
  /// In en, this message translates to:
  /// **'Backend'**
  String get settingsBackend;

  /// No description provided for @settingsTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send test notification'**
  String get settingsTestNotification;

  /// No description provided for @settingsTestNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Sent a test notification.'**
  String get settingsTestNotificationSent;

  /// No description provided for @settingsNotificationsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked in system settings.'**
  String get settingsNotificationsBlocked;

  /// No description provided for @settingsPending.
  ///
  /// In en, this message translates to:
  /// **'What\'s pending'**
  String get settingsPending;

  /// No description provided for @settingsReplayOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Replay onboarding'**
  String get settingsReplayOnboarding;

  /// No description provided for @settingsOffsetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Default reminder offsets'**
  String get settingsOffsetsTitle;

  /// No description provided for @settingsOffsetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Days before a due date to notify — used for new reminders.'**
  String get settingsOffsetsSubtitle;

  /// No description provided for @settingsDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{days}d before'**
  String settingsDaysBefore(int days);

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get changePasswordCurrent;

  /// No description provided for @changePasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get changePasswordConfirm;

  /// No description provided for @changePasswordCta.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get changePasswordCta;

  /// No description provided for @changePasswordDone.
  ///
  /// In en, this message translates to:
  /// **'Password updated.'**
  String get changePasswordDone;

  /// No description provided for @authForgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No worries. Enter your email and we\'ll send you a 6-digit code to reset it.'**
  String get authForgotSubtitle;

  /// No description provided for @authResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password you haven\'t used here before.'**
  String get authResetSubtitle;

  /// No description provided for @changePasswordNotice.
  ///
  /// In en, this message translates to:
  /// **'For your security, you\'ll be signed out of other devices after changing your password.'**
  String get changePasswordNotice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
