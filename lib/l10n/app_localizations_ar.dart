// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonOn => 'تشغيل';

  @override
  String get commonOff => 'إيقاف';

  @override
  String get commonEmail => 'البريد الإلكتروني';

  @override
  String get commonPassword => 'كلمة المرور';

  @override
  String get commonEmailHint => 'you@example.com';

  @override
  String get commonSignIn => 'تسجيل الدخول';

  @override
  String get commonSignOut => 'تسجيل الخروج';

  @override
  String get commonSettings => 'الإعدادات';

  @override
  String get commonFamily => 'العائلة';

  @override
  String get commonNotifications => 'الإشعارات';

  @override
  String get commonChangePassword => 'تغيير كلمة المرور';

  @override
  String get commonForgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navRooms => 'الغرف';

  @override
  String get navAssets => 'الممتلكات';

  @override
  String get authSignInCta => 'تسجيل الدخول';

  @override
  String get authNoAccountLead => 'ليس لديك حساب؟ ';

  @override
  String get authSignUpAction => 'أنشئ حسابًا';

  @override
  String get authOrContinueWith => 'أو تابع باستخدام';

  @override
  String get authContinueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get authContinueWithApple => 'المتابعة باستخدام Apple';

  @override
  String get authFullName => 'الاسم الكامل';

  @override
  String get authFullNameHint => 'اسمك';

  @override
  String get authCreateAccountCta => 'إنشاء حساب';

  @override
  String get authHaveAccountLead => 'لديك حساب بالفعل؟ ';

  @override
  String get authTermsOfService => 'شروط الخدمة';

  @override
  String get authPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get authForgotSendCode => 'إرسال رمز التحقق';

  @override
  String get authRememberLead => 'تذكّرتها؟ ';

  @override
  String get authBackToSignIn => 'العودة إلى تسجيل الدخول';

  @override
  String get authOtpTitle => 'تحقّق من بريدك الوارد';

  @override
  String authOtpSubtitle(String email) {
    return 'أرسلنا رمزًا من 6 أرقام إلى $email. أدخله أدناه للمتابعة.';
  }

  @override
  String get authOtpVerify => 'تحقّق';

  @override
  String authOtpResendIn(String time) {
    return 'لم يصلك الرمز؟ أعد الإرسال بعد $time';
  }

  @override
  String get authOtpNotReceivedLead => 'لم يصلك الرمز؟ ';

  @override
  String get authOtpResend => 'إعادة إرسال الرمز';

  @override
  String get authResetTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get authNewPassword => 'كلمة المرور الجديدة';

  @override
  String get authConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get authResetCta => 'إعادة تعيين كلمة المرور';

  @override
  String get authPasswordMustHave => 'يجب أن تحتوي كلمة المرور على';

  @override
  String get authRuleLength => '8 أحرف على الأقل';

  @override
  String get authRuleUpper => 'حرف كبير واحد (لاتيني)';

  @override
  String get authRuleNumber => 'رقم واحد';

  @override
  String get authRuleSpecial => 'رمز خاص واحد (!@#\$…)';

  @override
  String get authResetDone => 'تم تحديث كلمة المرور. يُرجى تسجيل الدخول.';

  @override
  String get settingsSectionAccount => 'الحساب';

  @override
  String get settingsPersonalInfo => 'المعلومات الشخصية';

  @override
  String get settingsSecurity => 'الأمان والمصادقة الثنائية';

  @override
  String get settingsPush => 'إشعارات الدفع';

  @override
  String get settingsEmailReminders => 'التذكيرات عبر البريد الإلكتروني';

  @override
  String get settingsWhatsappReminders => 'التذكيرات عبر واتساب';

  @override
  String get settingsDefaultOffsets => 'المدد الافتراضية للتنبيه';

  @override
  String get settingsQuietHours => 'ساعات الهدوء';

  @override
  String get settingsQuietHoursStart => 'بداية ساعات الهدوء';

  @override
  String get settingsQuietHoursEnd => 'نهاية ساعات الهدوء';

  @override
  String get settingsManageFamily => 'إدارة العائلة';

  @override
  String get settingsSectionApp => 'التطبيق';

  @override
  String get settingsBackend => 'الخادم';

  @override
  String get settingsTestNotification => 'إرسال إشعار تجريبي';

  @override
  String get settingsTestNotificationSent => 'تم إرسال إشعار تجريبي.';

  @override
  String get settingsNotificationsBlocked =>
      'الإشعارات محظورة في إعدادات النظام.';

  @override
  String get settingsRoadmap => 'خارطة الطريق';

  @override
  String get settingsReplayOnboarding => 'إعادة عرض المقدمة';

  @override
  String get settingsOffsetsTitle => 'المدد الافتراضية لتنبيهات التذكير';

  @override
  String get settingsOffsetsSubtitle =>
      'عدد الأيام قبل تاريخ الاستحقاق للتنبيه — يُستخدم في التذكيرات الجديدة.';

  @override
  String settingsDaysBefore(int days) {
    return 'قبل $days يوم';
  }

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get changePasswordCurrent => 'كلمة المرور الحالية';

  @override
  String get changePasswordConfirm => 'تأكيد كلمة المرور الجديدة';

  @override
  String get changePasswordCta => 'تحديث كلمة المرور';

  @override
  String get changePasswordDone => 'تم تحديث كلمة المرور.';

  @override
  String get authForgotSubtitle =>
      'لا تقلق. أدخل بريدك الإلكتروني وسنرسل إليك رمزًا من 6 أرقام لإعادة تعيينها.';

  @override
  String get authResetSubtitle => 'اختر كلمة مرور قوية لم تستخدمها هنا من قبل.';

  @override
  String get changePasswordNotice =>
      'لأمانك، سيتم تسجيل خروجك من أجهزتك الأخرى بعد تغيير كلمة المرور.';

  @override
  String get errorNetwork =>
      'تعذّر الوصول إلى الخادم. تحقّق من اتصالك بالإنترنت.';

  @override
  String get errorUnknown => 'حدث خطأ ما. يُرجى المحاولة مرة أخرى.';

  @override
  String get errorNotSignedIn => 'لقد سجّلت الخروج. يُرجى تسجيل الدخول مجددًا.';

  @override
  String get errorNameRequired => 'يُرجى إدخال اسم.';

  @override
  String get errorRoomNameRequired => 'يُرجى تسمية الغرفة.';

  @override
  String get errorFamilyNameRequired => 'يُرجى إدخال اسم العائلة.';

  @override
  String get errorInviteCodeInvalid => 'أدخل رمز دعوة صالحًا.';

  @override
  String get errorOwnerRoleLocked => 'لا يمكن تغيير دور المالك.';

  @override
  String get errorOwnerNotRemovable => 'لا يمكن إزالة المالك.';

  @override
  String get errorNoActiveFamily => 'لا توجد عائلة نشطة.';

  @override
  String get errorFamilyRequired => 'انضم إلى عائلة أو أنشئ واحدة أولًا.';

  @override
  String get errorJoinedFamilyUnavailable =>
      'تعذّر تحميل العائلة التي انضممت إليها.';

  @override
  String get errorPhoneFormat => 'استخدم الصيغة الدولية، مثل ‎+91 9812345678‎.';

  @override
  String get errorTermsRequired => 'يُرجى قبول الشروط للمتابعة.';

  @override
  String get errorPasswordRequirements => 'يُرجى استيفاء متطلبات كلمة المرور.';

  @override
  String get errorPasswordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get errorNewPasswordTooShort =>
      'يجب ألا تقل كلمة المرور الجديدة عن 8 أحرف.';

  @override
  String get errorCurrentPasswordIncorrect => 'كلمة المرور الحالية غير صحيحة.';

  @override
  String get errorOffsetsRequired => 'اختر مدة تنبيه واحدة على الأقل.';

  @override
  String get errorNoAuthenticator => 'لم يتم ربط أي تطبيق مصادقة.';

  @override
  String get errorTotpUnavailable => 'إعداد تطبيق المصادقة غير متاح حاليًا.';

  @override
  String get errorCodeLength => 'أدخل الرمز المكوّن من 6 أرقام.';

  @override
  String errorUploadsFailed(int failed, int total) {
    return 'فشل رفع $failed من أصل $total.';
  }

  @override
  String get errorFilesUnavailable => 'اربط خادمًا لفتح الملفات أو مشاركتها.';

  @override
  String get errorAppOpenFailed => 'تعذّر فتح ذلك التطبيق.';

  @override
  String get errorNotificationsBlocked => 'الإشعارات محظورة في إعدادات النظام.';

  @override
  String get errorSignInIncomplete =>
      'لم يكتمل تسجيل الدخول. يُرجى المحاولة مرة أخرى.';

  @override
  String get commonAdd => 'إضافة';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonDone => 'تم';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonSkip => 'تخطّي';

  @override
  String get commonOptional => 'اختياري';

  @override
  String get commonNoMatches => 'لا توجد نتائج مطابقة.';

  @override
  String get commonCreate => 'إنشاء';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonView => 'عرض';

  @override
  String get commonShare => 'مشاركة';

  @override
  String get commonApply => 'تطبيق';

  @override
  String get commonClear => 'مسح';

  @override
  String durationDaysShort(int days) {
    return '$days ي';
  }

  @override
  String get kindInsurance => 'التأمين';

  @override
  String get kindPollution => 'فحص الانبعاثات';

  @override
  String get kindAmc => 'AMC';

  @override
  String get kindService => 'الصيانة';

  @override
  String get kindTax => 'الضريبة';

  @override
  String get kindWarranty => 'الضمان';

  @override
  String get kindRegistration => 'التسجيل';

  @override
  String get kindFitness => 'الفحص الفني';

  @override
  String get kindOther => 'أخرى';

  @override
  String get groupVehicle => 'مركبة';

  @override
  String get groupAppliance => 'جهاز منزلي';

  @override
  String get groupElectronics => 'إلكترونيات';

  @override
  String get groupDocument => 'مستند';

  @override
  String get groupOther => 'أخرى';

  @override
  String get recurrenceNone => 'بدون';

  @override
  String get recurrenceNever => 'أبدًا';

  @override
  String get recurrenceMonthly => 'شهريًا';

  @override
  String get recurrenceQuarterly => 'كل 3 أشهر';

  @override
  String get recurrenceHalfYearly => 'كل 6 أشهر';

  @override
  String get recurrenceYearly => 'سنويًا';

  @override
  String dueOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'متأخر بـ $days يوم',
      many: 'متأخر بـ $days يومًا',
      few: 'متأخر بـ $days أيام',
      two: 'متأخر بيومين',
      one: 'متأخر بيوم واحد',
    );
    return '$_temp0';
  }

  @override
  String get dueToday => 'يستحق اليوم';

  @override
  String dueDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'بقي $days يوم',
      many: 'بقي $days يومًا',
      few: 'بقيت $days أيام',
      two: 'بقي يومان',
      one: 'بقي يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String relativeDaysAgo(int days) {
    return 'منذ $days ي';
  }

  @override
  String relativeInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'بعد $days يوم',
      many: 'بعد $days يومًا',
      few: 'بعد $days أيام',
      two: 'بعد يومين',
      one: 'بعد يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String get pillOverdue => 'متأخر';

  @override
  String get pillToday => 'اليوم';

  @override
  String get catalogAddAsset => 'إضافة ممتلك';

  @override
  String get catalogEditAsset => 'تعديل الممتلك';

  @override
  String get catalogDeleteAsset => 'حذف الممتلك';

  @override
  String get catalogSaveChanges => 'حفظ التغييرات';

  @override
  String get catalogSaveAsset => 'حفظ الممتلك';

  @override
  String get catalogCustomTypeTitle => 'نوع جهاز مخصّص';

  @override
  String get catalogCustomTypeHint =>
      'مثل غسّالة الأطباق، المُحوِّل، الكاميرا…';

  @override
  String get catalogUseType => 'استخدام النوع';

  @override
  String get catalogChooseCategory => 'اختر فئة';

  @override
  String get catalogChooseCategorySubtitle => 'ما نوع الشيء الذي تضيفه؟';

  @override
  String get catalogSelectAppliance => 'اختر جهازك';

  @override
  String catalogNoPresetTypes(String group) {
    return 'لا توجد أنواع جاهزة لـ $group — استخدم نوعًا مخصّصًا أو تخطَّ.';
  }

  @override
  String catalogTypesIn(String group) {
    return 'أنواع $group؛ اختر نوعًا أو أضف نوعك الخاص.';
  }

  @override
  String get catalogOthers => 'أخرى';

  @override
  String get catalogDetails => 'التفاصيل';

  @override
  String get catalogOnlyNameRequired => 'الاسم وحده مطلوب.';

  @override
  String get catalogName => 'الاسم';

  @override
  String get catalogNameHint => 'مثل: ثلاجة Samsung سعة 340 لترًا';

  @override
  String get catalogRoomOptional => 'الغرفة (اختياري)';

  @override
  String get catalogNewRoomHint => 'اسم الغرفة الجديدة — مثل المطبخ';

  @override
  String get catalogBrand => 'العلامة التجارية';

  @override
  String get catalogModelNumber => 'رقم الطراز';

  @override
  String get catalogSerialNo => 'الرقم التسلسلي / رقم التسجيل';

  @override
  String get catalogSerialHint => 'مثل: TN 01 AB 1234';

  @override
  String get catalogPurchaseDate => 'تاريخ الشراء';

  @override
  String get catalogPurchasePrice => 'سعر الشراء';

  @override
  String get catalogPriceHint => 'مثل: 42000';

  @override
  String get catalogStore => 'المتجر';

  @override
  String get catalogStoreHint => 'مثل: Croma';

  @override
  String catalogDetailsFor(String name) {
    return 'تفاصيل $name';
  }

  @override
  String get catalogThisAppliance => 'هذا الجهاز';

  @override
  String get catalogPropertyHint => 'مثل: اللون';

  @override
  String get catalogValueHint => 'القيمة';

  @override
  String get catalogAddProperty => 'إضافة خاصية';

  @override
  String get catalogAmcDate => 'تاريخ AMC';

  @override
  String get catalogInvoices => 'الفواتير / الإيصالات';

  @override
  String get catalogAttachInvoice =>
      'إرفاق فاتورة — الكاميرا أو المعرض أو الملفات';

  @override
  String catalogWillAutoAdd(String services) {
    return 'ستُضاف تلقائيًا: $services';
  }

  @override
  String get catalogSelectYourAppliance => 'اختر جهازك';

  @override
  String get catalogSearchAppliance => 'ابحث عن جهازك';

  @override
  String get catalogNoMatchingAppliance =>
      'لا يوجد جهاز مطابق — استخدم «شيء آخر» أدناه.';

  @override
  String get catalogSomethingElse => 'شيء آخر';

  @override
  String catalogAllReminders(int count) {
    return 'كل التذكيرات · $count';
  }

  @override
  String get catalogNoRemindersForAsset => 'لا توجد تذكيرات لهذا الممتلك بعد.';

  @override
  String get catalogMarkDoneTitle => 'وضع علامة «تم»؟';

  @override
  String catalogMarkDoneOneOff(String label) {
    return 'سيتم إكمال «$label» وإزالته من التذكيرات القادمة.';
  }

  @override
  String catalogMarkDoneRecurring(String label, String recurrence) {
    return 'سيتم إكمال «$label» وجدولة موعد استحقاقه التالي ($recurrence).';
  }

  @override
  String get catalogMarkDone => 'وضع علامة «تم»';

  @override
  String catalogMarkedDone(String label) {
    return 'تم وضع علامة «تم» على $label.';
  }

  @override
  String catalogDoneRescheduled(String label) {
    return 'تم إنجاز $label — جُدول موعد الاستحقاق التالي.';
  }

  @override
  String get catalogDeleteReminderTitle => 'حذف التذكير؟';

  @override
  String catalogDeleteReminderMessage(String label) {
    return 'ستُحذف «$label» وإشعاراتها المجدولة.';
  }

  @override
  String get catalogDeleteAssetTitle => 'حذف الممتلك؟';

  @override
  String catalogDeleteAssetMessage(String name) {
    return 'ستُحذف «$name» وجميع تذكيراتها ومستنداتها. لا يمكن التراجع عن ذلك.';
  }

  @override
  String get catalogNoAssets => 'لا توجد ممتلكات بعد. اضغط «إضافة ممتلك».';

  @override
  String get catalogRoomNotFound => 'لم يتم العثور على الغرفة.';

  @override
  String get catalogAddRoomPhoto => 'إضافة صورة للغرفة';

  @override
  String catalogApplianceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جهاز',
      many: '$count جهازًا',
      few: '$count أجهزة',
      two: 'جهازان',
      one: 'جهاز واحد',
    );
    return '$_temp0';
  }

  @override
  String get catalogAppliances => 'الأجهزة';

  @override
  String get catalogNothingRegistered => 'لا يوجد شيء مسجّل هنا بعد.';

  @override
  String get catalogAddHere => 'أضف هنا';

  @override
  String get catalogRenameRoom => 'إعادة تسمية الغرفة';

  @override
  String catalogSince(String date) {
    return 'منذ $date';
  }

  @override
  String get catalogNoRemindersOnAppliance =>
      'لا توجد تذكيرات على هذا الجهاز بعد.';

  @override
  String get catalogCreateRoom => 'إنشاء غرفة';

  @override
  String get catalogNoRooms => 'لا توجد غرف بعد. أضف غرفتك الأولى أعلاه.';

  @override
  String get catalogAddRoomPhotoLong =>
      'إضافة صورة للغرفة — الكاميرا أو الجهاز';

  @override
  String get catalogRoomNameHint => 'اسم الغرفة — مثل المطبخ';

  @override
  String get catalogAddNewRoom => 'إضافة غرفة جديدة';

  @override
  String catalogRegisteredCount(int count) {
    return '$count مسجّل';
  }

  @override
  String get catalogSearchHint => 'ابحث في الممتلكات والخدمات وأرقام الوثائق…';

  @override
  String get catalogSearchEmpty => 'اكتب للبحث في ممتلكاتك وتذكيراتك.';

  @override
  String get catalogReminders => 'التذكيرات';

  @override
  String get catalogDue => 'الاستحقاق';

  @override
  String get catalogOneOff => 'مرة واحدة';

  @override
  String get catalogReminds => 'التنبيه';

  @override
  String get catalogProvider => 'مزوّد الخدمة';

  @override
  String get catalogPolicyContract => 'الوثيقة / العقد';

  @override
  String get catalogCost => 'التكلفة';

  @override
  String get catalogNotes => 'ملاحظات';

  @override
  String get catalogServiceDocuments => 'مستندات هذه الخدمة';

  @override
  String catalogRemindersTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تتم متابعة $count تذكير',
      many: 'تتم متابعة $count تذكيرًا',
      few: 'تتم متابعة $count تذكيرات',
      two: 'تتم متابعة تذكيرين',
      one: 'تتم متابعة تذكير واحد',
    );
    return '$_temp0';
  }

  @override
  String get catalogHideDetails => 'إخفاء التفاصيل';

  @override
  String get catalogShowDetails => 'عرض كل التفاصيل';

  @override
  String get catalogType => 'النوع';

  @override
  String get catalogCategory => 'الفئة';

  @override
  String get catalogRoom => 'الغرفة';

  @override
  String get catalogModel => 'الطراز';

  @override
  String get catalogSerialShort => 'الرقم التسلسلي / التسجيل';

  @override
  String get catalogRemindersTrackedLabel => 'التذكيرات المتابَعة';

  @override
  String get catalogNextDue => 'الاستحقاق التالي';

  @override
  String catalogRemindsOffsets(String offsets) {
    return 'تنبيه قبل $offsets';
  }

  @override
  String get catalogMarkAsDone => 'وضع علامة «تم»';

  @override
  String get catalogNoRoomHint => 'بلا غرفة — يمكنك تحديدها لاحقًا';

  @override
  String get catalogNoRoom => 'بلا غرفة';

  @override
  String get catalogNewRoom => 'غرفة جديدة…';

  @override
  String get catalogAddPhoto => 'إضافة صورة';

  @override
  String get dashboardFilterByType => 'تصفية حسب النوع';

  @override
  String get dashboardUpcoming => 'تواريخ الانتهاء القادمة';

  @override
  String get dashboardGroupBy => 'تجميع حسب';

  @override
  String get dashboardGroupNone => 'التجميع: بدون';

  @override
  String get dashboardGroupAsset => 'التجميع: حسب الممتلك';

  @override
  String get dashboardEmpty => 'لا توجد تذكيرات بعد. أضف ممتلكًا للبدء.';

  @override
  String get dashboardNoMatches => 'لا شيء يطابق الأنواع المحددة.';

  @override
  String get dashboardAsset => 'الممتلك';

  @override
  String get dashboardTotalAppliances => 'إجمالي الأجهزة العاملة';

  @override
  String get filterActive => 'الخدمات الفعّالة';

  @override
  String get filterSecured => 'المؤمَّن عليها';

  @override
  String get filterSoon => 'تنتهي قريبًا';

  @override
  String get filterExpired => 'منتهية';

  @override
  String get docsTitle => 'المستندات';

  @override
  String get docsAdd => '+ إضافة';

  @override
  String get docsEmpty =>
      'لا توجد مستندات بعد. أرفق فواتير أو ضمانات أو صورًا.';

  @override
  String get docsImageLoadFailed => 'تعذّر تحميل الصورة';

  @override
  String get docKindInvoice => 'فاتورة';

  @override
  String get docKindWarranty => 'ضمان';

  @override
  String get docKindInsurance => 'تأمين';

  @override
  String get docKindManual => 'دليل';

  @override
  String get docKindPhoto => 'صورة';

  @override
  String get docKindOther => 'أخرى';

  @override
  String get familyCreateTitle => 'إنشاء عائلة';

  @override
  String get familyNameHint => 'مثل: عائلة كومار';

  @override
  String get familyJoinTitle => 'الانضمام إلى عائلة';

  @override
  String get familyInviteCodeHint => 'رمز الدعوة (مثل AB12CD34)';

  @override
  String get familyJoin => 'انضمام';

  @override
  String get familyJoined =>
      'تم الانضمام! تتم الآن مزامنة غرف العائلة وممتلكاتها وتذكيراتها.';

  @override
  String familyChangeRoleTitle(String name) {
    return 'تغيير الدور — $name';
  }

  @override
  String get familyRoleAdminHint => 'إدارة الأعضاء والممتلكات والدعوات';

  @override
  String get familyRoleViewerHint => 'وصول للقراءة فقط';

  @override
  String get familyRoleMemberHint => 'إضافة ممتلكاته الخاصة وإدارتها';

  @override
  String get familyRemoveTitle => 'إزالة العضو؟';

  @override
  String familyRemoveMessage(String name) {
    return 'سيفقد $name الوصول إلى ممتلكات هذه العائلة وتذكيراتها.';
  }

  @override
  String get familyRemove => 'إزالة';

  @override
  String get familyLeaveTitle => 'مغادرة العائلة؟';

  @override
  String get familyLeaveMessage => 'ستتوقف عن تلقي تذكيرات هذه العائلة.';

  @override
  String get familyLeave => 'مغادرة';

  @override
  String get familyEmptyTitle => 'لست في أي عائلة بعد';

  @override
  String get familyEmptyBody =>
      'أنشئ عائلة لمشاركة الممتلكات والتذكيرات، أو انضم إلى عائلة برمز دعوة.';

  @override
  String get familyJoinWithCode => 'الانضمام برمز';

  @override
  String get familyMembers => 'الأعضاء';

  @override
  String get familyInviteMember => 'دعوة عضو';

  @override
  String get familyLeaveFamily => 'مغادرة العائلة';

  @override
  String get familyCall => 'اتصال';

  @override
  String get familyWhatsapp => 'واتساب';

  @override
  String get familyChangeRole => 'تغيير الدور';

  @override
  String get familyRemoveFromFamily => 'إزالة من العائلة';

  @override
  String get familyInviteTitle => 'دعوة عضو';

  @override
  String familyInviteBody(String role) {
    return 'شارك هذا الرمز. يمكنه الانضمام بصفة $role. تنتهي صلاحيته خلال 7 أيام.';
  }

  @override
  String get familyCopyCode => 'نسخ الرمز';

  @override
  String get familyCodeCopied => 'تم نسخ رمز الدعوة';

  @override
  String get roleOwner => 'المالك';

  @override
  String get roleAdmin => 'مدير';

  @override
  String get roleMember => 'عضو';

  @override
  String get roleViewer => 'مشاهد';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عضو',
      many: '$count عضوًا',
      few: '$count أعضاء',
      two: 'عضوان',
      one: 'عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileVerified => 'موثّق';

  @override
  String get profileEditInfo => 'تعديل المعلومات الشخصية';

  @override
  String get profileNotificationPrefs => 'تفضيلات الإشعارات';

  @override
  String get profileManagedInSettings => 'تُدار من الإعدادات';

  @override
  String get profileDisplayName => 'الاسم المعروض';

  @override
  String get profilePhone => 'الهاتف (لتذكيرات واتساب)';

  @override
  String get profileDocuments => 'المستندات';

  @override
  String get profileInvite => 'دعوة';

  @override
  String get reminderAddTitle => 'إضافة تذكير';

  @override
  String get reminderEditTitle => 'تعديل التذكير';

  @override
  String get reminderSaveChanges => 'حفظ التغييرات';

  @override
  String get reminderSave => 'حفظ التذكير';

  @override
  String get reminderTypeTitle => 'نوع التذكير';

  @override
  String get reminderTypeSubtitle => 'ما الذي ينبغي أن نتابعه؟';

  @override
  String reminderDetailsTitle(String kind) {
    return 'تفاصيل $kind';
  }

  @override
  String get reminderDetailsSubtitle => 'متى يحين موعد الاستحقاق؟';

  @override
  String get reminderLabel => 'التسمية';

  @override
  String get reminderDueDate => 'تاريخ الاستحقاق';

  @override
  String get reminderRepeats => 'التكرار';

  @override
  String get reminderServiceDetails => 'تفاصيل الخدمة (اختياري)';

  @override
  String get reminderProviderHint => 'مثل: Acko';

  @override
  String get reminderPolicyNo => 'رقم الوثيقة / العقد';

  @override
  String get reminderCostHint => 'مثل: 4200';

  @override
  String get reminderNotifyTitle => 'إعدادات الإشعارات';

  @override
  String get reminderNotifySubtitle => 'إشعار دفع وتذكير لجميع أفراد العائلة.';

  @override
  String get reminderNotifyMe => 'نبّهني';

  @override
  String get reminderNoOffsets =>
      'لن يُطلَق أي تذكير لهذه الخدمة — اختر مدة تنبيه واحدة على الأقل لتصلك الإشعارات.';

  @override
  String reminderOffsetsSummary(String offsets) {
    return 'سنذكّرك قبل $offsets من تاريخ الاستحقاق عبر القنوات المفعّلة لديك (راجع الإعدادات).';
  }

  @override
  String get reminderAttachTitle => 'المرفقات';

  @override
  String get reminderAttachSubtitle =>
      'ملف PDF للوثيقة، إيصال، صور… أرفقها الآن أو لاحقًا من صفحة الممتلك.';

  @override
  String get reminderAttachDocs =>
      'إرفاق مستندات — الكاميرا أو المعرض أو الملفات';

  @override
  String get remindersEmpty => 'لا يوجد شيء هنا حاليًا.';

  @override
  String get inboxAllCaughtUp => 'لا شيء متأخر لديك 🎉';

  @override
  String get inboxOverdue => 'متأخرة';

  @override
  String get inboxComingUp => 'قادمة';

  @override
  String inboxDueIn(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'الاستحقاق بعد $days يوم — $date',
      many: 'الاستحقاق بعد $days يومًا — $date',
      few: 'الاستحقاق بعد $days أيام — $date',
      two: 'الاستحقاق بعد يومين — $date',
      one: 'الاستحقاق بعد يوم واحد — $date',
    );
    return '$_temp0';
  }

  @override
  String get lockLocked => 'مقفل';

  @override
  String get lockTapToUnlock => 'اضغط لإلغاء القفل';

  @override
  String get mfaTitle => 'التحقق بخطوتين';

  @override
  String get mfaSubtitle => 'أدخل الرمز المكوّن من 6 أرقام من تطبيق المصادقة.';

  @override
  String get mfaCodeLabel => 'رمز من 6 أرقام';

  @override
  String get securityTitle => 'الأمان';

  @override
  String get securityBiometricSection => 'قفل التطبيق';

  @override
  String get securityTwoFactorSection => 'المصادقة الثنائية';

  @override
  String get security2faEnabled => 'المصادقة الثنائية مفعّلة';

  @override
  String get securityEnable2fa => 'تفعيل المصادقة الثنائية';

  @override
  String get securityAuthenticatorApp => 'تطبيق المصادقة';

  @override
  String securityAuthenticatorSince(String date) {
    return 'تطبيق المصادقة · منذ $date';
  }

  @override
  String get securityAuthenticatorHint =>
      'استخدم Google Authenticator أو Authy أو 1Password وغيرها.';

  @override
  String get securityMoreSection => 'المزيد';

  @override
  String get securityAppLockHint => 'طلب إلغاء القفل عند إعادة فتح التطبيق';

  @override
  String get securityAutoLock => 'القفل التلقائي بعد';

  @override
  String securityMinutesShort(int minutes) {
    return '$minutes د';
  }

  @override
  String securityMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes دقيقة',
      many: '$minutes دقيقة',
      few: '$minutes دقائق',
      two: 'دقيقتان',
      one: 'دقيقة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get securityActiveSessions => 'الجلسات النشطة';

  @override
  String get securityDisable2faTitle => 'تعطيل المصادقة الثنائية؟';

  @override
  String get securityDisable2faMessage =>
      'لن يطلب حسابك رمز المصادقة لتسجيل الدخول بعد الآن.';

  @override
  String get securityDisable => 'تعطيل';

  @override
  String get securityCurrentSession => 'الجلسة الحالية';

  @override
  String securitySignedInAt(String date) {
    return 'تم تسجيل الدخول في $date';
  }

  @override
  String get securityThisDevice => 'هذا الجهاز';

  @override
  String get securitySignOutOthers => 'تسجيل الخروج من الأجهزة الأخرى';

  @override
  String get securityOthersSignedOut => 'تم تسجيل الخروج من الأجهزة الأخرى.';

  @override
  String get securitySetupTitle => 'إعداد تطبيق المصادقة';

  @override
  String get securitySetupBody =>
      'امسح رمز QR باستخدام Google Authenticator أو Authy أو 1Password وغيرها، ثم أدخل الرمز المكوّن من 6 أرقام.';

  @override
  String get securityKeyCopied => 'تم نسخ المفتاح.';

  @override
  String get securityCopyKey => 'نسخ المفتاح';

  @override
  String get securityVerifyEnable => 'تحقّق وفعّل';

  @override
  String securityAvailable(String kinds) {
    return 'المتاح: $kinds';
  }

  @override
  String get biometricFace => 'Face ID';

  @override
  String get biometricFingerprint => 'بصمة الإصبع';

  @override
  String get biometricDevice => 'القياسات الحيوية للجهاز';

  @override
  String get onboardingEyebrow1 => 'مرحبًا';

  @override
  String get onboardingTitle1 => 'لا تفوّت أي تجديد بعد اليوم';

  @override
  String get onboardingBody1 =>
      'يتابع DocsBuddy الضمانات والتأمين والفواتير والتواريخ، فلا تفاجئك المواعيد النهائية.';

  @override
  String get onboardingEyebrow2 => 'نظّم';

  @override
  String get onboardingTitle2 => 'جميع ممتلكاتك في مكان واحد';

  @override
  String get onboardingBody2 =>
      'المركبات والأجهزة المنزلية والإلكترونيات وحتى المستندات — منظّمة حسب الغرفة والفئة.';

  @override
  String get onboardingEyebrow3 => 'كن سبّاقًا';

  @override
  String get onboardingTitle3 => 'تذكيرات ذكية قبل أسابيع';

  @override
  String get onboardingBody3 =>
      'اضبط تنبيهات قبل 60 / 30 / 7 / 1 يوم. إشعارات دفع أو بريد إلكتروني أو واتساب — القرار لك.';

  @override
  String get onboardingEyebrow4 => 'معًا';

  @override
  String get onboardingTitle4 => 'أبقِ العائلة كلها على اطلاع';

  @override
  String get onboardingBody4 =>
      'ادعُ ما يصل إلى 8 أعضاء. يتلقى الجميع التذكيرات ويستطيع أي فرد التحديث — دون الاعتماد على شخص واحد.';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get onboardingHaveAccount => 'لدي حساب بالفعل';

  @override
  String get onboardingAlreadyWithUs => 'معنا من قبل؟ ';

  @override
  String get commonBack => 'رجوع';

  @override
  String get illoActiveInvoices => 'الفواتير الفعّالة';

  @override
  String get illoKitchen => 'المطبخ';

  @override
  String get illoSmartphone => 'الهاتف الذكي';

  @override
  String get illoVehicles => 'المركبات';

  @override
  String get illoPollutionDue => 'موعد فحص الانبعاثات';

  @override
  String get illoSharedWithFamily => 'مشترك مع العائلة';

  @override
  String illoBikeSample(String date) {
    return '$date · دراجة';
  }

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get appearanceSystem => 'النظام';

  @override
  String get appearanceLight => 'فاتح';

  @override
  String get appearanceDark => 'داكن';

  @override
  String get authContinueWithMicrosoft => 'المتابعة باستخدام Microsoft';

  @override
  String get startupStepServices => 'جارٍ تشغيل DocsBuddy…';

  @override
  String get startupStepAccount => 'جارٍ الاتصال بحسابك…';

  @override
  String get startupStepPreferences => 'جارٍ تحميل تفضيلاتك…';

  @override
  String startupStepCount(int step, int total) {
    return 'الخطوة $step من $total';
  }

  @override
  String get startupFailedTitle => 'تعذّر تشغيل DocsBuddy';

  @override
  String get startupFailedBody =>
      'حدث خطأ أثناء التحضير. يُرجى المحاولة مرة أخرى. إذا تكرر ذلك، أخبر الدعم بما يقوله السطر أدناه.';

  @override
  String get startupRetry => 'إعادة المحاولة';

  @override
  String get loadingSigningIn => 'جارٍ تسجيل دخولك…';

  @override
  String get loadingOpeningGoogle => 'جارٍ فتح Google…';

  @override
  String get loadingOpeningApple => 'جارٍ فتح Apple…';

  @override
  String get loadingOpeningMicrosoft => 'جارٍ فتح Microsoft…';

  @override
  String get loadingCreatingAccount => 'جارٍ إنشاء حسابك…';

  @override
  String get loadingSendingCode => 'جارٍ إرسال الرمز…';

  @override
  String get loadingSendingNewCode => 'جارٍ إرسال رمز جديد…';

  @override
  String get loadingVerifyingCode => 'جارٍ التحقق من الرمز…';

  @override
  String get loadingUpdatingPassword => 'جارٍ تحديث كلمة المرور…';

  @override
  String get loadingSigningOut => 'جارٍ تسجيل خروجك…';

  @override
  String get loadingSavingAsset => 'جارٍ حفظ الممتلك…';

  @override
  String get loadingSavingReminder => 'جارٍ حفظ التذكير…';

  @override
  String get loadingDeletingAsset => 'جارٍ حذف الممتلك…';

  @override
  String get loadingDeletingReminder => 'جارٍ حذف التذكير…';

  @override
  String get loadingUploadingPhoto => 'جارٍ رفع الصورة…';

  @override
  String get loadingCreatingRoom => 'جارٍ إنشاء الغرفة…';

  @override
  String get loadingRenamingRoom => 'جارٍ إعادة تسمية الغرفة…';

  @override
  String get loadingSavingRoomOrder => 'جارٍ حفظ ترتيب الغرف…';

  @override
  String get loadingCreatingFamily => 'جارٍ إنشاء عائلتك…';

  @override
  String get loadingJoiningFamily => 'جارٍ الانضمام إلى العائلة…';

  @override
  String get loadingCreatingInvite => 'جارٍ إنشاء الدعوة…';

  @override
  String get loadingUpdatingRole => 'جارٍ تحديث الدور…';

  @override
  String get loadingRemovingMember => 'جارٍ إزالة العضو…';

  @override
  String get loadingLeavingFamily => 'جارٍ مغادرة العائلة…';

  @override
  String get loadingUploadingDocument => 'جارٍ رفع المستند…';

  @override
  String get loadingOpeningDocument => 'جارٍ فتح المستند…';

  @override
  String get loadingPreparingDocument => 'جارٍ تجهيز المستند للمشاركة…';

  @override
  String get loadingDeletingDocument => 'جارٍ حذف المستند…';

  @override
  String get loadingSavingSettings => 'جارٍ حفظ الإعدادات…';

  @override
  String get loadingPreparingAuthenticator =>
      'جارٍ تجهيز إعداد تطبيق المصادقة…';

  @override
  String get loadingTurningOffTwoStep => 'جارٍ إيقاف التحقق بخطوتين…';

  @override
  String get loadingSigningOutOthers => 'جارٍ تسجيل الخروج من الأجهزة الأخرى…';

  @override
  String get loadingMarkingDone => 'جارٍ وضع علامة «تم»…';

  @override
  String get loadingSavingProfile => 'جارٍ حفظ ملفك الشخصي…';

  @override
  String get loadingImage => 'جارٍ تحميل الصورة…';

  @override
  String get loadingDashboard => 'جارٍ تحميل لوحتك…';

  @override
  String get loadingAssets => 'جارٍ تحميل ممتلكاتك…';

  @override
  String get loadingCategories => 'جارٍ تحميل الفئات…';

  @override
  String get loadingRoom => 'جارٍ تحميل الغرفة…';

  @override
  String get loadingAsset => 'جارٍ تحميل الممتلك…';

  @override
  String get loadingReminders => 'جارٍ تحميل التذكيرات…';

  @override
  String get loadingDocuments => 'جارٍ تحميل المستندات…';

  @override
  String get loadingRooms => 'جارٍ تحميل الغرف…';

  @override
  String get loadingFamily => 'جارٍ تحميل عائلتك…';

  @override
  String get loadingProfile => 'جارٍ تحميل ملفك الشخصي…';

  @override
  String get loadingNotifications => 'جارٍ تحميل الإشعارات…';

  @override
  String get loadingSecurity => 'جارٍ فحص إعدادات الأمان…';

  @override
  String authTermsAgreement(String terms, String privacy) {
    return 'أوافق على $terms و$privacy.';
  }

  @override
  String catalogRoomSummary(String appliances) {
    return 'قلب منزلك، ويضم $appliances.';
  }

  @override
  String reminderForAsset(String asset) {
    return 'لـ $asset';
  }

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get languageAutomatic => 'تلقائي';

  @override
  String get languageAutomaticHint => 'يتبع لغة جهازك';

  @override
  String get languageSheetTitle => 'اختر اللغة';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get errorEmailNotConfirmed =>
      'يُرجى تأكيد بريدك الإلكتروني أولًا — تحقّق من بريدك الوارد.';

  @override
  String get errorUserExists =>
      'يوجد حساب مسجّل بهذا البريد الإلكتروني بالفعل.';

  @override
  String get errorWeakPassword => 'كلمة المرور هذه ضعيفة جدًا. اختر كلمة أقوى.';

  @override
  String get errorRateLimited =>
      'محاولات كثيرة جدًا. انتظر قليلًا ثم حاول مرة أخرى.';

  @override
  String get errorCodeInvalid => 'الرمز غير صحيح أو انتهت صلاحيته.';

  @override
  String get errorSamePassword => 'اختر كلمة مرور لم تستخدمها من قبل.';

  @override
  String get notificationDueToday => 'يستحق اليوم';

  @override
  String notificationDueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'يستحق بعد $days يوم',
      many: 'يستحق بعد $days يومًا',
      few: 'يستحق بعد $days أيام',
      two: 'يستحق بعد يومين',
      one: 'يستحق بعد يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String commonStepOf(int step, int total) {
    return 'الخطوة $step من $total';
  }

  @override
  String get lockPromptUnlock => 'إلغاء قفل DocsBuddy';

  @override
  String get lockPromptEnable => 'أكّد لتفعيل قفل التطبيق';

  @override
  String get lockToggleFace => 'القفل باستخدام Face ID';

  @override
  String get lockToggleFingerprint => 'القفل ببصمة الإصبع';

  @override
  String get lockToggleFaceOrFingerprint => 'القفل بـ Face ID أو بصمة الإصبع';

  @override
  String get lockToggleBiometrics => 'القفل بالقياسات الحيوية';

  @override
  String get lockToggleDevice => 'القفل بقفل الشاشة';

  @override
  String get lockNeedsScreenLock =>
      'اضبط قفل الشاشة أو بصمة الإصبع أو الوجه على هذا الجهاز لاستخدام قفل التطبيق.';

  @override
  String get lockFailed => 'لم يتم التعرّف عليك. حاول مرة أخرى.';

  @override
  String get lockTooManyAttempts =>
      'محاولات كثيرة جدًا. انتظر قليلًا أو استخدم رمز PIN الخاص بجهازك.';

  @override
  String get lockUnavailableBody =>
      'لم يتم ضبط قفل للشاشة على هذا الجهاز، لذلك لا يمكن قفل التطبيق.';

  @override
  String get lockTurnOff => 'إيقاف قفل التطبيق';

  @override
  String get lockError => 'تعذّر التحقق من هويتك. يُرجى المحاولة مرة أخرى.';

  @override
  String get featureComingSoon => 'قريبًا';
}
