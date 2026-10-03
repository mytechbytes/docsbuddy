// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get commonCancel => '取消';

  @override
  String get commonSave => '保存';

  @override
  String get commonOn => '开';

  @override
  String get commonOff => '关';

  @override
  String get commonEmail => '电子邮箱';

  @override
  String get commonPassword => '密码';

  @override
  String get commonEmailHint => 'you@example.com';

  @override
  String get commonSignIn => '登录';

  @override
  String get commonSignOut => '退出登录';

  @override
  String get commonSettings => '设置';

  @override
  String get commonFamily => '家庭';

  @override
  String get commonNotifications => '通知';

  @override
  String get commonChangePassword => '修改密码';

  @override
  String get commonForgotPassword => '忘记密码？';

  @override
  String get navHome => '首页';

  @override
  String get navRooms => '房间';

  @override
  String get navAssets => '物品';

  @override
  String get authSignInCta => '登录';

  @override
  String get authNoAccountLead => '还没有账号？';

  @override
  String get authSignUpAction => '注册';

  @override
  String get authOrContinueWith => '或使用以下方式继续';

  @override
  String get authContinueWithGoogle => '使用 Google 继续';

  @override
  String get authContinueWithApple => '使用 Apple 继续';

  @override
  String get authFullName => '姓名';

  @override
  String get authFullNameHint => '你的姓名';

  @override
  String get authCreateAccountCta => '创建账号';

  @override
  String get authHaveAccountLead => '已有账号？';

  @override
  String get authTermsOfService => '服务条款';

  @override
  String get authPrivacyPolicy => '隐私政策';

  @override
  String get authForgotSendCode => '发送验证码';

  @override
  String get authRememberLead => '想起来了？';

  @override
  String get authBackToSignIn => '返回登录';

  @override
  String get authOtpTitle => '请查看你的收件箱';

  @override
  String authOtpSubtitle(String email) {
    return '我们已向 $email 发送了 6 位验证码。请在下方输入以继续。';
  }

  @override
  String get authOtpVerify => '验证';

  @override
  String authOtpResendIn(String time) {
    return '没有收到？$time 后可重新发送';
  }

  @override
  String get authOtpNotReceivedLead => '没有收到？';

  @override
  String get authOtpResend => '重新发送验证码';

  @override
  String get authResetTitle => '设置新密码';

  @override
  String get authNewPassword => '新密码';

  @override
  String get authConfirmPassword => '确认密码';

  @override
  String get authResetCta => '重置密码';

  @override
  String get authPasswordMustHave => '密码必须包含';

  @override
  String get authRuleLength => '至少 8 个字符';

  @override
  String get authRuleUpper => '一个大写字母';

  @override
  String get authRuleNumber => '一个数字';

  @override
  String get authRuleSpecial => '一个特殊字符（!@#\$…）';

  @override
  String get authResetDone => '密码已更新，请登录。';

  @override
  String get settingsSectionAccount => '账号';

  @override
  String get settingsPersonalInfo => '个人信息';

  @override
  String get settingsSecurity => '安全与双重验证';

  @override
  String get settingsPush => '推送通知';

  @override
  String get settingsEmailReminders => '邮件提醒';

  @override
  String get settingsWhatsappReminders => 'WhatsApp 提醒';

  @override
  String get settingsDefaultOffsets => '默认提前天数';

  @override
  String get settingsQuietHours => '免打扰时段';

  @override
  String get settingsQuietHoursStart => '免打扰开始时间';

  @override
  String get settingsQuietHoursEnd => '免打扰结束时间';

  @override
  String get settingsManageFamily => '管理家庭';

  @override
  String get settingsSectionApp => '应用';

  @override
  String get settingsBackend => '后端';

  @override
  String get settingsTestNotification => '发送测试通知';

  @override
  String get settingsTestNotificationSent => '已发送测试通知。';

  @override
  String get settingsNotificationsBlocked => '系统设置中已禁用通知。';

  @override
  String get settingsRoadmap => '路线图';

  @override
  String get settingsReplayOnboarding => '重新查看引导';

  @override
  String get settingsOffsetsTitle => '默认提醒提前天数';

  @override
  String get settingsOffsetsSubtitle => '在到期日前多少天提醒你，用于新建的提醒。';

  @override
  String settingsDaysBefore(int days) {
    return '提前 $days 天';
  }

  @override
  String get changePasswordTitle => '修改密码';

  @override
  String get changePasswordCurrent => '当前密码';

  @override
  String get changePasswordConfirm => '确认新密码';

  @override
  String get changePasswordCta => '更新密码';

  @override
  String get changePasswordDone => '密码已更新。';

  @override
  String get authForgotSubtitle => '别担心。输入你的邮箱，我们会发送一个 6 位验证码用于重置密码。';

  @override
  String get authResetSubtitle => '请选择一个你在此之前没有用过的强密码。';

  @override
  String get changePasswordNotice => '为了你的账号安全，修改密码后你将在其他设备上退出登录。';

  @override
  String get errorNetwork => '无法连接到服务器，请检查网络连接。';

  @override
  String get errorUnknown => '出了点问题，请重试。';

  @override
  String get errorNotSignedIn => '你已退出登录，请重新登录。';

  @override
  String get errorNameRequired => '请输入名称。';

  @override
  String get errorRoomNameRequired => '请为房间命名。';

  @override
  String get errorFamilyNameRequired => '请输入家庭名称。';

  @override
  String get errorInviteCodeInvalid => '请输入有效的邀请码。';

  @override
  String get errorOwnerRoleLocked => '无法更改所有者的角色。';

  @override
  String get errorOwnerNotRemovable => '无法移除所有者。';

  @override
  String get errorNoActiveFamily => '当前没有可用的家庭。';

  @override
  String get errorFamilyRequired => '请先加入或创建一个家庭。';

  @override
  String get errorJoinedFamilyUnavailable => '无法加载已加入的家庭。';

  @override
  String get errorPhoneFormat => '请使用国际格式，例如 +91 9812345678。';

  @override
  String get errorTermsRequired => '请先接受条款以继续。';

  @override
  String get errorPasswordRequirements => '请满足密码要求。';

  @override
  String get errorPasswordMismatch => '两次输入的密码不一致。';

  @override
  String get errorNewPasswordTooShort => '新密码至少需要 8 个字符。';

  @override
  String get errorCurrentPasswordIncorrect => '当前密码不正确。';

  @override
  String get errorOffsetsRequired => '请至少选择一个提醒提前时间。';

  @override
  String get errorNoAuthenticator => '尚未绑定验证器。';

  @override
  String get errorTotpUnavailable => '验证器设置暂时不可用。';

  @override
  String get errorCodeLength => '请输入 6 位验证码。';

  @override
  String errorUploadsFailed(int failed, int total) {
    return '$total 个上传中有 $failed 个失败。';
  }

  @override
  String get errorFilesUnavailable => '请连接后端以打开或分享文件。';

  @override
  String get errorAppOpenFailed => '无法打开该应用。';

  @override
  String get errorNotificationsBlocked => '系统设置中已禁用通知。';

  @override
  String get errorSignInIncomplete => '登录未完成，请重试。';

  @override
  String get commonAdd => '添加';

  @override
  String get commonEdit => '编辑';

  @override
  String get commonDelete => '删除';

  @override
  String get commonDone => '完成';

  @override
  String get commonNext => '下一步';

  @override
  String get commonSkip => '跳过';

  @override
  String get commonOptional => '可选';

  @override
  String get commonNoMatches => '没有匹配项。';

  @override
  String get commonCreate => '创建';

  @override
  String get commonRetry => '重试';

  @override
  String get commonView => '查看';

  @override
  String get commonShare => '分享';

  @override
  String get commonApply => '应用';

  @override
  String get commonClear => '清除';

  @override
  String durationDaysShort(int days) {
    return '$days天';
  }

  @override
  String get kindInsurance => '保险';

  @override
  String get kindPollution => '尾气检测';

  @override
  String get kindAmc => 'AMC';

  @override
  String get kindService => '保养';

  @override
  String get kindTax => '税费';

  @override
  String get kindWarranty => '保修';

  @override
  String get kindRegistration => '登记';

  @override
  String get kindFitness => '车检';

  @override
  String get kindOther => '其他';

  @override
  String get groupVehicle => '车辆';

  @override
  String get groupAppliance => '家电';

  @override
  String get groupElectronics => '电子产品';

  @override
  String get groupDocument => '文件';

  @override
  String get groupOther => '其他';

  @override
  String get recurrenceNone => '无';

  @override
  String get recurrenceNever => '从不';

  @override
  String get recurrenceMonthly => '每月';

  @override
  String get recurrenceQuarterly => '每季度';

  @override
  String get recurrenceHalfYearly => '每半年';

  @override
  String get recurrenceYearly => '每年';

  @override
  String dueOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '已逾期 $days 天',
    );
    return '$_temp0';
  }

  @override
  String get dueToday => '今天到期';

  @override
  String dueDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '还剩 $days 天',
    );
    return '$_temp0';
  }

  @override
  String relativeDaysAgo(int days) {
    return '$days天前';
  }

  @override
  String relativeInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days 天后',
    );
    return '$_temp0';
  }

  @override
  String get pillOverdue => '已逾期';

  @override
  String get pillToday => '今天';

  @override
  String get catalogAddAsset => '添加物品';

  @override
  String get catalogEditAsset => '编辑物品';

  @override
  String get catalogDeleteAsset => '删除物品';

  @override
  String get catalogSaveChanges => '保存更改';

  @override
  String get catalogSaveAsset => '保存物品';

  @override
  String get catalogCustomTypeTitle => '自定义设备类型';

  @override
  String get catalogCustomTypeHint => '例如：洗碗机、逆变器、摄像头…';

  @override
  String get catalogUseType => '使用此类型';

  @override
  String get catalogChooseCategory => '选择类别';

  @override
  String get catalogChooseCategorySubtitle => '你要添加哪一类物品？';

  @override
  String get catalogSelectAppliance => '选择你的设备';

  @override
  String catalogNoPresetTypes(String group) {
    return '$group 没有预设类型，请使用自定义类型或跳过。';
  }

  @override
  String catalogTypesIn(String group) {
    return '$group 的类型；选择一个或添加你自己的。';
  }

  @override
  String get catalogOthers => '其他';

  @override
  String get catalogDetails => '详细信息';

  @override
  String get catalogOnlyNameRequired => '只有名称是必填项。';

  @override
  String get catalogName => '名称';

  @override
  String get catalogNameHint => '例如：三星 340L 冰箱';

  @override
  String get catalogRoomOptional => '房间（可选）';

  @override
  String get catalogNewRoomHint => '新房间名称，例如：厨房';

  @override
  String get catalogBrand => '品牌';

  @override
  String get catalogModelNumber => '型号';

  @override
  String get catalogSerialNo => '序列号 / 登记号';

  @override
  String get catalogSerialHint => '例如：TN 01 AB 1234';

  @override
  String get catalogPurchaseDate => '购买日期';

  @override
  String get catalogPurchasePrice => '购买价格';

  @override
  String get catalogPriceHint => '例如：42000';

  @override
  String get catalogStore => '购买店铺';

  @override
  String get catalogStoreHint => '例如：Croma';

  @override
  String catalogDetailsFor(String name) {
    return '$name 的详细信息';
  }

  @override
  String get catalogThisAppliance => '此设备';

  @override
  String get catalogPropertyHint => '例如：颜色';

  @override
  String get catalogValueHint => '值';

  @override
  String get catalogAddProperty => '添加属性';

  @override
  String get catalogAmcDate => 'AMC 日期';

  @override
  String get catalogInvoices => '发票 / 收据';

  @override
  String get catalogAttachInvoice => '添加发票：相机、相册或文件';

  @override
  String catalogWillAutoAdd(String services) {
    return '将自动添加：$services';
  }

  @override
  String get catalogSelectYourAppliance => '选择你的设备';

  @override
  String get catalogSearchAppliance => '搜索你的设备';

  @override
  String get catalogNoMatchingAppliance => '没有匹配的设备，请使用下方的“其他”。';

  @override
  String get catalogSomethingElse => '其他';

  @override
  String catalogAllReminders(int count) {
    return '全部提醒 · $count';
  }

  @override
  String get catalogNoRemindersForAsset => '此物品还没有提醒。';

  @override
  String get catalogMarkDoneTitle => '标记为已完成？';

  @override
  String catalogMarkDoneOneOff(String label) {
    return '“$label”将被标记为完成，并从待办提醒中移除。';
  }

  @override
  String catalogMarkDoneRecurring(String label, String recurrence) {
    return '“$label”将被标记为完成，并安排下一个到期日（$recurrence）。';
  }

  @override
  String get catalogMarkDone => '标记完成';

  @override
  String catalogMarkedDone(String label) {
    return '$label已标记为完成。';
  }

  @override
  String catalogDoneRescheduled(String label) {
    return '$label已完成，已安排下一个到期日。';
  }

  @override
  String get catalogDeleteReminderTitle => '删除提醒？';

  @override
  String catalogDeleteReminderMessage(String label) {
    return '“$label”及其已安排的通知将被删除。';
  }

  @override
  String get catalogDeleteAssetTitle => '删除物品？';

  @override
  String catalogDeleteAssetMessage(String name) {
    return '“$name”及其所有提醒和文件将被删除，此操作无法撤销。';
  }

  @override
  String get catalogNoAssets => '还没有物品。点按“添加物品”。';

  @override
  String get catalogRoomNotFound => '未找到该房间。';

  @override
  String get catalogAddRoomPhoto => '添加房间照片';

  @override
  String catalogApplianceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件设备',
    );
    return '$_temp0';
  }

  @override
  String get catalogAppliances => '设备';

  @override
  String get catalogNothingRegistered => '这里还没有登记任何内容。';

  @override
  String get catalogAddHere => '在此添加';

  @override
  String get catalogRenameRoom => '重命名房间';

  @override
  String catalogSince(String date) {
    return '自 $date';
  }

  @override
  String get catalogNoRemindersOnAppliance => '此设备还没有提醒。';

  @override
  String get catalogCreateRoom => '创建房间';

  @override
  String get catalogNoRooms => '还没有房间。请在上方添加你的第一个房间。';

  @override
  String get catalogAddRoomPhotoLong => '添加房间照片：相机或设备';

  @override
  String get catalogRoomNameHint => '房间名称，例如：厨房';

  @override
  String get catalogAddNewRoom => '添加新房间';

  @override
  String catalogRegisteredCount(int count) {
    return '已登记 $count 项';
  }

  @override
  String get catalogSearchHint => '搜索物品、服务、保单号…';

  @override
  String get catalogSearchEmpty => '输入关键词以搜索你的物品和提醒。';

  @override
  String get catalogReminders => '提醒';

  @override
  String get catalogDue => '到期';

  @override
  String get catalogOneOff => '仅一次';

  @override
  String get catalogReminds => '提醒时间';

  @override
  String get catalogProvider => '服务商';

  @override
  String get catalogPolicyContract => '保单 / 合同';

  @override
  String get catalogCost => '费用';

  @override
  String get catalogNotes => '备注';

  @override
  String get catalogServiceDocuments => '此服务的文件';

  @override
  String catalogRemindersTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在跟踪 $count 个提醒',
    );
    return '$_temp0';
  }

  @override
  String get catalogHideDetails => '收起详情';

  @override
  String get catalogShowDetails => '显示全部详情';

  @override
  String get catalogType => '类型';

  @override
  String get catalogCategory => '类别';

  @override
  String get catalogRoom => '房间';

  @override
  String get catalogModel => '型号';

  @override
  String get catalogSerialShort => '序列号 / 登记号';

  @override
  String get catalogRemindersTrackedLabel => '跟踪中的提醒';

  @override
  String get catalogNextDue => '下次到期';

  @override
  String catalogRemindsOffsets(String offsets) {
    return '提前 $offsets 提醒';
  }

  @override
  String get catalogMarkAsDone => '标记完成';

  @override
  String get catalogNoRoomHint => '未选择房间，之后可以再设置';

  @override
  String get catalogNoRoom => '无房间';

  @override
  String get catalogNewRoom => '新房间…';

  @override
  String get catalogAddPhoto => '添加照片';

  @override
  String get dashboardFilterByType => '按类型筛选';

  @override
  String get dashboardUpcoming => '即将到期';

  @override
  String get dashboardGroupBy => '分组方式';

  @override
  String get dashboardGroupNone => '分组：无';

  @override
  String get dashboardGroupAsset => '分组：物品';

  @override
  String get dashboardEmpty => '还没有提醒。添加一件物品即可开始。';

  @override
  String get dashboardNoMatches => '没有符合所选类型的内容。';

  @override
  String get dashboardAsset => '物品';

  @override
  String get dashboardTotalAppliances => '在用设备总数';

  @override
  String get filterActive => '有效服务';

  @override
  String get filterSecured => '受保障';

  @override
  String get filterSoon => '即将到期';

  @override
  String get filterExpired => '已过期';

  @override
  String get docsTitle => '文件';

  @override
  String get docsAdd => '+ 添加';

  @override
  String get docsEmpty => '还没有文件。可添加发票、保修单或照片。';

  @override
  String get docsImageLoadFailed => '无法加载图片';

  @override
  String get docKindInvoice => '发票';

  @override
  String get docKindWarranty => '保修单';

  @override
  String get docKindInsurance => '保险';

  @override
  String get docKindManual => '说明书';

  @override
  String get docKindPhoto => '照片';

  @override
  String get docKindOther => '其他';

  @override
  String get familyCreateTitle => '创建家庭';

  @override
  String get familyNameHint => '例如：库马尔一家';

  @override
  String get familyJoinTitle => '加入家庭';

  @override
  String get familyInviteCodeHint => '邀请码（例如 AB12CD34）';

  @override
  String get familyJoin => '加入';

  @override
  String get familyJoined => '已加入！家庭的房间、物品和提醒正在同步。';

  @override
  String familyChangeRoleTitle(String name) {
    return '更改角色：$name';
  }

  @override
  String get familyRoleAdminHint => '管理成员、物品和邀请';

  @override
  String get familyRoleViewerHint => '只读权限';

  @override
  String get familyRoleMemberHint => '添加并管理自己的物品';

  @override
  String get familyRemoveTitle => '移除成员？';

  @override
  String familyRemoveMessage(String name) {
    return '$name 将无法再访问这个家庭的物品和提醒。';
  }

  @override
  String get familyRemove => '移除';

  @override
  String get familyLeaveTitle => '退出家庭？';

  @override
  String get familyLeaveMessage => '你将不再收到这个家庭的提醒。';

  @override
  String get familyLeave => '退出';

  @override
  String get familyEmptyTitle => '你还没有加入任何家庭';

  @override
  String get familyEmptyBody => '创建一个家庭来共享物品和提醒，或使用邀请码加入已有的家庭。';

  @override
  String get familyJoinWithCode => '使用邀请码加入';

  @override
  String get familyMembers => '成员';

  @override
  String get familyInviteMember => '邀请成员';

  @override
  String get familyLeaveFamily => '退出家庭';

  @override
  String get familyCall => '拨打电话';

  @override
  String get familyWhatsapp => 'WhatsApp';

  @override
  String get familyChangeRole => '更改角色';

  @override
  String get familyRemoveFromFamily => '移出家庭';

  @override
  String get familyInviteTitle => '邀请成员';

  @override
  String familyInviteBody(String role) {
    return '分享此邀请码，对方可以以$role身份加入。7 天后过期。';
  }

  @override
  String get familyCopyCode => '复制邀请码';

  @override
  String get familyCodeCopied => '邀请码已复制';

  @override
  String get roleOwner => '所有者';

  @override
  String get roleAdmin => '管理员';

  @override
  String get roleMember => '成员';

  @override
  String get roleViewer => '查看者';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位成员',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => '个人资料';

  @override
  String get profileVerified => '已验证';

  @override
  String get profileEditInfo => '编辑个人信息';

  @override
  String get profileNotificationPrefs => '通知偏好';

  @override
  String get profileManagedInSettings => '在设置中管理';

  @override
  String get profileDisplayName => '显示名称';

  @override
  String get profilePhone => '手机号（用于 WhatsApp 提醒）';

  @override
  String get profileDocuments => '文件';

  @override
  String get profileInvite => '邀请';

  @override
  String get reminderAddTitle => '添加提醒';

  @override
  String get reminderEditTitle => '编辑提醒';

  @override
  String get reminderSaveChanges => '保存更改';

  @override
  String get reminderSave => '保存提醒';

  @override
  String get reminderTypeTitle => '提醒类型';

  @override
  String get reminderTypeSubtitle => '需要跟踪什么？';

  @override
  String reminderDetailsTitle(String kind) {
    return '$kind详情';
  }

  @override
  String get reminderDetailsSubtitle => '什么时候到期？';

  @override
  String get reminderLabel => '标签';

  @override
  String get reminderDueDate => '到期日期';

  @override
  String get reminderRepeats => '重复';

  @override
  String get reminderServiceDetails => '服务详情（可选）';

  @override
  String get reminderProviderHint => '例如：Acko';

  @override
  String get reminderPolicyNo => '保单 / 合同编号';

  @override
  String get reminderCostHint => '例如：4200';

  @override
  String get reminderNotifyTitle => '通知设置';

  @override
  String get reminderNotifySubtitle => '向所有家庭成员发送推送通知和提醒。';

  @override
  String get reminderNotifyMe => '提醒我';

  @override
  String get reminderNoOffsets => '此服务不会触发任何提醒，请至少选择一个提前时间以接收通知。';

  @override
  String reminderOffsetsSummary(String offsets) {
    return '将在到期日前$offsets通过你已启用的渠道提醒你（见设置）。';
  }

  @override
  String get reminderAttachTitle => '附件';

  @override
  String get reminderAttachSubtitle => '保单 PDF、收据、照片…现在添加，或稍后在物品页面添加。';

  @override
  String get reminderAttachDocs => '添加文件：相机、相册或文件';

  @override
  String get remindersEmpty => '这里暂时没有内容。';

  @override
  String get inboxAllCaughtUp => '全部处理完毕 🎉';

  @override
  String get inboxOverdue => '已逾期';

  @override
  String get inboxComingUp => '即将到来';

  @override
  String inboxDueIn(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days 天后到期，$date',
    );
    return '$_temp0';
  }

  @override
  String get lockLocked => '已锁定';

  @override
  String get lockTapToUnlock => '点按解锁';

  @override
  String get mfaTitle => '双重验证';

  @override
  String get mfaSubtitle => '请输入验证器应用中的 6 位验证码。';

  @override
  String get mfaCodeLabel => '6 位验证码';

  @override
  String get securityTitle => '安全';

  @override
  String get securityBiometricSection => '生物识别登录';

  @override
  String get securityUnlockBiometrics => '使用生物识别解锁';

  @override
  String get securityNoBiometrics => '此设备不支持生物识别';

  @override
  String get securityTwoFactorSection => '双重验证';

  @override
  String get security2faEnabled => '已启用双重验证';

  @override
  String get securityEnable2fa => '启用双重验证';

  @override
  String get securityAuthenticatorApp => '验证器应用';

  @override
  String securityAuthenticatorSince(String date) {
    return '验证器应用 · 自 $date';
  }

  @override
  String get securityAuthenticatorHint =>
      '可使用 Google Authenticator、Authy、1Password 等。';

  @override
  String get securityMoreSection => '更多';

  @override
  String get securityAppLock => '应用锁';

  @override
  String get securityAppLockHint => '重新打开应用时需要解锁';

  @override
  String get securityAutoLock => '自动锁定时间';

  @override
  String securityMinutesShort(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String securityMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String get securityActiveSessions => '活跃会话';

  @override
  String get securityDisable2faTitle => '关闭双重验证？';

  @override
  String get securityDisable2faMessage => '登录你的账号将不再需要验证器验证码。';

  @override
  String get securityDisable => '关闭';

  @override
  String get securityCurrentSession => '当前会话';

  @override
  String securitySignedInAt(String date) {
    return '登录于 $date';
  }

  @override
  String get securityThisDevice => '本设备';

  @override
  String get securitySignOutOthers => '退出其他设备';

  @override
  String get securityOthersSignedOut => '已退出其他设备。';

  @override
  String get securitySetupTitle => '设置验证器应用';

  @override
  String get securitySetupBody =>
      '使用 Google Authenticator、Authy、1Password 等扫描二维码，然后输入 6 位验证码。';

  @override
  String get securityKeyCopied => '密钥已复制。';

  @override
  String get securityCopyKey => '复制密钥';

  @override
  String get securityVerifyEnable => '验证并启用';

  @override
  String securityAvailable(String kinds) {
    return '可用：$kinds';
  }

  @override
  String get biometricFace => 'Face ID';

  @override
  String get biometricFingerprint => '指纹';

  @override
  String get biometricDevice => '设备生物识别';

  @override
  String get onboardingEyebrow1 => '欢迎';

  @override
  String get onboardingTitle1 => '再也不会错过续期';

  @override
  String get onboardingBody1 => 'DocsBuddy 帮你记录保修、保险、账单和各类日期，让截止日期不再悄悄逼近。';

  @override
  String get onboardingEyebrow2 => '整理';

  @override
  String get onboardingTitle2 => '所有物品集中管理';

  @override
  String get onboardingBody2 => '车辆、家电、电子产品，甚至文件，都按房间和类别整理。';

  @override
  String get onboardingEyebrow3 => '抢先一步';

  @override
  String get onboardingTitle3 => '智能提醒，提前数周';

  @override
  String get onboardingBody3 =>
      '可设置提前 60 / 30 / 7 / 1 天的提醒。推送、邮件或 WhatsApp，由你选择。';

  @override
  String get onboardingEyebrow4 => '共同管理';

  @override
  String get onboardingTitle4 => '让全家保持同步';

  @override
  String get onboardingBody4 => '最多可邀请 8 位成员。每个人都会收到提醒，任何人都可以更新，不再依赖某一个人。';

  @override
  String get onboardingGetStarted => '开始使用';

  @override
  String get onboardingHaveAccount => '我已有账号';

  @override
  String get onboardingAlreadyWithUs => '已经是用户？';

  @override
  String get commonBack => '返回';

  @override
  String get illoActiveInvoices => '有效发票';

  @override
  String get illoKitchen => '厨房';

  @override
  String get illoSmartphone => '智能手机';

  @override
  String get illoVehicles => '车辆';

  @override
  String get illoPollutionDue => '尾气检测将到期';

  @override
  String get illoSharedWithFamily => '与家人共享';

  @override
  String illoBikeSample(String date) {
    return '$date · 摩托车';
  }

  @override
  String get settingsAppearance => '外观';

  @override
  String get appearanceSystem => '跟随系统';

  @override
  String get appearanceLight => '浅色';

  @override
  String get appearanceDark => '深色';

  @override
  String get authContinueWithMicrosoft => '使用 Microsoft 继续';

  @override
  String get startupStepServices => '正在启动 DocsBuddy…';

  @override
  String get startupStepAccount => '正在连接你的账号…';

  @override
  String get startupStepPreferences => '正在加载你的偏好设置…';

  @override
  String startupStepCount(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String get startupFailedTitle => '无法启动 DocsBuddy';

  @override
  String get startupFailedBody => '准备过程中出了点问题，请重试。如果问题持续出现，请把下方那行文字告诉客服。';

  @override
  String get startupRetry => '重试';

  @override
  String get loadingSigningIn => '正在登录…';

  @override
  String get loadingOpeningGoogle => '正在打开 Google…';

  @override
  String get loadingOpeningApple => '正在打开 Apple…';

  @override
  String get loadingOpeningMicrosoft => '正在打开 Microsoft…';

  @override
  String get loadingCreatingAccount => '正在创建你的账号…';

  @override
  String get loadingSendingCode => '正在发送验证码…';

  @override
  String get loadingSendingNewCode => '正在发送新的验证码…';

  @override
  String get loadingVerifyingCode => '正在验证你的验证码…';

  @override
  String get loadingUpdatingPassword => '正在更新你的密码…';

  @override
  String get loadingSigningOut => '正在退出登录…';

  @override
  String get loadingSavingAsset => '正在保存你的物品…';

  @override
  String get loadingSavingReminder => '正在保存你的提醒…';

  @override
  String get loadingDeletingAsset => '正在删除物品…';

  @override
  String get loadingDeletingReminder => '正在删除提醒…';

  @override
  String get loadingUploadingPhoto => '正在上传照片…';

  @override
  String get loadingCreatingRoom => '正在创建房间…';

  @override
  String get loadingRenamingRoom => '正在重命名房间…';

  @override
  String get loadingSavingRoomOrder => '正在保存房间顺序…';

  @override
  String get loadingCreatingFamily => '正在创建你的家庭…';

  @override
  String get loadingJoiningFamily => '正在加入家庭…';

  @override
  String get loadingCreatingInvite => '正在创建邀请…';

  @override
  String get loadingUpdatingRole => '正在更新角色…';

  @override
  String get loadingRemovingMember => '正在移除成员…';

  @override
  String get loadingLeavingFamily => '正在退出家庭…';

  @override
  String get loadingUploadingDocument => '正在上传文件…';

  @override
  String get loadingOpeningDocument => '正在打开文件…';

  @override
  String get loadingPreparingDocument => '正在准备要分享的文件…';

  @override
  String get loadingDeletingDocument => '正在删除文件…';

  @override
  String get loadingSavingSettings => '正在保存设置…';

  @override
  String get loadingPreparingAuthenticator => '正在准备验证器设置…';

  @override
  String get loadingTurningOffTwoStep => '正在关闭双重验证…';

  @override
  String get loadingSigningOutOthers => '正在退出其他设备…';

  @override
  String get loadingMarkingDone => '正在标记为完成…';

  @override
  String get loadingSavingProfile => '正在保存你的资料…';

  @override
  String get loadingImage => '正在加载图片…';

  @override
  String get loadingDashboard => '正在加载你的仪表盘…';

  @override
  String get loadingAssets => '正在加载你的物品…';

  @override
  String get loadingCategories => '正在加载类别…';

  @override
  String get loadingRoom => '正在加载房间…';

  @override
  String get loadingAsset => '正在加载物品…';

  @override
  String get loadingReminders => '正在加载提醒…';

  @override
  String get loadingDocuments => '正在加载文件…';

  @override
  String get loadingRooms => '正在加载房间…';

  @override
  String get loadingFamily => '正在加载你的家庭…';

  @override
  String get loadingProfile => '正在加载你的资料…';

  @override
  String get loadingNotifications => '正在加载通知…';

  @override
  String get loadingSecurity => '正在检查安全设置…';

  @override
  String authTermsAgreement(String terms, String privacy) {
    return '我已阅读并同意$terms和$privacy。';
  }

  @override
  String catalogRoomSummary(String appliances) {
    return '你家的核心区域，共有$appliances。';
  }

  @override
  String reminderForAsset(String asset) {
    return '物品：$asset';
  }

  @override
  String get settingsLanguage => '语言';

  @override
  String get languageAutomatic => '自动';

  @override
  String get languageAutomaticHint => '跟随你的设备语言';

  @override
  String get languageSheetTitle => '选择语言';

  @override
  String get errorInvalidCredentials => '邮箱或密码不正确。';

  @override
  String get errorEmailNotConfirmed => '请先确认你的邮箱，查看收件箱。';

  @override
  String get errorUserExists => '该邮箱已注册账号。';

  @override
  String get errorWeakPassword => '该密码过于简单，请选择更强的密码。';

  @override
  String get errorRateLimited => '尝试次数过多，请稍等片刻后再试。';

  @override
  String get errorCodeInvalid => '验证码错误或已过期。';

  @override
  String get errorSamePassword => '请选择一个你之前没有用过的密码。';

  @override
  String get notificationDueToday => '今天到期';

  @override
  String notificationDueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days 天后到期',
    );
    return '$_temp0';
  }

  @override
  String commonStepOf(int step, int total) {
    return '第 $step 步，共 $total 步';
  }
}
