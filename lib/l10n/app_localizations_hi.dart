// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonOn => 'चालू';

  @override
  String get commonOff => 'बंद';

  @override
  String get commonEmail => 'ईमेल';

  @override
  String get commonPassword => 'पासवर्ड';

  @override
  String get commonEmailHint => 'aap@example.com';

  @override
  String get commonSignIn => 'साइन इन करें';

  @override
  String get commonSignOut => 'साइन आउट करें';

  @override
  String get commonSettings => 'सेटिंग्स';

  @override
  String get commonFamily => 'परिवार';

  @override
  String get commonNotifications => 'सूचनाएँ';

  @override
  String get commonChangePassword => 'पासवर्ड बदलें';

  @override
  String get commonForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get navHome => 'होम';

  @override
  String get navRooms => 'कमरे';

  @override
  String get navAssets => 'संपत्तियाँ';

  @override
  String get authSignInCta => 'साइन इन करें';

  @override
  String get authNoAccountLead => 'खाता नहीं है? ';

  @override
  String get authSignUpAction => 'साइन अप करें';

  @override
  String get authOrContinueWith => 'या इनसे जारी रखें';

  @override
  String get authContinueWithGoogle => 'Google से जारी रखें';

  @override
  String get authContinueWithApple => 'Apple से जारी रखें';

  @override
  String get authFullName => 'पूरा नाम';

  @override
  String get authFullNameHint => 'आपका नाम';

  @override
  String get authCreateAccountCta => 'खाता बनाएँ';

  @override
  String get authHaveAccountLead => 'पहले से खाता है? ';

  @override
  String get authTermsOfService => 'सेवा की शर्तों';

  @override
  String get authPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get authForgotSendCode => 'सत्यापन कोड भेजें';

  @override
  String get authRememberLead => 'याद आ गया? ';

  @override
  String get authBackToSignIn => 'साइन इन पर वापस जाएँ';

  @override
  String get authOtpTitle => 'अपना इनबॉक्स देखें';

  @override
  String authOtpSubtitle(String email) {
    return 'हमने $email पर 6 अंकों का कोड भेजा है। आगे बढ़ने के लिए उसे नीचे दर्ज करें।';
  }

  @override
  String get authOtpVerify => 'सत्यापित करें';

  @override
  String authOtpResendIn(String time) {
    return 'कोड नहीं मिला? $time में दोबारा भेजें';
  }

  @override
  String get authOtpNotReceivedLead => 'कोड नहीं मिला? ';

  @override
  String get authOtpResend => 'कोड दोबारा भेजें';

  @override
  String get authResetTitle => 'नया पासवर्ड सेट करें';

  @override
  String get authNewPassword => 'नया पासवर्ड';

  @override
  String get authConfirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get authResetCta => 'पासवर्ड रीसेट करें';

  @override
  String get authPasswordMustHave => 'पासवर्ड में होना चाहिए';

  @override
  String get authRuleLength => 'कम से कम 8 अक्षर';

  @override
  String get authRuleUpper => 'एक बड़ा अक्षर (अंग्रेज़ी)';

  @override
  String get authRuleNumber => 'एक अंक';

  @override
  String get authRuleSpecial => 'एक विशेष चिह्न (!@#\$…)';

  @override
  String get authResetDone => 'पासवर्ड अपडेट हो गया। कृपया साइन इन करें।';

  @override
  String get settingsSectionAccount => 'खाता';

  @override
  String get settingsPersonalInfo => 'व्यक्तिगत जानकारी';

  @override
  String get settingsSecurity => 'सुरक्षा और 2FA';

  @override
  String get settingsPush => 'पुश सूचनाएँ';

  @override
  String get settingsEmailReminders => 'ईमेल रिमाइंडर';

  @override
  String get settingsWhatsappReminders => 'WhatsApp रिमाइंडर';

  @override
  String get settingsDefaultOffsets => 'डिफ़ॉल्ट अग्रिम समय';

  @override
  String get settingsQuietHours => 'शांत समय';

  @override
  String get settingsQuietHoursStart => 'शांत समय की शुरुआत';

  @override
  String get settingsQuietHoursEnd => 'शांत समय का अंत';

  @override
  String get settingsManageFamily => 'परिवार प्रबंधित करें';

  @override
  String get settingsSectionApp => 'ऐप';

  @override
  String get settingsBackend => 'बैकएंड';

  @override
  String get settingsTestNotification => 'टेस्ट सूचना भेजें';

  @override
  String get settingsTestNotificationSent => 'टेस्ट सूचना भेज दी गई।';

  @override
  String get settingsNotificationsBlocked =>
      'सिस्टम सेटिंग्स में सूचनाएँ बंद हैं।';

  @override
  String get settingsRoadmap => 'रोडमैप';

  @override
  String get settingsReplayOnboarding => 'परिचय दोबारा देखें';

  @override
  String get settingsOffsetsTitle => 'डिफ़ॉल्ट रिमाइंडर अग्रिम समय';

  @override
  String get settingsOffsetsSubtitle =>
      'देय तिथि से कितने दिन पहले सूचित करना है — नए रिमाइंडर के लिए उपयोग होता है।';

  @override
  String settingsDaysBefore(int days) {
    return '$days दिन पहले';
  }

  @override
  String get changePasswordTitle => 'पासवर्ड बदलें';

  @override
  String get changePasswordCurrent => 'मौजूदा पासवर्ड';

  @override
  String get changePasswordConfirm => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get changePasswordCta => 'पासवर्ड अपडेट करें';

  @override
  String get changePasswordDone => 'पासवर्ड अपडेट हो गया।';

  @override
  String get authForgotSubtitle =>
      'चिंता न करें। अपना ईमेल दर्ज करें, हम उसे रीसेट करने के लिए 6 अंकों का कोड भेज देंगे।';

  @override
  String get authResetSubtitle =>
      'ऐसा मज़बूत पासवर्ड चुनें जो आपने यहाँ पहले कभी इस्तेमाल न किया हो।';

  @override
  String get changePasswordNotice =>
      'आपकी सुरक्षा के लिए, पासवर्ड बदलने के बाद आप अपने अन्य डिवाइस से साइन आउट हो जाएँगे।';

  @override
  String get errorNetwork =>
      'सर्वर से संपर्क नहीं हो पा रहा। अपना इंटरनेट कनेक्शन जाँचें।';

  @override
  String get errorUnknown => 'कुछ गड़बड़ हो गई। कृपया फिर से प्रयास करें।';

  @override
  String get errorNotSignedIn => 'आप साइन आउट हैं। कृपया दोबारा साइन इन करें।';

  @override
  String get errorNameRequired => 'कृपया नाम दर्ज करें।';

  @override
  String get errorRoomNameRequired => 'कृपया कमरे को नाम दें।';

  @override
  String get errorFamilyNameRequired => 'कृपया परिवार का नाम दर्ज करें।';

  @override
  String get errorInviteCodeInvalid => 'मान्य आमंत्रण कोड दर्ज करें।';

  @override
  String get errorOwnerRoleLocked => 'मालिक की भूमिका नहीं बदली जा सकती।';

  @override
  String get errorOwnerNotRemovable => 'मालिक को हटाया नहीं जा सकता।';

  @override
  String get errorNoActiveFamily => 'कोई सक्रिय परिवार नहीं है।';

  @override
  String get errorFamilyRequired => 'पहले किसी परिवार से जुड़ें या नया बनाएँ।';

  @override
  String get errorJoinedFamilyUnavailable =>
      'जुड़ा हुआ परिवार लोड नहीं हो सका।';

  @override
  String get errorPhoneFormat =>
      'अंतरराष्ट्रीय प्रारूप इस्तेमाल करें, जैसे +91 9812345678।';

  @override
  String get errorTermsRequired =>
      'जारी रखने के लिए कृपया शर्तें स्वीकार करें।';

  @override
  String get errorPasswordRequirements =>
      'कृपया पासवर्ड की आवश्यकताएँ पूरी करें।';

  @override
  String get errorPasswordMismatch => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get errorNewPasswordTooShort =>
      'नया पासवर्ड कम से कम 8 अक्षरों का होना चाहिए।';

  @override
  String get errorCurrentPasswordIncorrect => 'मौजूदा पासवर्ड गलत है।';

  @override
  String get errorOffsetsRequired => 'कम से कम एक रिमाइंडर अग्रिम समय चुनें।';

  @override
  String get errorNoAuthenticator => 'कोई ऑथेंटिकेटर ऐप जुड़ा नहीं है।';

  @override
  String get errorTotpUnavailable => 'ऑथेंटिकेटर सेटअप अभी उपलब्ध नहीं है।';

  @override
  String get errorCodeLength => '6 अंकों का कोड दर्ज करें।';

  @override
  String errorUploadsFailed(int failed, int total) {
    return '$total में से $failed अपलोड विफल रहे।';
  }

  @override
  String get errorFilesUnavailable =>
      'फ़ाइलें खोलने या साझा करने के लिए बैकएंड जोड़ें।';

  @override
  String get errorAppOpenFailed => 'वह ऐप नहीं खुल सका।';

  @override
  String get errorNotificationsBlocked =>
      'सिस्टम सेटिंग्स में सूचनाएँ बंद हैं।';

  @override
  String get errorSignInIncomplete =>
      'साइन इन पूरा नहीं हो सका। कृपया फिर से प्रयास करें।';

  @override
  String get commonAdd => 'जोड़ें';

  @override
  String get commonEdit => 'संपादित करें';

  @override
  String get commonDelete => 'हटाएँ';

  @override
  String get commonDone => 'हो गया';

  @override
  String get commonNext => 'आगे';

  @override
  String get commonSkip => 'छोड़ें';

  @override
  String get commonOptional => 'वैकल्पिक';

  @override
  String get commonNoMatches => 'कोई मेल नहीं मिला।';

  @override
  String get commonCreate => 'बनाएँ';

  @override
  String get commonRetry => 'फिर कोशिश करें';

  @override
  String get commonView => 'देखें';

  @override
  String get commonShare => 'साझा करें';

  @override
  String get commonApply => 'लागू करें';

  @override
  String get commonClear => 'साफ़ करें';

  @override
  String durationDaysShort(int days) {
    return '$days दिन';
  }

  @override
  String get kindInsurance => 'बीमा';

  @override
  String get kindPollution => 'प्रदूषण';

  @override
  String get kindAmc => 'AMC';

  @override
  String get kindService => 'सर्विस';

  @override
  String get kindTax => 'कर';

  @override
  String get kindWarranty => 'वारंटी';

  @override
  String get kindRegistration => 'पंजीकरण';

  @override
  String get kindFitness => 'फिटनेस';

  @override
  String get kindOther => 'अन्य';

  @override
  String get groupVehicle => 'वाहन';

  @override
  String get groupAppliance => 'उपकरण';

  @override
  String get groupElectronics => 'इलेक्ट्रॉनिक्स';

  @override
  String get groupDocument => 'दस्तावेज़';

  @override
  String get groupOther => 'अन्य';

  @override
  String get recurrenceNone => 'कोई नहीं';

  @override
  String get recurrenceNever => 'कभी नहीं';

  @override
  String get recurrenceMonthly => 'मासिक';

  @override
  String get recurrenceQuarterly => 'तिमाही';

  @override
  String get recurrenceHalfYearly => 'छमाही';

  @override
  String get recurrenceYearly => 'वार्षिक';

  @override
  String dueOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन की देरी',
      one: '1 दिन की देरी',
    );
    return '$_temp0';
  }

  @override
  String get dueToday => 'आज देय';

  @override
  String dueDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन बाकी',
      one: '1 दिन बाकी',
    );
    return '$_temp0';
  }

  @override
  String relativeDaysAgo(int days) {
    return '$days दिन पहले';
  }

  @override
  String relativeInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन में',
      one: '1 दिन में',
    );
    return '$_temp0';
  }

  @override
  String get pillOverdue => 'देय तिथि बीत गई';

  @override
  String get pillToday => 'आज';

  @override
  String get catalogAddAsset => 'संपत्ति जोड़ें';

  @override
  String get catalogEditAsset => 'संपत्ति संपादित करें';

  @override
  String get catalogDeleteAsset => 'संपत्ति हटाएँ';

  @override
  String get catalogSaveChanges => 'बदलाव सहेजें';

  @override
  String get catalogSaveAsset => 'संपत्ति सहेजें';

  @override
  String get catalogCustomTypeTitle => 'अपनी पसंद का उपकरण प्रकार';

  @override
  String get catalogCustomTypeHint => 'जैसे डिशवॉशर, इन्वर्टर, कैमरा…';

  @override
  String get catalogUseType => 'यह प्रकार चुनें';

  @override
  String get catalogChooseCategory => 'श्रेणी चुनें';

  @override
  String get catalogChooseCategorySubtitle =>
      'आप किस तरह की चीज़ जोड़ रहे हैं?';

  @override
  String get catalogSelectAppliance => 'अपना उपकरण चुनें';

  @override
  String catalogNoPresetTypes(String group) {
    return '$group के लिए कोई पहले से तय प्रकार नहीं है — अपना प्रकार इस्तेमाल करें या छोड़ दें।';
  }

  @override
  String catalogTypesIn(String group) {
    return '$group के प्रकार; एक चुनें या अपना जोड़ें।';
  }

  @override
  String get catalogOthers => 'अन्य';

  @override
  String get catalogDetails => 'विवरण';

  @override
  String get catalogOnlyNameRequired => 'केवल नाम ज़रूरी है।';

  @override
  String get catalogName => 'नाम';

  @override
  String get catalogNameHint => 'जैसे Samsung 340L फ्रिज';

  @override
  String get catalogRoomOptional => 'कमरा (वैकल्पिक)';

  @override
  String get catalogNewRoomHint => 'नए कमरे का नाम — जैसे रसोई';

  @override
  String get catalogBrand => 'ब्रांड';

  @override
  String get catalogModelNumber => 'मॉडल नंबर';

  @override
  String get catalogSerialNo => 'सीरियल / पंजीकरण नं.';

  @override
  String get catalogSerialHint => 'जैसे TN 01 AB 1234';

  @override
  String get catalogPurchaseDate => 'खरीद की तिथि';

  @override
  String get catalogPurchasePrice => 'खरीद मूल्य';

  @override
  String get catalogPriceHint => 'जैसे 42000';

  @override
  String get catalogStore => 'दुकान';

  @override
  String get catalogStoreHint => 'जैसे Croma';

  @override
  String catalogDetailsFor(String name) {
    return '$name का विवरण';
  }

  @override
  String get catalogThisAppliance => 'यह उपकरण';

  @override
  String get catalogPropertyHint => 'जैसे रंग';

  @override
  String get catalogValueHint => 'मान';

  @override
  String get catalogAddProperty => 'विशेषता जोड़ें';

  @override
  String get catalogAmcDate => 'AMC की तिथि';

  @override
  String get catalogInvoices => 'बिल / रसीदें';

  @override
  String get catalogAttachInvoice => 'बिल जोड़ें — कैमरा, गैलरी या फ़ाइलें';

  @override
  String catalogWillAutoAdd(String services) {
    return 'अपने-आप जुड़ेगा: $services';
  }

  @override
  String get catalogSelectYourAppliance => 'अपना उपकरण चुनें';

  @override
  String get catalogSearchAppliance => 'अपना उपकरण खोजें';

  @override
  String get catalogNoMatchingAppliance =>
      'कोई मेल खाता उपकरण नहीं — नीचे “कुछ और” चुनें।';

  @override
  String get catalogSomethingElse => 'कुछ और';

  @override
  String catalogAllReminders(int count) {
    return 'सभी रिमाइंडर · $count';
  }

  @override
  String get catalogNoRemindersForAsset =>
      'इस संपत्ति के लिए अभी कोई रिमाइंडर नहीं है।';

  @override
  String get catalogMarkDoneTitle => 'पूरा हुआ मानें?';

  @override
  String catalogMarkDoneOneOff(String label) {
    return '“$label” पूरा हो जाएगा और आने वाले रिमाइंडर से हट जाएगा।';
  }

  @override
  String catalogMarkDoneRecurring(String label, String recurrence) {
    return '“$label” पूरा हो जाएगा और उसकी अगली देय तिथि तय हो जाएगी ($recurrence)।';
  }

  @override
  String get catalogMarkDone => 'पूरा हुआ';

  @override
  String catalogMarkedDone(String label) {
    return '$label पूरा हुआ।';
  }

  @override
  String catalogDoneRescheduled(String label) {
    return '$label पूरा हुआ — अगली देय तिथि तय हो गई।';
  }

  @override
  String get catalogDeleteReminderTitle => 'रिमाइंडर हटाएँ?';

  @override
  String catalogDeleteReminderMessage(String label) {
    return '“$label” और उसकी तय की गई सूचनाएँ हटा दी जाएँगी।';
  }

  @override
  String get catalogDeleteAssetTitle => 'संपत्ति हटाएँ?';

  @override
  String catalogDeleteAssetMessage(String name) {
    return '“$name” और उसके सभी रिमाइंडर व दस्तावेज़ हटा दिए जाएँगे। इसे वापस नहीं किया जा सकता।';
  }

  @override
  String get catalogNoAssets =>
      'अभी कोई संपत्ति नहीं है। “संपत्ति जोड़ें” दबाएँ।';

  @override
  String get catalogRoomNotFound => 'कमरा नहीं मिला।';

  @override
  String get catalogAddRoomPhoto => 'कमरे की फ़ोटो जोड़ें';

  @override
  String catalogApplianceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उपकरण',
      one: '1 उपकरण',
    );
    return '$_temp0';
  }

  @override
  String get catalogAppliances => 'उपकरण';

  @override
  String get catalogNothingRegistered => 'यहाँ अभी कुछ दर्ज नहीं है।';

  @override
  String get catalogAddHere => 'यहाँ जोड़ें';

  @override
  String get catalogRenameRoom => 'कमरे का नाम बदलें';

  @override
  String catalogSince(String date) {
    return '$date से';
  }

  @override
  String get catalogNoRemindersOnAppliance =>
      'इस उपकरण पर अभी कोई रिमाइंडर नहीं है।';

  @override
  String get catalogCreateRoom => 'कमरा बनाएँ';

  @override
  String get catalogNoRooms =>
      'अभी कोई कमरा नहीं है। ऊपर अपना पहला कमरा जोड़ें।';

  @override
  String get catalogAddRoomPhotoLong =>
      'कमरे की फ़ोटो जोड़ें — कैमरा या डिवाइस';

  @override
  String get catalogRoomNameHint => 'कमरे का नाम — जैसे रसोई';

  @override
  String get catalogAddNewRoom => 'नया कमरा जोड़ें';

  @override
  String catalogRegisteredCount(int count) {
    return '$count दर्ज';
  }

  @override
  String get catalogSearchHint => 'संपत्तियाँ, सेवाएँ, पॉलिसी नंबर खोजें…';

  @override
  String get catalogSearchEmpty =>
      'अपनी संपत्तियाँ और रिमाइंडर खोजने के लिए टाइप करें।';

  @override
  String get catalogReminders => 'रिमाइंडर';

  @override
  String get catalogDue => 'देय';

  @override
  String get catalogOneOff => 'एक बार';

  @override
  String get catalogReminds => 'याद दिलाएगा';

  @override
  String get catalogProvider => 'प्रदाता';

  @override
  String get catalogPolicyContract => 'पॉलिसी / अनुबंध';

  @override
  String get catalogCost => 'लागत';

  @override
  String get catalogNotes => 'नोट्स';

  @override
  String get catalogServiceDocuments => 'इस सेवा के दस्तावेज़';

  @override
  String catalogRemindersTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रिमाइंडर ट्रैक हो रहे हैं',
      one: '1 रिमाइंडर ट्रैक हो रहा है',
    );
    return '$_temp0';
  }

  @override
  String get catalogHideDetails => 'विवरण छिपाएँ';

  @override
  String get catalogShowDetails => 'पूरा विवरण दिखाएँ';

  @override
  String get catalogType => 'प्रकार';

  @override
  String get catalogCategory => 'श्रेणी';

  @override
  String get catalogRoom => 'कमरा';

  @override
  String get catalogModel => 'मॉडल';

  @override
  String get catalogSerialShort => 'सीरियल / पंजी. नं.';

  @override
  String get catalogRemindersTrackedLabel => 'ट्रैक हो रहे रिमाइंडर';

  @override
  String get catalogNextDue => 'अगली देय तिथि';

  @override
  String catalogRemindsOffsets(String offsets) {
    return '$offsets याद दिलाएगा';
  }

  @override
  String get catalogMarkAsDone => 'पूरा हुआ मानें';

  @override
  String get catalogNoRoomHint => 'कोई कमरा नहीं — बाद में चुन सकते हैं';

  @override
  String get catalogNoRoom => 'कोई कमरा नहीं';

  @override
  String get catalogNewRoom => 'नया कमरा…';

  @override
  String get catalogAddPhoto => 'फ़ोटो जोड़ें';

  @override
  String get dashboardFilterByType => 'प्रकार के अनुसार छाँटें';

  @override
  String get dashboardUpcoming => 'आने वाली समाप्ति तिथियाँ';

  @override
  String get dashboardGroupBy => 'इसके अनुसार समूह';

  @override
  String get dashboardGroupNone => 'समूह: कोई नहीं';

  @override
  String get dashboardGroupAsset => 'समूह: संपत्ति';

  @override
  String get dashboardEmpty =>
      'अभी कोई रिमाइंडर नहीं है। शुरू करने के लिए संपत्ति जोड़ें।';

  @override
  String get dashboardNoMatches => 'चुने गए प्रकारों से कुछ मेल नहीं खाता।';

  @override
  String get dashboardAsset => 'संपत्ति';

  @override
  String get dashboardTotalAppliances => 'कुल सक्रिय उपकरण';

  @override
  String get filterActive => 'सक्रिय सेवाएँ';

  @override
  String get filterSecured => 'सुरक्षित';

  @override
  String get filterSoon => 'जल्द समाप्त';

  @override
  String get filterExpired => 'समाप्त';

  @override
  String get docsTitle => 'दस्तावेज़';

  @override
  String get docsAdd => '+ जोड़ें';

  @override
  String get docsEmpty =>
      'अभी कोई दस्तावेज़ नहीं है। बिल, वारंटी या फ़ोटो जोड़ें।';

  @override
  String get docsImageLoadFailed => 'चित्र लोड नहीं हो सका';

  @override
  String get docKindInvoice => 'बिल';

  @override
  String get docKindWarranty => 'वारंटी';

  @override
  String get docKindInsurance => 'बीमा';

  @override
  String get docKindManual => 'मैनुअल';

  @override
  String get docKindPhoto => 'फ़ोटो';

  @override
  String get docKindOther => 'अन्य';

  @override
  String get familyCreateTitle => 'परिवार बनाएँ';

  @override
  String get familyNameHint => 'जैसे कुमार परिवार';

  @override
  String get familyJoinTitle => 'किसी परिवार से जुड़ें';

  @override
  String get familyInviteCodeHint => 'आमंत्रण कोड (जैसे AB12CD34)';

  @override
  String get familyJoin => 'जुड़ें';

  @override
  String get familyJoined =>
      'जुड़ गए! परिवार के कमरे, संपत्तियाँ और रिमाइंडर सिंक हो रहे हैं।';

  @override
  String familyChangeRoleTitle(String name) {
    return 'भूमिका बदलें — $name';
  }

  @override
  String get familyRoleAdminHint =>
      'सदस्यों, संपत्तियों और आमंत्रणों का प्रबंधन';

  @override
  String get familyRoleViewerHint => 'केवल देखने की अनुमति';

  @override
  String get familyRoleMemberHint => 'अपनी संपत्तियाँ जोड़ें और प्रबंधित करें';

  @override
  String get familyRemoveTitle => 'सदस्य को हटाएँ?';

  @override
  String familyRemoveMessage(String name) {
    return '$name इस परिवार की संपत्तियों और रिमाइंडर तक पहुँच खो देंगे।';
  }

  @override
  String get familyRemove => 'हटाएँ';

  @override
  String get familyLeaveTitle => 'परिवार छोड़ें?';

  @override
  String get familyLeaveMessage =>
      'आपको इस परिवार के रिमाइंडर मिलना बंद हो जाएँगे।';

  @override
  String get familyLeave => 'छोड़ें';

  @override
  String get familyEmptyTitle => 'आप अभी किसी परिवार में नहीं हैं';

  @override
  String get familyEmptyBody =>
      'संपत्तियाँ और रिमाइंडर साझा करने के लिए परिवार बनाएँ, या आमंत्रण कोड से किसी में जुड़ें।';

  @override
  String get familyJoinWithCode => 'कोड से जुड़ें';

  @override
  String get familyMembers => 'सदस्य';

  @override
  String get familyInviteMember => 'सदस्य को आमंत्रित करें';

  @override
  String get familyLeaveFamily => 'परिवार छोड़ें';

  @override
  String get familyCall => 'कॉल करें';

  @override
  String get familyWhatsapp => 'WhatsApp';

  @override
  String get familyChangeRole => 'भूमिका बदलें';

  @override
  String get familyRemoveFromFamily => 'परिवार से हटाएँ';

  @override
  String get familyInviteTitle => 'सदस्य को आमंत्रित करें';

  @override
  String familyInviteBody(String role) {
    return 'यह कोड साझा करें। वे $role के रूप में जुड़ सकते हैं। 7 दिन में समाप्त हो जाएगा।';
  }

  @override
  String get familyCopyCode => 'कोड कॉपी करें';

  @override
  String get familyCodeCopied => 'आमंत्रण कोड कॉपी हो गया';

  @override
  String get roleOwner => 'मालिक';

  @override
  String get roleAdmin => 'एडमिन';

  @override
  String get roleMember => 'सदस्य';

  @override
  String get roleViewer => 'दर्शक';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileVerified => 'सत्यापित';

  @override
  String get profileEditInfo => 'व्यक्तिगत जानकारी संपादित करें';

  @override
  String get profileNotificationPrefs => 'सूचना प्राथमिकताएँ';

  @override
  String get profileManagedInSettings => 'सेटिंग्स में प्रबंधित';

  @override
  String get profileDisplayName => 'प्रदर्शित नाम';

  @override
  String get profilePhone => 'फ़ोन (WhatsApp रिमाइंडर के लिए)';

  @override
  String get profileDocuments => 'दस्तावेज़';

  @override
  String get profileInvite => 'आमंत्रित करें';

  @override
  String get reminderAddTitle => 'रिमाइंडर जोड़ें';

  @override
  String get reminderEditTitle => 'रिमाइंडर संपादित करें';

  @override
  String get reminderSaveChanges => 'बदलाव सहेजें';

  @override
  String get reminderSave => 'रिमाइंडर सहेजें';

  @override
  String get reminderTypeTitle => 'रिमाइंडर का प्रकार';

  @override
  String get reminderTypeSubtitle => 'हमें किसे ट्रैक करना चाहिए?';

  @override
  String reminderDetailsTitle(String kind) {
    return '$kind का विवरण';
  }

  @override
  String get reminderDetailsSubtitle => 'यह कब देय है?';

  @override
  String get reminderLabel => 'लेबल';

  @override
  String get reminderDueDate => 'देय तिथि';

  @override
  String get reminderRepeats => 'दोहराव';

  @override
  String get reminderServiceDetails => 'सेवा का विवरण (वैकल्पिक)';

  @override
  String get reminderProviderHint => 'जैसे Acko';

  @override
  String get reminderPolicyNo => 'पॉलिसी / अनुबंध नं.';

  @override
  String get reminderCostHint => 'जैसे 4200';

  @override
  String get reminderNotifyTitle => 'सूचना सेटिंग्स';

  @override
  String get reminderNotifySubtitle =>
      'परिवार के सभी सदस्यों को पुश सूचना और रिमाइंडर।';

  @override
  String get reminderNotifyMe => 'मुझे सूचित करें';

  @override
  String get reminderNoOffsets =>
      'इस सेवा के लिए कोई रिमाइंडर नहीं बजेगा — सूचना पाने के लिए कम से कम एक अग्रिम समय चुनें।';

  @override
  String reminderOffsetsSummary(String offsets) {
    return 'देय तिथि से $offsets पहले आपको याद दिलाया जाएगा, आपके चालू किए गए माध्यमों पर (सेटिंग्स देखें)।';
  }

  @override
  String get reminderAttachTitle => 'संलग्नक';

  @override
  String get reminderAttachSubtitle =>
      'पॉलिसी PDF, रसीद, फ़ोटो… अभी जोड़ें या बाद में संपत्ति के पेज से।';

  @override
  String get reminderAttachDocs => 'दस्तावेज़ जोड़ें — कैमरा, गैलरी या फ़ाइलें';

  @override
  String get remindersEmpty => 'अभी यहाँ कुछ नहीं है।';

  @override
  String get inboxAllCaughtUp => 'आप पूरी तरह अपडेट हैं 🎉';

  @override
  String get inboxOverdue => 'देय तिथि बीत गई';

  @override
  String get inboxComingUp => 'आने वाले';

  @override
  String inboxDueIn(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन में देय — $date',
      one: '1 दिन में देय — $date',
    );
    return '$_temp0';
  }

  @override
  String get lockLocked => 'लॉक है';

  @override
  String get lockTapToUnlock => 'अनलॉक करने के लिए टैप करें';

  @override
  String get mfaTitle => 'दो-चरणीय सत्यापन';

  @override
  String get mfaSubtitle => 'अपने ऑथेंटिकेटर ऐप से 6 अंकों का कोड दर्ज करें।';

  @override
  String get mfaCodeLabel => '6 अंकों का कोड';

  @override
  String get securityTitle => 'सुरक्षा';

  @override
  String get securityBiometricSection => 'बायोमेट्रिक लॉगिन';

  @override
  String get securityUnlockBiometrics => 'बायोमेट्रिक से अनलॉक करें';

  @override
  String get securityNoBiometrics => 'इस डिवाइस पर बायोमेट्रिक उपलब्ध नहीं है';

  @override
  String get securityTwoFactorSection => 'दो-कारक प्रमाणीकरण';

  @override
  String get security2faEnabled => '2FA चालू है';

  @override
  String get securityEnable2fa => '2FA चालू करें';

  @override
  String get securityAuthenticatorApp => 'ऑथेंटिकेटर ऐप';

  @override
  String securityAuthenticatorSince(String date) {
    return 'ऑथेंटिकेटर ऐप · $date से';
  }

  @override
  String get securityAuthenticatorHint =>
      'Google Authenticator, Authy, 1Password आदि इस्तेमाल करें।';

  @override
  String get securityMoreSection => 'और';

  @override
  String get securityAppLock => 'ऐप लॉक';

  @override
  String get securityAppLockHint => 'ऐप दोबारा खोलने पर अनलॉक ज़रूरी करें';

  @override
  String get securityAutoLock => 'इसके बाद अपने-आप लॉक';

  @override
  String securityMinutesShort(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String securityMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes मिनट',
      one: '1 मिनट',
    );
    return '$_temp0';
  }

  @override
  String get securityActiveSessions => 'सक्रिय सत्र';

  @override
  String get securityDisable2faTitle => '2FA बंद करें?';

  @override
  String get securityDisable2faMessage =>
      'साइन इन करने के लिए आपके खाते को अब ऑथेंटिकेटर कोड की ज़रूरत नहीं होगी।';

  @override
  String get securityDisable => 'बंद करें';

  @override
  String get securityCurrentSession => 'मौजूदा सत्र';

  @override
  String securitySignedInAt(String date) {
    return '$date को साइन इन किया';
  }

  @override
  String get securityThisDevice => 'यह डिवाइस';

  @override
  String get securitySignOutOthers => 'अन्य डिवाइस से साइन आउट करें';

  @override
  String get securityOthersSignedOut => 'अन्य डिवाइस से साइन आउट हो गया।';

  @override
  String get securitySetupTitle => 'ऑथेंटिकेटर ऐप सेट करें';

  @override
  String get securitySetupBody =>
      'Google Authenticator, Authy, 1Password आदि से QR स्कैन करें, फिर 6 अंकों का कोड दर्ज करें।';

  @override
  String get securityKeyCopied => 'कुंजी कॉपी हो गई।';

  @override
  String get securityCopyKey => 'कुंजी कॉपी करें';

  @override
  String get securityVerifyEnable => 'सत्यापित करें और चालू करें';

  @override
  String securityAvailable(String kinds) {
    return 'उपलब्ध: $kinds';
  }

  @override
  String get biometricFace => 'Face ID';

  @override
  String get biometricFingerprint => 'फ़िंगरप्रिंट';

  @override
  String get biometricDevice => 'डिवाइस बायोमेट्रिक';

  @override
  String get onboardingEyebrow1 => 'स्वागत है';

  @override
  String get onboardingTitle1 => 'अब कोई नवीनीकरण न चूकें';

  @override
  String get onboardingBody1 =>
      'DocsBuddy वारंटी, बीमा, बिल और तारीख़ों का हिसाब रखता है — ताकि समय-सीमाएँ आपको चौंका न सकें।';

  @override
  String get onboardingEyebrow2 => 'व्यवस्थित करें';

  @override
  String get onboardingTitle2 => 'आपकी सारी संपत्तियाँ एक जगह';

  @override
  String get onboardingBody2 =>
      'वाहन, उपकरण, इलेक्ट्रॉनिक्स, यहाँ तक कि दस्तावेज़ भी — कमरे और श्रेणी के अनुसार व्यवस्थित।';

  @override
  String get onboardingEyebrow3 => 'आगे रहें';

  @override
  String get onboardingTitle3 => 'स्मार्ट रिमाइंडर, हफ़्तों पहले';

  @override
  String get onboardingBody3 =>
      '60 / 30 / 7 / 1 दिन पहले के अलर्ट तय करें। पुश, ईमेल या WhatsApp — आपकी पसंद।';

  @override
  String get onboardingEyebrow4 => 'साथ मिलकर';

  @override
  String get onboardingTitle4 => 'पूरे परिवार को एक साथ रखें';

  @override
  String get onboardingBody4 =>
      '8 सदस्यों तक को आमंत्रित करें। सबको याद दिलाया जाता है, कोई भी अपडेट कर सकता है — किसी एक पर निर्भरता नहीं।';

  @override
  String get onboardingGetStarted => 'शुरू करें';

  @override
  String get onboardingHaveAccount => 'मेरे पास पहले से खाता है';

  @override
  String get onboardingAlreadyWithUs => 'पहले से हमारे साथ हैं? ';

  @override
  String get commonBack => 'वापस';

  @override
  String get illoActiveInvoices => 'सक्रिय बिल';

  @override
  String get illoKitchen => 'रसोई';

  @override
  String get illoSmartphone => 'स्मार्टफ़ोन';

  @override
  String get illoVehicles => 'वाहन';

  @override
  String get illoPollutionDue => 'प्रदूषण जाँच देय';

  @override
  String get illoSharedWithFamily => 'परिवार के साथ साझा';

  @override
  String illoBikeSample(String date) {
    return '$date · बाइक';
  }

  @override
  String get settingsAppearance => 'दिखावट';

  @override
  String get appearanceSystem => 'सिस्टम';

  @override
  String get appearanceLight => 'हल्का';

  @override
  String get appearanceDark => 'गहरा';

  @override
  String get authContinueWithMicrosoft => 'Microsoft से जारी रखें';

  @override
  String get startupStepServices => 'DocsBuddy शुरू हो रहा है…';

  @override
  String get startupStepAccount => 'आपके खाते से जुड़ रहे हैं…';

  @override
  String get startupStepPreferences => 'आपकी प्राथमिकताएँ लोड हो रही हैं…';

  @override
  String startupStepCount(int step, int total) {
    return 'चरण $step / $total';
  }

  @override
  String get startupFailedTitle => 'DocsBuddy शुरू नहीं हो सका';

  @override
  String get startupFailedBody =>
      'तैयारी के दौरान कुछ गड़बड़ हो गई। कृपया फिर से प्रयास करें। यदि बार-बार हो, तो सपोर्ट को नीचे की पंक्ति में लिखी बात बताएँ।';

  @override
  String get startupRetry => 'फिर से प्रयास करें';

  @override
  String get loadingSigningIn => 'साइन इन हो रहा है…';

  @override
  String get loadingOpeningGoogle => 'Google खुल रहा है…';

  @override
  String get loadingOpeningApple => 'Apple खुल रहा है…';

  @override
  String get loadingOpeningMicrosoft => 'Microsoft खुल रहा है…';

  @override
  String get loadingCreatingAccount => 'आपका खाता बन रहा है…';

  @override
  String get loadingSendingCode => 'आपका कोड भेजा जा रहा है…';

  @override
  String get loadingSendingNewCode => 'नया कोड भेजा जा रहा है…';

  @override
  String get loadingVerifyingCode => 'आपका कोड सत्यापित हो रहा है…';

  @override
  String get loadingUpdatingPassword => 'आपका पासवर्ड अपडेट हो रहा है…';

  @override
  String get loadingSigningOut => 'साइन आउट हो रहा है…';

  @override
  String get loadingSavingAsset => 'आपकी संपत्ति सहेजी जा रही है…';

  @override
  String get loadingSavingReminder => 'आपका रिमाइंडर सहेजा जा रहा है…';

  @override
  String get loadingDeletingAsset => 'संपत्ति हटाई जा रही है…';

  @override
  String get loadingDeletingReminder => 'रिमाइंडर हटाया जा रहा है…';

  @override
  String get loadingUploadingPhoto => 'फ़ोटो अपलोड हो रही है…';

  @override
  String get loadingCreatingRoom => 'कमरा बन रहा है…';

  @override
  String get loadingRenamingRoom => 'कमरे का नाम बदला जा रहा है…';

  @override
  String get loadingSavingRoomOrder => 'कमरों का क्रम सहेजा जा रहा है…';

  @override
  String get loadingCreatingFamily => 'आपका परिवार बन रहा है…';

  @override
  String get loadingJoiningFamily => 'परिवार से जुड़ रहे हैं…';

  @override
  String get loadingCreatingInvite => 'आमंत्रण बन रहा है…';

  @override
  String get loadingUpdatingRole => 'भूमिका अपडेट हो रही है…';

  @override
  String get loadingRemovingMember => 'सदस्य को हटाया जा रहा है…';

  @override
  String get loadingLeavingFamily => 'परिवार छोड़ रहे हैं…';

  @override
  String get loadingUploadingDocument => 'दस्तावेज़ अपलोड हो रहा है…';

  @override
  String get loadingOpeningDocument => 'दस्तावेज़ खुल रहा है…';

  @override
  String get loadingPreparingDocument =>
      'साझा करने के लिए दस्तावेज़ तैयार हो रहा है…';

  @override
  String get loadingDeletingDocument => 'दस्तावेज़ हटाया जा रहा है…';

  @override
  String get loadingSavingSettings => 'सेटिंग्स सहेजी जा रही हैं…';

  @override
  String get loadingPreparingAuthenticator =>
      'ऑथेंटिकेटर सेटअप तैयार हो रहा है…';

  @override
  String get loadingTurningOffTwoStep => 'दो-चरणीय सत्यापन बंद हो रहा है…';

  @override
  String get loadingSigningOutOthers => 'अन्य डिवाइस से साइन आउट हो रहा है…';

  @override
  String get loadingMarkingDone => 'पूरा हुआ चिह्नित हो रहा है…';

  @override
  String get loadingSavingProfile => 'आपकी प्रोफ़ाइल सहेजी जा रही है…';

  @override
  String get loadingImage => 'चित्र लोड हो रहा है…';

  @override
  String get loadingDashboard => 'आपका डैशबोर्ड लोड हो रहा है…';

  @override
  String get loadingAssets => 'आपकी संपत्तियाँ लोड हो रही हैं…';

  @override
  String get loadingCategories => 'श्रेणियाँ लोड हो रही हैं…';

  @override
  String get loadingRoom => 'कमरा लोड हो रहा है…';

  @override
  String get loadingAsset => 'संपत्ति लोड हो रही है…';

  @override
  String get loadingReminders => 'रिमाइंडर लोड हो रहे हैं…';

  @override
  String get loadingDocuments => 'दस्तावेज़ लोड हो रहे हैं…';

  @override
  String get loadingRooms => 'कमरे लोड हो रहे हैं…';

  @override
  String get loadingFamily => 'आपका परिवार लोड हो रहा है…';

  @override
  String get loadingProfile => 'आपकी प्रोफ़ाइल लोड हो रही है…';

  @override
  String get loadingNotifications => 'सूचनाएँ लोड हो रही हैं…';

  @override
  String get loadingSecurity => 'सुरक्षा सेटिंग्स जाँची जा रही हैं…';

  @override
  String authTermsAgreement(String terms, String privacy) {
    return 'मैं $terms और $privacy से सहमत हूँ।';
  }

  @override
  String catalogRoomSummary(String appliances) {
    return 'आपके घर का केंद्र, जिसमें $appliances हैं।';
  }

  @override
  String reminderForAsset(String asset) {
    return '$asset के लिए';
  }

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get languageAutomatic => 'स्वचालित';

  @override
  String get languageAutomaticHint => 'आपके डिवाइस की भाषा का पालन करता है';

  @override
  String get languageSheetTitle => 'भाषा चुनें';

  @override
  String get errorInvalidCredentials => 'ईमेल या पासवर्ड गलत है।';

  @override
  String get errorEmailNotConfirmed =>
      'कृपया पहले अपने ईमेल की पुष्टि करें — अपना इनबॉक्स देखें।';

  @override
  String get errorUserExists => 'इस ईमेल से पहले ही एक खाता मौजूद है।';

  @override
  String get errorWeakPassword =>
      'यह पासवर्ड बहुत कमज़ोर है। कोई मज़बूत पासवर्ड चुनें।';

  @override
  String get errorRateLimited =>
      'बहुत अधिक प्रयास हो गए। कुछ देर रुककर फिर कोशिश करें।';

  @override
  String get errorCodeInvalid =>
      'वह कोड गलत है या उसकी अवधि समाप्त हो चुकी है।';

  @override
  String get errorSamePassword =>
      'ऐसा पासवर्ड चुनें जो आपने पहले इस्तेमाल न किया हो।';

  @override
  String get notificationDueToday => 'आज देय';

  @override
  String notificationDueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन में देय',
      one: '1 दिन में देय',
    );
    return '$_temp0';
  }

  @override
  String commonStepOf(int step, int total) {
    return 'चरण $step / $total';
  }
}
