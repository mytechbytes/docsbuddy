import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_zh.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('zh'),
  ];

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

  /// No description provided for @authTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get authTermsOfService;

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
  /// **'Didn\'t receive it? Resend in {time}'**
  String authOtpResendIn(String time);

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

  /// No description provided for @settingsRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Roadmap'**
  String get settingsRoadmap;

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

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Can’t reach the server. Check your internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'You’re signed out. Please sign in again.'**
  String get errorNotSignedIn;

  /// No description provided for @errorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name.'**
  String get errorNameRequired;

  /// No description provided for @errorRoomNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please name the room.'**
  String get errorRoomNameRequired;

  /// No description provided for @errorFamilyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a family name.'**
  String get errorFamilyNameRequired;

  /// No description provided for @errorInviteCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid invite code.'**
  String get errorInviteCodeInvalid;

  /// No description provided for @errorOwnerRoleLocked.
  ///
  /// In en, this message translates to:
  /// **'The owner\'s role can\'t be changed.'**
  String get errorOwnerRoleLocked;

  /// No description provided for @errorOwnerNotRemovable.
  ///
  /// In en, this message translates to:
  /// **'The owner can\'t be removed.'**
  String get errorOwnerNotRemovable;

  /// No description provided for @errorNoActiveFamily.
  ///
  /// In en, this message translates to:
  /// **'No active family.'**
  String get errorNoActiveFamily;

  /// No description provided for @errorFamilyRequired.
  ///
  /// In en, this message translates to:
  /// **'Join or create a family first.'**
  String get errorFamilyRequired;

  /// No description provided for @errorJoinedFamilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not load the joined family.'**
  String get errorJoinedFamilyUnavailable;

  /// No description provided for @errorPhoneFormat.
  ///
  /// In en, this message translates to:
  /// **'Use the international format, e.g. +91 9812345678.'**
  String get errorPhoneFormat;

  /// No description provided for @errorTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms to continue.'**
  String get errorTermsRequired;

  /// No description provided for @errorPasswordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Please meet the password requirements.'**
  String get errorPasswordRequirements;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get errorPasswordMismatch;

  /// No description provided for @errorNewPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 8 characters.'**
  String get errorNewPasswordTooShort;

  /// No description provided for @errorCurrentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect.'**
  String get errorCurrentPasswordIncorrect;

  /// No description provided for @errorOffsetsRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one reminder offset.'**
  String get errorOffsetsRequired;

  /// No description provided for @errorNoAuthenticator.
  ///
  /// In en, this message translates to:
  /// **'No authenticator enrolled.'**
  String get errorNoAuthenticator;

  /// No description provided for @errorTotpUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Authenticator setup is unavailable right now.'**
  String get errorTotpUnavailable;

  /// No description provided for @errorCodeLength.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code.'**
  String get errorCodeLength;

  /// No description provided for @errorUploadsFailed.
  ///
  /// In en, this message translates to:
  /// **'{failed} of {total} uploads failed.'**
  String errorUploadsFailed(int failed, int total);

  /// No description provided for @errorFilesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Connect a backend to open or share files.'**
  String get errorFilesUnavailable;

  /// No description provided for @errorAppOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open that app.'**
  String get errorAppOpenFailed;

  /// No description provided for @errorNotificationsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked in system settings.'**
  String get errorNotificationsBlocked;

  /// No description provided for @errorSignInIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Sign-in didn’t finish. Please try again.'**
  String get errorSignInIncomplete;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get commonOptional;

  /// No description provided for @commonNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches.'**
  String get commonNoMatches;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get commonView;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @durationDaysShort.
  ///
  /// In en, this message translates to:
  /// **'{days}d'**
  String durationDaysShort(int days);

  /// No description provided for @kindInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get kindInsurance;

  /// No description provided for @kindPollution.
  ///
  /// In en, this message translates to:
  /// **'Pollution'**
  String get kindPollution;

  /// No description provided for @kindAmc.
  ///
  /// In en, this message translates to:
  /// **'AMC'**
  String get kindAmc;

  /// No description provided for @kindService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get kindService;

  /// No description provided for @kindTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get kindTax;

  /// No description provided for @kindWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get kindWarranty;

  /// No description provided for @kindRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get kindRegistration;

  /// No description provided for @kindFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get kindFitness;

  /// No description provided for @kindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get kindOther;

  /// No description provided for @groupVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get groupVehicle;

  /// No description provided for @groupAppliance.
  ///
  /// In en, this message translates to:
  /// **'Appliance'**
  String get groupAppliance;

  /// No description provided for @groupElectronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get groupElectronics;

  /// No description provided for @groupDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get groupDocument;

  /// No description provided for @groupOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get groupOther;

  /// No description provided for @recurrenceNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get recurrenceNone;

  /// No description provided for @recurrenceNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get recurrenceNever;

  /// No description provided for @recurrenceMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurrenceMonthly;

  /// No description provided for @recurrenceQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get recurrenceQuarterly;

  /// No description provided for @recurrenceHalfYearly.
  ///
  /// In en, this message translates to:
  /// **'Half-yearly'**
  String get recurrenceHalfYearly;

  /// No description provided for @recurrenceYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get recurrenceYearly;

  /// No description provided for @dueOverdueBy.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Overdue by 1 day} other{Overdue by {days} days}}'**
  String dueOverdueBy(int days);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @dueDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day left} other{{days} days left}}'**
  String dueDaysLeft(int days);

  /// No description provided for @relativeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String relativeDaysAgo(int days);

  /// No description provided for @relativeInDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{in 1 day} other{in {days} days}}'**
  String relativeInDays(int days);

  /// No description provided for @pillOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get pillOverdue;

  /// No description provided for @pillToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get pillToday;

  /// No description provided for @catalogAddAsset.
  ///
  /// In en, this message translates to:
  /// **'Add asset'**
  String get catalogAddAsset;

  /// No description provided for @catalogEditAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit asset'**
  String get catalogEditAsset;

  /// No description provided for @catalogDeleteAsset.
  ///
  /// In en, this message translates to:
  /// **'Delete asset'**
  String get catalogDeleteAsset;

  /// No description provided for @catalogSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get catalogSaveChanges;

  /// No description provided for @catalogSaveAsset.
  ///
  /// In en, this message translates to:
  /// **'Save asset'**
  String get catalogSaveAsset;

  /// No description provided for @catalogCustomTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom appliance type'**
  String get catalogCustomTypeTitle;

  /// No description provided for @catalogCustomTypeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dishwasher, Inverter, Camera…'**
  String get catalogCustomTypeHint;

  /// No description provided for @catalogUseType.
  ///
  /// In en, this message translates to:
  /// **'Use type'**
  String get catalogUseType;

  /// No description provided for @catalogChooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get catalogChooseCategory;

  /// No description provided for @catalogChooseCategorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'What kind of thing are you adding?'**
  String get catalogChooseCategorySubtitle;

  /// No description provided for @catalogSelectAppliance.
  ///
  /// In en, this message translates to:
  /// **'Select your appliance'**
  String get catalogSelectAppliance;

  /// No description provided for @catalogNoPresetTypes.
  ///
  /// In en, this message translates to:
  /// **'No preset types for {group} — use a custom type or skip.'**
  String catalogNoPresetTypes(String group);

  /// No description provided for @catalogTypesIn.
  ///
  /// In en, this message translates to:
  /// **'Types in {group}; pick one or add your own.'**
  String catalogTypesIn(String group);

  /// No description provided for @catalogOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get catalogOthers;

  /// No description provided for @catalogDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get catalogDetails;

  /// No description provided for @catalogOnlyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Only the name is required.'**
  String get catalogOnlyNameRequired;

  /// No description provided for @catalogName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get catalogName;

  /// No description provided for @catalogNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Samsung 340L Fridge'**
  String get catalogNameHint;

  /// No description provided for @catalogRoomOptional.
  ///
  /// In en, this message translates to:
  /// **'Room (optional)'**
  String get catalogRoomOptional;

  /// No description provided for @catalogNewRoomHint.
  ///
  /// In en, this message translates to:
  /// **'New room name — e.g. Kitchen'**
  String get catalogNewRoomHint;

  /// No description provided for @catalogBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get catalogBrand;

  /// No description provided for @catalogModelNumber.
  ///
  /// In en, this message translates to:
  /// **'Model number'**
  String get catalogModelNumber;

  /// No description provided for @catalogSerialNo.
  ///
  /// In en, this message translates to:
  /// **'Serial / registration no.'**
  String get catalogSerialNo;

  /// No description provided for @catalogSerialHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. TN 01 AB 1234'**
  String get catalogSerialHint;

  /// No description provided for @catalogPurchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get catalogPurchaseDate;

  /// No description provided for @catalogPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase price'**
  String get catalogPurchasePrice;

  /// No description provided for @catalogPriceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 42000'**
  String get catalogPriceHint;

  /// No description provided for @catalogStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get catalogStore;

  /// No description provided for @catalogStoreHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Croma'**
  String get catalogStoreHint;

  /// No description provided for @catalogDetailsFor.
  ///
  /// In en, this message translates to:
  /// **'Details for {name}'**
  String catalogDetailsFor(String name);

  /// No description provided for @catalogThisAppliance.
  ///
  /// In en, this message translates to:
  /// **'this appliance'**
  String get catalogThisAppliance;

  /// No description provided for @catalogPropertyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Colour'**
  String get catalogPropertyHint;

  /// No description provided for @catalogValueHint.
  ///
  /// In en, this message translates to:
  /// **'value'**
  String get catalogValueHint;

  /// No description provided for @catalogAddProperty.
  ///
  /// In en, this message translates to:
  /// **'Add property'**
  String get catalogAddProperty;

  /// No description provided for @catalogAmcDate.
  ///
  /// In en, this message translates to:
  /// **'AMC date'**
  String get catalogAmcDate;

  /// No description provided for @catalogInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices / receipts'**
  String get catalogInvoices;

  /// No description provided for @catalogAttachInvoice.
  ///
  /// In en, this message translates to:
  /// **'Attach invoice — camera, gallery or files'**
  String get catalogAttachInvoice;

  /// No description provided for @catalogWillAutoAdd.
  ///
  /// In en, this message translates to:
  /// **'Will auto-add: {services}'**
  String catalogWillAutoAdd(String services);

  /// No description provided for @catalogSelectYourAppliance.
  ///
  /// In en, this message translates to:
  /// **'Select Your Appliance'**
  String get catalogSelectYourAppliance;

  /// No description provided for @catalogSearchAppliance.
  ///
  /// In en, this message translates to:
  /// **'Search Your Appliance'**
  String get catalogSearchAppliance;

  /// No description provided for @catalogNoMatchingAppliance.
  ///
  /// In en, this message translates to:
  /// **'No matching appliance — use \"Something else\" below.'**
  String get catalogNoMatchingAppliance;

  /// No description provided for @catalogSomethingElse.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get catalogSomethingElse;

  /// No description provided for @catalogAllReminders.
  ///
  /// In en, this message translates to:
  /// **'All Reminders · {count}'**
  String catalogAllReminders(int count);

  /// No description provided for @catalogNoRemindersForAsset.
  ///
  /// In en, this message translates to:
  /// **'No reminders for this asset yet.'**
  String get catalogNoRemindersForAsset;

  /// No description provided for @catalogMarkDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as done?'**
  String get catalogMarkDoneTitle;

  /// No description provided for @catalogMarkDoneOneOff.
  ///
  /// In en, this message translates to:
  /// **'“{label}” will be completed and removed from upcoming reminders.'**
  String catalogMarkDoneOneOff(String label);

  /// No description provided for @catalogMarkDoneRecurring.
  ///
  /// In en, this message translates to:
  /// **'“{label}” will be completed and its next due date scheduled ({recurrence}).'**
  String catalogMarkDoneRecurring(String label, String recurrence);

  /// No description provided for @catalogMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get catalogMarkDone;

  /// No description provided for @catalogMarkedDone.
  ///
  /// In en, this message translates to:
  /// **'{label} marked as done.'**
  String catalogMarkedDone(String label);

  /// No description provided for @catalogDoneRescheduled.
  ///
  /// In en, this message translates to:
  /// **'{label} done — next due date scheduled.'**
  String catalogDoneRescheduled(String label);

  /// No description provided for @catalogDeleteReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete reminder?'**
  String get catalogDeleteReminderTitle;

  /// No description provided for @catalogDeleteReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'“{label}” and its scheduled notifications will be removed.'**
  String catalogDeleteReminderMessage(String label);

  /// No description provided for @catalogDeleteAssetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete asset?'**
  String get catalogDeleteAssetTitle;

  /// No description provided for @catalogDeleteAssetMessage.
  ///
  /// In en, this message translates to:
  /// **'“{name}” and all its reminders and documents will be removed. This can\'t be undone.'**
  String catalogDeleteAssetMessage(String name);

  /// No description provided for @catalogNoAssets.
  ///
  /// In en, this message translates to:
  /// **'No assets yet. Tap “Add asset”.'**
  String get catalogNoAssets;

  /// No description provided for @catalogRoomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found.'**
  String get catalogRoomNotFound;

  /// No description provided for @catalogAddRoomPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a room photo'**
  String get catalogAddRoomPhoto;

  /// No description provided for @catalogApplianceCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 appliance} other{{count} appliances}}'**
  String catalogApplianceCount(int count);

  /// No description provided for @catalogAppliances.
  ///
  /// In en, this message translates to:
  /// **'Appliances'**
  String get catalogAppliances;

  /// No description provided for @catalogNothingRegistered.
  ///
  /// In en, this message translates to:
  /// **'Nothing registered here yet.'**
  String get catalogNothingRegistered;

  /// No description provided for @catalogAddHere.
  ///
  /// In en, this message translates to:
  /// **'Add here'**
  String get catalogAddHere;

  /// No description provided for @catalogRenameRoom.
  ///
  /// In en, this message translates to:
  /// **'Rename room'**
  String get catalogRenameRoom;

  /// No description provided for @catalogSince.
  ///
  /// In en, this message translates to:
  /// **'since {date}'**
  String catalogSince(String date);

  /// No description provided for @catalogNoRemindersOnAppliance.
  ///
  /// In en, this message translates to:
  /// **'No reminders on this appliance yet.'**
  String get catalogNoRemindersOnAppliance;

  /// No description provided for @catalogCreateRoom.
  ///
  /// In en, this message translates to:
  /// **'Create room'**
  String get catalogCreateRoom;

  /// No description provided for @catalogNoRooms.
  ///
  /// In en, this message translates to:
  /// **'No rooms yet. Add your first room above.'**
  String get catalogNoRooms;

  /// No description provided for @catalogAddRoomPhotoLong.
  ///
  /// In en, this message translates to:
  /// **'Add a room photo — camera or device'**
  String get catalogAddRoomPhotoLong;

  /// No description provided for @catalogRoomNameHint.
  ///
  /// In en, this message translates to:
  /// **'Room name — e.g. Kitchen'**
  String get catalogRoomNameHint;

  /// No description provided for @catalogAddNewRoom.
  ///
  /// In en, this message translates to:
  /// **'Add a new room'**
  String get catalogAddNewRoom;

  /// No description provided for @catalogRegisteredCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Registered'**
  String catalogRegisteredCount(int count);

  /// No description provided for @catalogSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search assets, services, policy numbers…'**
  String get catalogSearchHint;

  /// No description provided for @catalogSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Type to search your assets and reminders.'**
  String get catalogSearchEmpty;

  /// No description provided for @catalogReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get catalogReminders;

  /// No description provided for @catalogDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get catalogDue;

  /// No description provided for @catalogOneOff.
  ///
  /// In en, this message translates to:
  /// **'One-off'**
  String get catalogOneOff;

  /// No description provided for @catalogReminds.
  ///
  /// In en, this message translates to:
  /// **'Reminds'**
  String get catalogReminds;

  /// No description provided for @catalogProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get catalogProvider;

  /// No description provided for @catalogPolicyContract.
  ///
  /// In en, this message translates to:
  /// **'Policy / contract'**
  String get catalogPolicyContract;

  /// No description provided for @catalogCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get catalogCost;

  /// No description provided for @catalogNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get catalogNotes;

  /// No description provided for @catalogServiceDocuments.
  ///
  /// In en, this message translates to:
  /// **'DOCUMENTS FOR THIS SERVICE'**
  String get catalogServiceDocuments;

  /// No description provided for @catalogRemindersTracked.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reminder tracked} other{{count} reminders tracked}}'**
  String catalogRemindersTracked(int count);

  /// No description provided for @catalogHideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide details'**
  String get catalogHideDetails;

  /// No description provided for @catalogShowDetails.
  ///
  /// In en, this message translates to:
  /// **'Show all details'**
  String get catalogShowDetails;

  /// No description provided for @catalogType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get catalogType;

  /// No description provided for @catalogCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get catalogCategory;

  /// No description provided for @catalogRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get catalogRoom;

  /// No description provided for @catalogModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get catalogModel;

  /// No description provided for @catalogSerialShort.
  ///
  /// In en, this message translates to:
  /// **'Serial / reg. no.'**
  String get catalogSerialShort;

  /// No description provided for @catalogRemindersTrackedLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminders tracked'**
  String get catalogRemindersTrackedLabel;

  /// No description provided for @catalogNextDue.
  ///
  /// In en, this message translates to:
  /// **'NEXT DUE'**
  String get catalogNextDue;

  /// No description provided for @catalogRemindsOffsets.
  ///
  /// In en, this message translates to:
  /// **'Reminds {offsets}'**
  String catalogRemindsOffsets(String offsets);

  /// No description provided for @catalogMarkAsDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get catalogMarkAsDone;

  /// No description provided for @catalogNoRoomHint.
  ///
  /// In en, this message translates to:
  /// **'No room — you can set one later'**
  String get catalogNoRoomHint;

  /// No description provided for @catalogNoRoom.
  ///
  /// In en, this message translates to:
  /// **'No room'**
  String get catalogNoRoom;

  /// No description provided for @catalogNewRoom.
  ///
  /// In en, this message translates to:
  /// **'New room…'**
  String get catalogNewRoom;

  /// No description provided for @catalogAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get catalogAddPhoto;

  /// No description provided for @dashboardFilterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get dashboardFilterByType;

  /// No description provided for @dashboardUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Expirations'**
  String get dashboardUpcoming;

  /// No description provided for @dashboardGroupBy.
  ///
  /// In en, this message translates to:
  /// **'Group by'**
  String get dashboardGroupBy;

  /// No description provided for @dashboardGroupNone.
  ///
  /// In en, this message translates to:
  /// **'Group by: None'**
  String get dashboardGroupNone;

  /// No description provided for @dashboardGroupAsset.
  ///
  /// In en, this message translates to:
  /// **'Group by: Asset'**
  String get dashboardGroupAsset;

  /// No description provided for @dashboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet. Add an asset to get started.'**
  String get dashboardEmpty;

  /// No description provided for @dashboardNoMatches.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches the selected types.'**
  String get dashboardNoMatches;

  /// No description provided for @dashboardAsset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get dashboardAsset;

  /// No description provided for @dashboardTotalAppliances.
  ///
  /// In en, this message translates to:
  /// **'Total Active Appliances'**
  String get dashboardTotalAppliances;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active Services'**
  String get filterActive;

  /// No description provided for @filterSecured.
  ///
  /// In en, this message translates to:
  /// **'Secured'**
  String get filterSecured;

  /// No description provided for @filterSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get filterSoon;

  /// No description provided for @filterExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get filterExpired;

  /// No description provided for @docsTitle.
  ///
  /// In en, this message translates to:
  /// **'DOCUMENTS'**
  String get docsTitle;

  /// No description provided for @docsAdd.
  ///
  /// In en, this message translates to:
  /// **'+ Add'**
  String get docsAdd;

  /// No description provided for @docsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No documents yet. Attach invoices, warranties or photos.'**
  String get docsEmpty;

  /// No description provided for @docsImageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load image'**
  String get docsImageLoadFailed;

  /// No description provided for @docKindInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get docKindInvoice;

  /// No description provided for @docKindWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get docKindWarranty;

  /// No description provided for @docKindInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get docKindInsurance;

  /// No description provided for @docKindManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get docKindManual;

  /// No description provided for @docKindPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get docKindPhoto;

  /// No description provided for @docKindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docKindOther;

  /// No description provided for @familyCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a family'**
  String get familyCreateTitle;

  /// No description provided for @familyNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Kumar Family'**
  String get familyNameHint;

  /// No description provided for @familyJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join a family'**
  String get familyJoinTitle;

  /// No description provided for @familyInviteCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Invite code (e.g. AB12CD34)'**
  String get familyInviteCodeHint;

  /// No description provided for @familyJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get familyJoin;

  /// No description provided for @familyJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined! Family rooms, assets and reminders are syncing.'**
  String get familyJoined;

  /// No description provided for @familyChangeRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Change role — {name}'**
  String familyChangeRoleTitle(String name);

  /// No description provided for @familyRoleAdminHint.
  ///
  /// In en, this message translates to:
  /// **'Manage members, assets and invites'**
  String get familyRoleAdminHint;

  /// No description provided for @familyRoleViewerHint.
  ///
  /// In en, this message translates to:
  /// **'Read-only access'**
  String get familyRoleViewerHint;

  /// No description provided for @familyRoleMemberHint.
  ///
  /// In en, this message translates to:
  /// **'Add and manage own assets'**
  String get familyRoleMemberHint;

  /// No description provided for @familyRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove member?'**
  String get familyRemoveTitle;

  /// No description provided for @familyRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} will lose access to this family’s assets and reminders.'**
  String familyRemoveMessage(String name);

  /// No description provided for @familyRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get familyRemove;

  /// No description provided for @familyLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave family?'**
  String get familyLeaveTitle;

  /// No description provided for @familyLeaveMessage.
  ///
  /// In en, this message translates to:
  /// **'You will stop receiving this family’s reminders.'**
  String get familyLeaveMessage;

  /// No description provided for @familyLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get familyLeave;

  /// No description provided for @familyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re not in a family yet'**
  String get familyEmptyTitle;

  /// No description provided for @familyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create a family to share assets and reminders, or join one with an invite code.'**
  String get familyEmptyBody;

  /// No description provided for @familyJoinWithCode.
  ///
  /// In en, this message translates to:
  /// **'Join with a code'**
  String get familyJoinWithCode;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'MEMBERS'**
  String get familyMembers;

  /// No description provided for @familyInviteMember.
  ///
  /// In en, this message translates to:
  /// **'Invite member'**
  String get familyInviteMember;

  /// No description provided for @familyLeaveFamily.
  ///
  /// In en, this message translates to:
  /// **'Leave family'**
  String get familyLeaveFamily;

  /// No description provided for @familyCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get familyCall;

  /// No description provided for @familyWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get familyWhatsapp;

  /// No description provided for @familyChangeRole.
  ///
  /// In en, this message translates to:
  /// **'Change role'**
  String get familyChangeRole;

  /// No description provided for @familyRemoveFromFamily.
  ///
  /// In en, this message translates to:
  /// **'Remove from family'**
  String get familyRemoveFromFamily;

  /// No description provided for @familyInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite a member'**
  String get familyInviteTitle;

  /// No description provided for @familyInviteBody.
  ///
  /// In en, this message translates to:
  /// **'Share this code. They can join as {role}. Expires in 7 days.'**
  String familyInviteBody(String role);

  /// No description provided for @familyCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get familyCopyCode;

  /// No description provided for @familyCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied'**
  String get familyCodeCopied;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// No description provided for @roleViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get roleViewer;

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String memberCount(int count);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get profileVerified;

  /// No description provided for @profileEditInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit personal info'**
  String get profileEditInfo;

  /// No description provided for @profileNotificationPrefs.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get profileNotificationPrefs;

  /// No description provided for @profileManagedInSettings.
  ///
  /// In en, this message translates to:
  /// **'Managed in Settings'**
  String get profileManagedInSettings;

  /// No description provided for @profileDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayName;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone (for WhatsApp reminders)'**
  String get profilePhone;

  /// No description provided for @profileDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get profileDocuments;

  /// No description provided for @profileInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get profileInvite;

  /// No description provided for @reminderAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get reminderAddTitle;

  /// No description provided for @reminderEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Reminder'**
  String get reminderEditTitle;

  /// No description provided for @reminderSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get reminderSaveChanges;

  /// No description provided for @reminderSave.
  ///
  /// In en, this message translates to:
  /// **'Save Reminder'**
  String get reminderSave;

  /// No description provided for @reminderTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder type'**
  String get reminderTypeTitle;

  /// No description provided for @reminderTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What should we track?'**
  String get reminderTypeSubtitle;

  /// No description provided for @reminderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'{kind} details'**
  String reminderDetailsTitle(String kind);

  /// No description provided for @reminderDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When is it due?'**
  String get reminderDetailsSubtitle;

  /// No description provided for @reminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get reminderLabel;

  /// No description provided for @reminderDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get reminderDueDate;

  /// No description provided for @reminderRepeats.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get reminderRepeats;

  /// No description provided for @reminderServiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service details (optional)'**
  String get reminderServiceDetails;

  /// No description provided for @reminderProviderHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Acko'**
  String get reminderProviderHint;

  /// No description provided for @reminderPolicyNo.
  ///
  /// In en, this message translates to:
  /// **'Policy / contract no.'**
  String get reminderPolicyNo;

  /// No description provided for @reminderCostHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 4200'**
  String get reminderCostHint;

  /// No description provided for @reminderNotifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get reminderNotifyTitle;

  /// No description provided for @reminderNotifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push notification & reminder to all family members.'**
  String get reminderNotifySubtitle;

  /// No description provided for @reminderNotifyMe.
  ///
  /// In en, this message translates to:
  /// **'Notify me'**
  String get reminderNotifyMe;

  /// No description provided for @reminderNoOffsets.
  ///
  /// In en, this message translates to:
  /// **'No reminders will fire for this service — pick at least one offset to be notified.'**
  String get reminderNoOffsets;

  /// No description provided for @reminderOffsetsSummary.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be reminded {offsets} before the due date, on your enabled channels (see Settings).'**
  String reminderOffsetsSummary(String offsets);

  /// No description provided for @reminderAttachTitle.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get reminderAttachTitle;

  /// No description provided for @reminderAttachSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Policy PDF, receipt, photos… attach now or later from the asset page.'**
  String get reminderAttachSubtitle;

  /// No description provided for @reminderAttachDocs.
  ///
  /// In en, this message translates to:
  /// **'Attach documents — camera, gallery or files'**
  String get reminderAttachDocs;

  /// No description provided for @remindersEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here right now.'**
  String get remindersEmpty;

  /// No description provided for @inboxAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up 🎉'**
  String get inboxAllCaughtUp;

  /// No description provided for @inboxOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get inboxOverdue;

  /// No description provided for @inboxComingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get inboxComingUp;

  /// No description provided for @inboxDueIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Due in 1 day — {date}} other{Due in {days} days — {date}}}'**
  String inboxDueIn(int days, String date);

  /// No description provided for @lockLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get lockLocked;

  /// No description provided for @lockTapToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Tap to unlock'**
  String get lockTapToUnlock;

  /// No description provided for @mfaTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-factor verification'**
  String get mfaTitle;

  /// No description provided for @mfaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app.'**
  String get mfaSubtitle;

  /// No description provided for @mfaCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get mfaCodeLabel;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityTitle;

  /// No description provided for @securityBiometricSection.
  ///
  /// In en, this message translates to:
  /// **'Biometric login'**
  String get securityBiometricSection;

  /// No description provided for @securityUnlockBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics'**
  String get securityUnlockBiometrics;

  /// No description provided for @securityNoBiometrics.
  ///
  /// In en, this message translates to:
  /// **'No biometrics available on this device'**
  String get securityNoBiometrics;

  /// No description provided for @securityTwoFactorSection.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get securityTwoFactorSection;

  /// No description provided for @security2faEnabled.
  ///
  /// In en, this message translates to:
  /// **'2FA is enabled'**
  String get security2faEnabled;

  /// No description provided for @securityEnable2fa.
  ///
  /// In en, this message translates to:
  /// **'Enable 2FA'**
  String get securityEnable2fa;

  /// No description provided for @securityAuthenticatorApp.
  ///
  /// In en, this message translates to:
  /// **'Authenticator app'**
  String get securityAuthenticatorApp;

  /// No description provided for @securityAuthenticatorSince.
  ///
  /// In en, this message translates to:
  /// **'Authenticator app · since {date}'**
  String securityAuthenticatorSince(String date);

  /// No description provided for @securityAuthenticatorHint.
  ///
  /// In en, this message translates to:
  /// **'Use Google Authenticator, Authy, 1Password, etc.'**
  String get securityAuthenticatorHint;

  /// No description provided for @securityMoreSection.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get securityMoreSection;

  /// No description provided for @securityAppLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get securityAppLock;

  /// No description provided for @securityAppLockHint.
  ///
  /// In en, this message translates to:
  /// **'Require unlock when reopening the app'**
  String get securityAppLockHint;

  /// No description provided for @securityAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock after'**
  String get securityAutoLock;

  /// No description provided for @securityMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String securityMinutesShort(int minutes);

  /// No description provided for @securityMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute} other{{minutes} minutes}}'**
  String securityMinutes(int minutes);

  /// No description provided for @securityActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'Active sessions'**
  String get securityActiveSessions;

  /// No description provided for @securityDisable2faTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable 2FA?'**
  String get securityDisable2faTitle;

  /// No description provided for @securityDisable2faMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account will no longer require an authenticator code to sign in.'**
  String get securityDisable2faMessage;

  /// No description provided for @securityDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get securityDisable;

  /// No description provided for @securityCurrentSession.
  ///
  /// In en, this message translates to:
  /// **'Current session'**
  String get securityCurrentSession;

  /// No description provided for @securitySignedInAt.
  ///
  /// In en, this message translates to:
  /// **'Signed in {date}'**
  String securitySignedInAt(String date);

  /// No description provided for @securityThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get securityThisDevice;

  /// No description provided for @securitySignOutOthers.
  ///
  /// In en, this message translates to:
  /// **'Sign out other devices'**
  String get securitySignOutOthers;

  /// No description provided for @securityOthersSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Other devices signed out.'**
  String get securityOthersSignedOut;

  /// No description provided for @securitySetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up authenticator app'**
  String get securitySetupTitle;

  /// No description provided for @securitySetupBody.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR with Google Authenticator, Authy, 1Password, etc., then enter the 6-digit code.'**
  String get securitySetupBody;

  /// No description provided for @securityKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'Key copied.'**
  String get securityKeyCopied;

  /// No description provided for @securityCopyKey.
  ///
  /// In en, this message translates to:
  /// **'Copy key'**
  String get securityCopyKey;

  /// No description provided for @securityVerifyEnable.
  ///
  /// In en, this message translates to:
  /// **'Verify & enable'**
  String get securityVerifyEnable;

  /// No description provided for @securityAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available: {kinds}'**
  String securityAvailable(String kinds);

  /// No description provided for @biometricFace.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get biometricFace;

  /// No description provided for @biometricFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get biometricFingerprint;

  /// No description provided for @biometricDevice.
  ///
  /// In en, this message translates to:
  /// **'Device biometrics'**
  String get biometricDevice;

  /// No description provided for @onboardingEyebrow1.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingEyebrow1;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Never miss a renewal again'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'DocsBuddy keeps track of warranties, insurance, bills and dates — so the deadlines don’t sneak up on you.'**
  String get onboardingBody1;

  /// No description provided for @onboardingEyebrow2.
  ///
  /// In en, this message translates to:
  /// **'Organise'**
  String get onboardingEyebrow2;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'All your assets in one place'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Vehicles, appliances, electronics, even documents — organised by room and category.'**
  String get onboardingBody2;

  /// No description provided for @onboardingEyebrow3.
  ///
  /// In en, this message translates to:
  /// **'Stay ahead'**
  String get onboardingEyebrow3;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Smart reminders, weeks ahead'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Configure 60 / 30 / 7 / 1-day alerts. Push, email or WhatsApp — your choice.'**
  String get onboardingBody3;

  /// No description provided for @onboardingEyebrow4.
  ///
  /// In en, this message translates to:
  /// **'Together'**
  String get onboardingEyebrow4;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Keep the whole family in sync'**
  String get onboardingTitle4;

  /// No description provided for @onboardingBody4.
  ///
  /// In en, this message translates to:
  /// **'Invite up to 8 members. Everyone gets reminded, anyone can update — no more single point of failure.'**
  String get onboardingBody4;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get onboardingHaveAccount;

  /// No description provided for @onboardingAlreadyWithUs.
  ///
  /// In en, this message translates to:
  /// **'Already with us? '**
  String get onboardingAlreadyWithUs;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @illoActiveInvoices.
  ///
  /// In en, this message translates to:
  /// **'Active Invoices'**
  String get illoActiveInvoices;

  /// No description provided for @illoKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get illoKitchen;

  /// No description provided for @illoSmartphone.
  ///
  /// In en, this message translates to:
  /// **'Smartphone'**
  String get illoSmartphone;

  /// No description provided for @illoVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get illoVehicles;

  /// No description provided for @illoPollutionDue.
  ///
  /// In en, this message translates to:
  /// **'Pollution due'**
  String get illoPollutionDue;

  /// No description provided for @illoSharedWithFamily.
  ///
  /// In en, this message translates to:
  /// **'Shared with family'**
  String get illoSharedWithFamily;

  /// No description provided for @illoBikeSample.
  ///
  /// In en, this message translates to:
  /// **'{date} · Bike'**
  String illoBikeSample(String date);

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @appearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceSystem;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// No description provided for @authContinueWithMicrosoft.
  ///
  /// In en, this message translates to:
  /// **'Continue with Microsoft'**
  String get authContinueWithMicrosoft;

  /// No description provided for @startupStepServices.
  ///
  /// In en, this message translates to:
  /// **'Starting DocsBuddy…'**
  String get startupStepServices;

  /// No description provided for @startupStepAccount.
  ///
  /// In en, this message translates to:
  /// **'Connecting to your account…'**
  String get startupStepAccount;

  /// No description provided for @startupStepPreferences.
  ///
  /// In en, this message translates to:
  /// **'Loading your preferences…'**
  String get startupStepPreferences;

  /// No description provided for @startupStepCount.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String startupStepCount(int step, int total);

  /// No description provided for @startupFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start DocsBuddy'**
  String get startupFailedTitle;

  /// No description provided for @startupFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while getting things ready. Please try again. If it keeps happening, tell support what the line below says.'**
  String get startupFailedBody;

  /// No description provided for @startupRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get startupRetry;

  /// No description provided for @loadingSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing you in…'**
  String get loadingSigningIn;

  /// No description provided for @loadingOpeningGoogle.
  ///
  /// In en, this message translates to:
  /// **'Opening Google…'**
  String get loadingOpeningGoogle;

  /// No description provided for @loadingOpeningApple.
  ///
  /// In en, this message translates to:
  /// **'Opening Apple…'**
  String get loadingOpeningApple;

  /// No description provided for @loadingOpeningMicrosoft.
  ///
  /// In en, this message translates to:
  /// **'Opening Microsoft…'**
  String get loadingOpeningMicrosoft;

  /// No description provided for @loadingCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating your account…'**
  String get loadingCreatingAccount;

  /// No description provided for @loadingSendingCode.
  ///
  /// In en, this message translates to:
  /// **'Sending your code…'**
  String get loadingSendingCode;

  /// No description provided for @loadingSendingNewCode.
  ///
  /// In en, this message translates to:
  /// **'Sending a new code…'**
  String get loadingSendingNewCode;

  /// No description provided for @loadingVerifyingCode.
  ///
  /// In en, this message translates to:
  /// **'Verifying your code…'**
  String get loadingVerifyingCode;

  /// No description provided for @loadingUpdatingPassword.
  ///
  /// In en, this message translates to:
  /// **'Updating your password…'**
  String get loadingUpdatingPassword;

  /// No description provided for @loadingSigningOut.
  ///
  /// In en, this message translates to:
  /// **'Signing you out…'**
  String get loadingSigningOut;

  /// No description provided for @loadingSavingAsset.
  ///
  /// In en, this message translates to:
  /// **'Saving your asset…'**
  String get loadingSavingAsset;

  /// No description provided for @loadingSavingReminder.
  ///
  /// In en, this message translates to:
  /// **'Saving your reminder…'**
  String get loadingSavingReminder;

  /// No description provided for @loadingDeletingAsset.
  ///
  /// In en, this message translates to:
  /// **'Deleting asset…'**
  String get loadingDeletingAsset;

  /// No description provided for @loadingDeletingReminder.
  ///
  /// In en, this message translates to:
  /// **'Deleting reminder…'**
  String get loadingDeletingReminder;

  /// No description provided for @loadingUploadingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Uploading photo…'**
  String get loadingUploadingPhoto;

  /// No description provided for @loadingCreatingRoom.
  ///
  /// In en, this message translates to:
  /// **'Creating room…'**
  String get loadingCreatingRoom;

  /// No description provided for @loadingRenamingRoom.
  ///
  /// In en, this message translates to:
  /// **'Renaming room…'**
  String get loadingRenamingRoom;

  /// No description provided for @loadingSavingRoomOrder.
  ///
  /// In en, this message translates to:
  /// **'Saving room order…'**
  String get loadingSavingRoomOrder;

  /// No description provided for @loadingCreatingFamily.
  ///
  /// In en, this message translates to:
  /// **'Creating your family…'**
  String get loadingCreatingFamily;

  /// No description provided for @loadingJoiningFamily.
  ///
  /// In en, this message translates to:
  /// **'Joining family…'**
  String get loadingJoiningFamily;

  /// No description provided for @loadingCreatingInvite.
  ///
  /// In en, this message translates to:
  /// **'Creating invite…'**
  String get loadingCreatingInvite;

  /// No description provided for @loadingUpdatingRole.
  ///
  /// In en, this message translates to:
  /// **'Updating role…'**
  String get loadingUpdatingRole;

  /// No description provided for @loadingRemovingMember.
  ///
  /// In en, this message translates to:
  /// **'Removing member…'**
  String get loadingRemovingMember;

  /// No description provided for @loadingLeavingFamily.
  ///
  /// In en, this message translates to:
  /// **'Leaving family…'**
  String get loadingLeavingFamily;

  /// No description provided for @loadingUploadingDocument.
  ///
  /// In en, this message translates to:
  /// **'Uploading document…'**
  String get loadingUploadingDocument;

  /// No description provided for @loadingOpeningDocument.
  ///
  /// In en, this message translates to:
  /// **'Opening document…'**
  String get loadingOpeningDocument;

  /// No description provided for @loadingPreparingDocument.
  ///
  /// In en, this message translates to:
  /// **'Preparing document to share…'**
  String get loadingPreparingDocument;

  /// No description provided for @loadingDeletingDocument.
  ///
  /// In en, this message translates to:
  /// **'Deleting document…'**
  String get loadingDeletingDocument;

  /// No description provided for @loadingSavingSettings.
  ///
  /// In en, this message translates to:
  /// **'Saving settings…'**
  String get loadingSavingSettings;

  /// No description provided for @loadingPreparingAuthenticator.
  ///
  /// In en, this message translates to:
  /// **'Preparing authenticator setup…'**
  String get loadingPreparingAuthenticator;

  /// No description provided for @loadingTurningOffTwoStep.
  ///
  /// In en, this message translates to:
  /// **'Turning off two-step verification…'**
  String get loadingTurningOffTwoStep;

  /// No description provided for @loadingSigningOutOthers.
  ///
  /// In en, this message translates to:
  /// **'Signing out other devices…'**
  String get loadingSigningOutOthers;

  /// No description provided for @loadingMarkingDone.
  ///
  /// In en, this message translates to:
  /// **'Marking as done…'**
  String get loadingMarkingDone;

  /// No description provided for @loadingSavingProfile.
  ///
  /// In en, this message translates to:
  /// **'Saving your profile…'**
  String get loadingSavingProfile;

  /// No description provided for @loadingImage.
  ///
  /// In en, this message translates to:
  /// **'Loading image…'**
  String get loadingImage;

  /// No description provided for @loadingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading your dashboard…'**
  String get loadingDashboard;

  /// No description provided for @loadingAssets.
  ///
  /// In en, this message translates to:
  /// **'Loading your assets…'**
  String get loadingAssets;

  /// No description provided for @loadingCategories.
  ///
  /// In en, this message translates to:
  /// **'Loading categories…'**
  String get loadingCategories;

  /// No description provided for @loadingRoom.
  ///
  /// In en, this message translates to:
  /// **'Loading room…'**
  String get loadingRoom;

  /// No description provided for @loadingAsset.
  ///
  /// In en, this message translates to:
  /// **'Loading asset…'**
  String get loadingAsset;

  /// No description provided for @loadingReminders.
  ///
  /// In en, this message translates to:
  /// **'Loading reminders…'**
  String get loadingReminders;

  /// No description provided for @loadingDocuments.
  ///
  /// In en, this message translates to:
  /// **'Loading documents…'**
  String get loadingDocuments;

  /// No description provided for @loadingRooms.
  ///
  /// In en, this message translates to:
  /// **'Loading rooms…'**
  String get loadingRooms;

  /// No description provided for @loadingFamily.
  ///
  /// In en, this message translates to:
  /// **'Loading your family…'**
  String get loadingFamily;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading your profile…'**
  String get loadingProfile;

  /// No description provided for @loadingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Loading notifications…'**
  String get loadingNotifications;

  /// No description provided for @loadingSecurity.
  ///
  /// In en, this message translates to:
  /// **'Checking security settings…'**
  String get loadingSecurity;

  /// No description provided for @authTermsAgreement.
  ///
  /// In en, this message translates to:
  /// **'I agree to the {terms} and {privacy}.'**
  String authTermsAgreement(String terms, String privacy);

  /// No description provided for @catalogRoomSummary.
  ///
  /// In en, this message translates to:
  /// **'The heart of your home, managing {appliances}.'**
  String catalogRoomSummary(String appliances);

  /// No description provided for @reminderForAsset.
  ///
  /// In en, this message translates to:
  /// **'For {asset}'**
  String reminderForAsset(String asset);

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get languageAutomatic;

  /// No description provided for @languageAutomaticHint.
  ///
  /// In en, this message translates to:
  /// **'Follows your device language'**
  String get languageAutomaticHint;

  /// No description provided for @languageSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get languageSheetTitle;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email first — check your inbox.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorUserExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get errorUserExists;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'That password is too weak. Choose a stronger one.'**
  String get errorWeakPassword;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code is wrong or has expired.'**
  String get errorCodeInvalid;

  /// No description provided for @errorSamePassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a password you haven\'t used before.'**
  String get errorSamePassword;

  /// No description provided for @notificationDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get notificationDueToday;

  /// No description provided for @notificationDueInDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Due in 1 day} other{Due in {days} days}}'**
  String notificationDueInDays(int days);

  /// No description provided for @commonStepOf.
  ///
  /// In en, this message translates to:
  /// **'STEP {step} OF {total}'**
  String commonStepOf(int step, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fr',
    'hi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
