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

  @override
  String get errorNetwork =>
      'Can’t reach the server. Check your internet connection.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorNotSignedIn => 'You’re signed out. Please sign in again.';

  @override
  String get errorNameRequired => 'Please enter a name.';

  @override
  String get errorRoomNameRequired => 'Please name the room.';

  @override
  String get errorFamilyNameRequired => 'Please enter a family name.';

  @override
  String get errorInviteCodeInvalid => 'Enter a valid invite code.';

  @override
  String get errorOwnerRoleLocked => 'The owner\'s role can\'t be changed.';

  @override
  String get errorOwnerNotRemovable => 'The owner can\'t be removed.';

  @override
  String get errorNoActiveFamily => 'No active family.';

  @override
  String get errorFamilyRequired => 'Join or create a family first.';

  @override
  String get errorJoinedFamilyUnavailable =>
      'Could not load the joined family.';

  @override
  String get errorPhoneFormat =>
      'Use the international format, e.g. +91 9812345678.';

  @override
  String get errorTermsRequired => 'Please accept the Terms to continue.';

  @override
  String get errorPasswordRequirements =>
      'Please meet the password requirements.';

  @override
  String get errorPasswordMismatch => 'Passwords do not match.';

  @override
  String get errorNewPasswordTooShort =>
      'New password must be at least 8 characters.';

  @override
  String get errorCurrentPasswordIncorrect => 'Current password is incorrect.';

  @override
  String get errorOffsetsRequired => 'Pick at least one reminder offset.';

  @override
  String get errorNoAuthenticator => 'No authenticator enrolled.';

  @override
  String get errorTotpUnavailable =>
      'Authenticator setup is unavailable right now.';

  @override
  String get errorCodeLength => 'Enter the 6-digit code.';

  @override
  String errorUploadsFailed(int failed, int total) {
    return '$failed of $total uploads failed.';
  }

  @override
  String get errorFilesUnavailable =>
      'Connect a backend to open or share files.';

  @override
  String get errorAppOpenFailed => 'Could not open that app.';

  @override
  String get errorNotificationsBlocked =>
      'Notifications are blocked in system settings.';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonDone => 'Done';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonOptional => 'optional';

  @override
  String get commonNoMatches => 'No matches.';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonView => 'View';

  @override
  String get commonShare => 'Share';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonClear => 'Clear';

  @override
  String durationDaysShort(int days) {
    return '${days}d';
  }

  @override
  String get kindInsurance => 'Insurance';

  @override
  String get kindPollution => 'Pollution';

  @override
  String get kindAmc => 'AMC';

  @override
  String get kindService => 'Service';

  @override
  String get kindTax => 'Tax';

  @override
  String get kindWarranty => 'Warranty';

  @override
  String get kindRegistration => 'Registration';

  @override
  String get kindFitness => 'Fitness';

  @override
  String get kindOther => 'Other';

  @override
  String get groupVehicle => 'Vehicle';

  @override
  String get groupAppliance => 'Appliance';

  @override
  String get groupElectronics => 'Electronics';

  @override
  String get groupDocument => 'Document';

  @override
  String get groupOther => 'Other';

  @override
  String get recurrenceNone => 'None';

  @override
  String get recurrenceNever => 'Never';

  @override
  String get recurrenceMonthly => 'Monthly';

  @override
  String get recurrenceQuarterly => 'Quarterly';

  @override
  String get recurrenceHalfYearly => 'Half-yearly';

  @override
  String get recurrenceYearly => 'Yearly';

  @override
  String dueOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Overdue by $days days',
      one: 'Overdue by 1 day',
    );
    return '$_temp0';
  }

  @override
  String get dueToday => 'Due today';

  @override
  String dueDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String relativeDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String relativeInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
      one: 'in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get pillOverdue => 'Overdue';

  @override
  String get pillToday => 'Today';

  @override
  String get catalogAddAsset => 'Add asset';

  @override
  String get catalogEditAsset => 'Edit asset';

  @override
  String get catalogDeleteAsset => 'Delete asset';

  @override
  String get catalogSaveChanges => 'Save changes';

  @override
  String get catalogSaveAsset => 'Save asset';

  @override
  String get catalogCustomTypeTitle => 'Custom appliance type';

  @override
  String get catalogCustomTypeHint => 'e.g. Dishwasher, Inverter, Camera…';

  @override
  String get catalogUseType => 'Use type';

  @override
  String get catalogChooseCategory => 'Choose a category';

  @override
  String get catalogChooseCategorySubtitle =>
      'What kind of thing are you adding?';

  @override
  String get catalogSelectAppliance => 'Select your appliance';

  @override
  String catalogNoPresetTypes(String group) {
    return 'No preset types for $group — use a custom type or skip.';
  }

  @override
  String catalogTypesIn(String group) {
    return 'Types in $group; pick one or add your own.';
  }

  @override
  String get catalogOthers => 'Others';

  @override
  String get catalogDetails => 'Details';

  @override
  String get catalogOnlyNameRequired => 'Only the name is required.';

  @override
  String get catalogName => 'Name';

  @override
  String get catalogNameHint => 'e.g. Samsung 340L Fridge';

  @override
  String get catalogRoomOptional => 'Room (optional)';

  @override
  String get catalogNewRoomHint => 'New room name — e.g. Kitchen';

  @override
  String get catalogBrand => 'Brand';

  @override
  String get catalogModelNumber => 'Model number';

  @override
  String get catalogSerialNo => 'Serial / registration no.';

  @override
  String get catalogSerialHint => 'e.g. TN 01 AB 1234';

  @override
  String get catalogPurchaseDate => 'Purchase date';

  @override
  String get catalogPurchasePrice => 'Purchase price';

  @override
  String get catalogPriceHint => 'e.g. 42000';

  @override
  String get catalogStore => 'Store';

  @override
  String get catalogStoreHint => 'e.g. Croma';

  @override
  String catalogDetailsFor(String name) {
    return 'Details for $name';
  }

  @override
  String get catalogThisAppliance => 'this appliance';

  @override
  String get catalogPropertyHint => 'e.g. Colour';

  @override
  String get catalogValueHint => 'value';

  @override
  String get catalogAddProperty => 'Add property';

  @override
  String get catalogAmcDate => 'AMC date';

  @override
  String get catalogInvoices => 'Invoices / receipts';

  @override
  String get catalogAttachInvoice =>
      'Attach invoice — camera, gallery or files';

  @override
  String catalogWillAutoAdd(String services) {
    return 'Will auto-add: $services';
  }

  @override
  String get catalogSelectYourAppliance => 'Select Your Appliance';

  @override
  String get catalogSearchAppliance => 'Search Your Appliance';

  @override
  String get catalogNoMatchingAppliance =>
      'No matching appliance — use \"Something else\" below.';

  @override
  String get catalogSomethingElse => 'Something else';

  @override
  String catalogAllReminders(int count) {
    return 'All Reminders · $count';
  }

  @override
  String get catalogNoRemindersForAsset => 'No reminders for this asset yet.';

  @override
  String get catalogMarkDoneTitle => 'Mark as done?';

  @override
  String catalogMarkDoneOneOff(String label) {
    return '“$label” will be completed and removed from upcoming reminders.';
  }

  @override
  String catalogMarkDoneRecurring(String label, String recurrence) {
    return '“$label” will be completed and its next due date scheduled ($recurrence).';
  }

  @override
  String get catalogMarkDone => 'Mark done';

  @override
  String catalogMarkedDone(String label) {
    return '$label marked as done.';
  }

  @override
  String catalogDoneRescheduled(String label) {
    return '$label done — next due date scheduled.';
  }

  @override
  String get catalogDeleteReminderTitle => 'Delete reminder?';

  @override
  String catalogDeleteReminderMessage(String label) {
    return '“$label” and its scheduled notifications will be removed.';
  }

  @override
  String get catalogDeleteAssetTitle => 'Delete asset?';

  @override
  String catalogDeleteAssetMessage(String name) {
    return '“$name” and all its reminders and documents will be removed. This can\'t be undone.';
  }

  @override
  String get catalogNoAssets => 'No assets yet. Tap “Add asset”.';

  @override
  String get catalogRoomNotFound => 'Room not found.';

  @override
  String get catalogAddRoomPhoto => 'Add a room photo';

  @override
  String get catalogRoomSummaryLead => 'The heart of your home, managing ';

  @override
  String catalogApplianceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appliances',
      one: '1 appliance',
    );
    return '$_temp0';
  }

  @override
  String get catalogAppliances => 'Appliances';

  @override
  String get catalogNothingRegistered => 'Nothing registered here yet.';

  @override
  String get catalogAddHere => 'Add here';

  @override
  String get catalogRenameRoom => 'Rename room';

  @override
  String catalogSince(String date) {
    return 'since $date';
  }

  @override
  String get catalogNoRemindersOnAppliance =>
      'No reminders on this appliance yet.';

  @override
  String get catalogCreateRoom => 'Create room';

  @override
  String get catalogNoRooms => 'No rooms yet. Add your first room above.';

  @override
  String get catalogAddRoomPhotoLong => 'Add a room photo — camera or device';

  @override
  String get catalogRoomNameHint => 'Room name — e.g. Kitchen';

  @override
  String get catalogAddNewRoom => 'Add a new room';

  @override
  String catalogRegisteredCount(int count) {
    return '$count Registered';
  }

  @override
  String get catalogSearchHint => 'Search assets, services, policy numbers…';

  @override
  String get catalogSearchEmpty => 'Type to search your assets and reminders.';

  @override
  String get catalogReminders => 'Reminders';

  @override
  String get catalogDue => 'Due';

  @override
  String get catalogOneOff => 'One-off';

  @override
  String get catalogReminds => 'Reminds';

  @override
  String get catalogProvider => 'Provider';

  @override
  String get catalogPolicyContract => 'Policy / contract';

  @override
  String get catalogCost => 'Cost';

  @override
  String get catalogNotes => 'Notes';

  @override
  String get catalogServiceDocuments => 'DOCUMENTS FOR THIS SERVICE';

  @override
  String catalogRemindersTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reminders tracked',
      one: '1 reminder tracked',
    );
    return '$_temp0';
  }

  @override
  String get catalogHideDetails => 'Hide details';

  @override
  String get catalogShowDetails => 'Show all details';

  @override
  String get catalogType => 'Type';

  @override
  String get catalogCategory => 'Category';

  @override
  String get catalogRoom => 'Room';

  @override
  String get catalogModel => 'Model';

  @override
  String get catalogSerialShort => 'Serial / reg. no.';

  @override
  String get catalogRemindersTrackedLabel => 'Reminders tracked';

  @override
  String get catalogNextDue => 'NEXT DUE';

  @override
  String catalogRemindsOffsets(String offsets) {
    return 'Reminds $offsets';
  }

  @override
  String get catalogMarkAsDone => 'Mark as done';

  @override
  String get catalogNoRoomHint => 'No room — you can set one later';

  @override
  String get catalogNoRoom => 'No room';

  @override
  String get catalogNewRoom => 'New room…';

  @override
  String get catalogAddPhoto => 'Add photo';

  @override
  String get dashboardFilterByType => 'Filter by type';

  @override
  String get dashboardUpcoming => 'Upcoming Expirations';

  @override
  String get dashboardGroupBy => 'Group by';

  @override
  String get dashboardGroupNone => 'Group by: None';

  @override
  String get dashboardGroupAsset => 'Group by: Asset';

  @override
  String get dashboardEmpty => 'No reminders yet. Add an asset to get started.';

  @override
  String get dashboardNoMatches => 'Nothing matches the selected types.';

  @override
  String get dashboardAsset => 'Asset';

  @override
  String get dashboardTotalAppliances => 'Total Active Appliances';

  @override
  String get filterActive => 'Active Services';

  @override
  String get filterSecured => 'Secured';

  @override
  String get filterSoon => 'Expiring Soon';

  @override
  String get filterExpired => 'Expired';

  @override
  String get docsTitle => 'DOCUMENTS';

  @override
  String get docsAdd => '+ Add';

  @override
  String get docsEmpty =>
      'No documents yet. Attach invoices, warranties or photos.';

  @override
  String get docsImageLoadFailed => 'Could not load image';

  @override
  String get docKindInvoice => 'Invoice';

  @override
  String get docKindWarranty => 'Warranty';

  @override
  String get docKindInsurance => 'Insurance';

  @override
  String get docKindManual => 'Manual';

  @override
  String get docKindPhoto => 'Photo';

  @override
  String get docKindOther => 'Other';

  @override
  String get familyCreateTitle => 'Create a family';

  @override
  String get familyNameHint => 'e.g. Kumar Family';

  @override
  String get familyJoinTitle => 'Join a family';

  @override
  String get familyInviteCodeHint => 'Invite code (e.g. AB12CD34)';

  @override
  String get familyJoin => 'Join';

  @override
  String get familyJoined =>
      'Joined! Family rooms, assets and reminders are syncing.';

  @override
  String familyChangeRoleTitle(String name) {
    return 'Change role — $name';
  }

  @override
  String get familyRoleAdminHint => 'Manage members, assets and invites';

  @override
  String get familyRoleViewerHint => 'Read-only access';

  @override
  String get familyRoleMemberHint => 'Add and manage own assets';

  @override
  String get familyRemoveTitle => 'Remove member?';

  @override
  String familyRemoveMessage(String name) {
    return '$name will lose access to this family’s assets and reminders.';
  }

  @override
  String get familyRemove => 'Remove';

  @override
  String get familyLeaveTitle => 'Leave family?';

  @override
  String get familyLeaveMessage =>
      'You will stop receiving this family’s reminders.';

  @override
  String get familyLeave => 'Leave';

  @override
  String get familyEmptyTitle => 'You\'re not in a family yet';

  @override
  String get familyEmptyBody =>
      'Create a family to share assets and reminders, or join one with an invite code.';

  @override
  String get familyJoinWithCode => 'Join with a code';

  @override
  String get familyMembers => 'MEMBERS';

  @override
  String get familyInviteMember => 'Invite member';

  @override
  String get familyLeaveFamily => 'Leave family';

  @override
  String get familyCall => 'Call';

  @override
  String get familyWhatsapp => 'WhatsApp';

  @override
  String get familyChangeRole => 'Change role';

  @override
  String get familyRemoveFromFamily => 'Remove from family';

  @override
  String get familyInviteTitle => 'Invite a member';

  @override
  String familyInviteBody(String role) {
    return 'Share this code. They can join as $role. Expires in 7 days.';
  }

  @override
  String get familyCopyCode => 'Copy code';

  @override
  String get familyCodeCopied => 'Invite code copied';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Member';

  @override
  String get roleViewer => 'Viewer';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileVerified => 'Verified';

  @override
  String get profileEditInfo => 'Edit personal info';

  @override
  String get profileNotificationPrefs => 'Notification preferences';

  @override
  String get profileManagedInSettings => 'Managed in Settings';

  @override
  String get profileDisplayName => 'Display name';

  @override
  String get profilePhone => 'Phone (for WhatsApp reminders)';

  @override
  String get profileDocuments => 'Documents';

  @override
  String get profileInvite => 'Invite';

  @override
  String get reminderAddTitle => 'Add Reminder';

  @override
  String get reminderEditTitle => 'Edit Reminder';

  @override
  String get reminderFor => 'For ';

  @override
  String get reminderSaveChanges => 'Save Changes';

  @override
  String get reminderSave => 'Save Reminder';

  @override
  String get reminderTypeTitle => 'Reminder type';

  @override
  String get reminderTypeSubtitle => 'What should we track?';

  @override
  String reminderDetailsTitle(String kind) {
    return '$kind details';
  }

  @override
  String get reminderDetailsSubtitle => 'When is it due?';

  @override
  String get reminderLabel => 'Label';

  @override
  String get reminderDueDate => 'Due Date';

  @override
  String get reminderRepeats => 'Repeats';

  @override
  String get reminderServiceDetails => 'Service details (optional)';

  @override
  String get reminderProviderHint => 'e.g. Acko';

  @override
  String get reminderPolicyNo => 'Policy / contract no.';

  @override
  String get reminderCostHint => 'e.g. 4200';

  @override
  String get reminderNotifyTitle => 'Notification settings';

  @override
  String get reminderNotifySubtitle =>
      'Push notification & reminder to all family members.';

  @override
  String get reminderNotifyMe => 'Notify me';

  @override
  String get reminderNoOffsets =>
      'No reminders will fire for this service — pick at least one offset to be notified.';

  @override
  String reminderOffsetsSummary(String offsets) {
    return 'You\'ll be reminded $offsets before the due date, on your enabled channels (see Settings).';
  }

  @override
  String get reminderAttachTitle => 'Attachments';

  @override
  String get reminderAttachSubtitle =>
      'Policy PDF, receipt, photos… attach now or later from the asset page.';

  @override
  String get reminderAttachDocs =>
      'Attach documents — camera, gallery or files';

  @override
  String get remindersEmpty => 'Nothing here right now.';

  @override
  String get inboxAllCaughtUp => 'You\'re all caught up 🎉';

  @override
  String get inboxOverdue => 'Overdue';

  @override
  String get inboxComingUp => 'Coming up';

  @override
  String inboxDueIn(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Due in $days days — $date',
      one: 'Due in 1 day — $date',
    );
    return '$_temp0';
  }

  @override
  String get lockLocked => 'Locked';

  @override
  String get lockTapToUnlock => 'Tap to unlock';

  @override
  String get mfaTitle => 'Two-factor verification';

  @override
  String get mfaSubtitle =>
      'Enter the 6-digit code from your authenticator app.';

  @override
  String get mfaCodeLabel => '6-digit code';

  @override
  String get securityTitle => 'Security';

  @override
  String get securityBiometricSection => 'Biometric login';

  @override
  String get securityUnlockBiometrics => 'Unlock with biometrics';

  @override
  String get securityNoBiometrics => 'No biometrics available on this device';

  @override
  String get securityTwoFactorSection => 'Two-factor authentication';

  @override
  String get security2faEnabled => '2FA is enabled';

  @override
  String get securityEnable2fa => 'Enable 2FA';

  @override
  String get securityAuthenticatorApp => 'Authenticator app';

  @override
  String securityAuthenticatorSince(String date) {
    return 'Authenticator app · since $date';
  }

  @override
  String get securityAuthenticatorHint =>
      'Use Google Authenticator, Authy, 1Password, etc.';

  @override
  String get securityMoreSection => 'More';

  @override
  String get securityAppLock => 'App lock';

  @override
  String get securityAppLockHint => 'Require unlock when reopening the app';

  @override
  String get securityAutoLock => 'Auto-lock after';

  @override
  String securityMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String securityMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get securityActiveSessions => 'Active sessions';

  @override
  String get securityDisable2faTitle => 'Disable 2FA?';

  @override
  String get securityDisable2faMessage =>
      'Your account will no longer require an authenticator code to sign in.';

  @override
  String get securityDisable => 'Disable';

  @override
  String get securityCurrentSession => 'Current session';

  @override
  String securitySignedInAt(String date) {
    return 'Signed in $date';
  }

  @override
  String get securityThisDevice => 'This device';

  @override
  String get securitySignOutOthers => 'Sign out other devices';

  @override
  String get securityOthersSignedOut => 'Other devices signed out.';

  @override
  String get securitySetupTitle => 'Set up authenticator app';

  @override
  String get securitySetupBody =>
      'Scan the QR with Google Authenticator, Authy, 1Password, etc., then enter the 6-digit code.';

  @override
  String get securityKeyCopied => 'Key copied.';

  @override
  String get securityCopyKey => 'Copy key';

  @override
  String get securityVerifyEnable => 'Verify & enable';

  @override
  String securityAvailable(String kinds) {
    return 'Available: $kinds';
  }

  @override
  String get biometricFace => 'Face ID';

  @override
  String get biometricFingerprint => 'Fingerprint';

  @override
  String get biometricDevice => 'Device biometrics';

  @override
  String get onboardingEyebrow1 => 'Welcome';

  @override
  String get onboardingTitle1 => 'Never miss a renewal again';

  @override
  String get onboardingBody1 =>
      'DocsBuddy keeps track of warranties, insurance, bills and dates — so the deadlines don’t sneak up on you.';

  @override
  String get onboardingEyebrow2 => 'Organise';

  @override
  String get onboardingTitle2 => 'All your assets in one place';

  @override
  String get onboardingBody2 =>
      'Vehicles, appliances, electronics, even documents — organised by room and category.';

  @override
  String get onboardingEyebrow3 => 'Stay ahead';

  @override
  String get onboardingTitle3 => 'Smart reminders, weeks ahead';

  @override
  String get onboardingBody3 =>
      'Configure 60 / 30 / 7 / 1-day alerts. Push, email or WhatsApp — your choice.';

  @override
  String get onboardingEyebrow4 => 'Together';

  @override
  String get onboardingTitle4 => 'Keep the whole family in sync';

  @override
  String get onboardingBody4 =>
      'Invite up to 8 members. Everyone gets reminded, anyone can update — no more single point of failure.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingHaveAccount => 'I already have an account';

  @override
  String get onboardingAlreadyWithUs => 'Already with us? ';

  @override
  String get commonBack => 'Back';

  @override
  String get illoActiveInvoices => 'Active Invoices';

  @override
  String get illoKitchen => 'Kitchen';

  @override
  String get illoSmartphone => 'Smartphone';

  @override
  String get illoVehicles => 'Vehicles';

  @override
  String get illoPollutionDue => 'Pollution due';

  @override
  String get illoSharedWithFamily => 'Shared with family';

  @override
  String illoBikeSample(String date) {
    return '$date · Bike';
  }

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get appearanceSystem => 'System';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get authContinueWithMicrosoft => 'Continue with Microsoft';

  @override
  String get startupStepServices => 'Starting DocsBuddy…';

  @override
  String get startupStepAccount => 'Connecting to your account…';

  @override
  String get startupStepPreferences => 'Loading your preferences…';

  @override
  String startupStepCount(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get startupFailedTitle => 'Couldn\'t start DocsBuddy';

  @override
  String get startupFailedBody =>
      'Something went wrong while getting things ready. Check your connection and try again.';

  @override
  String get startupRetry => 'Try again';
}
