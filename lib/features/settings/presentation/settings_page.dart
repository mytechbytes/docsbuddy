import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/loader.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/feedback.dart';
import '../../auth/application/auth_controller.dart';
import '../../family/application/family_controller.dart';
import '../../onboarding/application/onboarding_controller.dart';
import '../../profile/application/profile_providers.dart';
import '../../security/application/security_providers.dart';
import '../application/settings_providers.dart';
import '../domain/notification_prefs.dart';
import '../../../routing/app_routes.dart';
import '../../../core/widgets/settings_list.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/language_controller.dart';
import 'language_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../application/appearance_controller.dart';
import '../domain/appearance.dart';

/// Design screen 15 — Settings: Account / Notifications / Family sections
/// (notification toggles + default offsets are backed by
/// `notification_prefs`), plus app utilities and sign out.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    final prefs = ref.watch(notificationPrefsProvider).value ?? const NotificationPrefs();
    final members = ref.watch(familyControllerProvider).value?.members ?? const [];

    void setChannel(NotificationChannel channel, bool enabled) =>
        runAction(
          context,
          () => ref.read(notificationPrefsProvider.notifier).setChannel(channel, enabled),
          loading: context.l10n.loadingSavingSettings,
        );

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        title: Text(context.l10n.commonSettings, style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          SectionLabel(context.l10n.settingsSectionAccount),
          SettingsCard(children: [
            SettingsRow(
              icon: Icons.person_outline,
              title: context.l10n.settingsPersonalInfo,
              onTap: () => context.push(AppRoutes.profile),
              trailing: Icon(Icons.chevron_right, color: context.palette.textMuted),
            ),
            SettingsRow(
              icon: Icons.mail_outline,
              title: context.l10n.commonEmail,
              trailing: SettingsValue(profile?.email ?? '—'),
            ),
            SettingsRow(
              icon: Icons.lock_outline,
              title: context.l10n.commonChangePassword,
              onTap: () => context.push(AppRoutes.changePassword),
              trailing: Icon(Icons.chevron_right, color: context.palette.textMuted),
            ),
            SettingsRow(
              icon: Icons.shield_outlined,
              title: context.l10n.settingsSecurity,
              onTap: () => context.push(AppRoutes.security),
              trailing: SettingsValue(ref.watch(securityStatusProvider).value?.totpEnabled == true ? context.l10n.commonOn : context.l10n.commonOff),
            ),
          ]),
          SectionLabel(context.l10n.commonNotifications),
          SettingsCard(children: [
            SettingsToggleRow(
              icon: Icons.notifications_active_outlined,
              title: context.l10n.settingsPush,
              value: prefs.has(NotificationChannel.push),
              onChanged: (v) => setChannel(NotificationChannel.push, v),
            ),
            SettingsToggleRow(
              icon: Icons.mail_outline,
              title: context.l10n.settingsEmailReminders,
              value: prefs.has(NotificationChannel.email),
              onChanged: (v) => setChannel(NotificationChannel.email, v),
            ),
            SettingsToggleRow(
              icon: Icons.chat_outlined,
              title: context.l10n.settingsWhatsappReminders,
              value: prefs.has(NotificationChannel.whatsapp),
              onChanged: (v) => setChannel(NotificationChannel.whatsapp, v),
            ),
            SettingsRow(
              icon: Icons.update_outlined,
              title: context.l10n.settingsDefaultOffsets,
              onTap: () => _editOffsets(context, ref, prefs),
              trailing: SettingsValue(context.formatOffsets(prefs.defaultOffsets)),
            ),
            SettingsRow(
              icon: Icons.bedtime_outlined,
              title: context.l10n.settingsQuietHours,
              onTap: () => _editQuietHours(context, ref, prefs),
              trailing: SettingsValue('${prefs.quietStart} – ${prefs.quietEnd}'),
            ),
          ]),
          SectionLabel(context.l10n.commonFamily),
          SettingsCard(children: [
            SettingsRow(
              icon: Icons.groups_outlined,
              title: context.l10n.settingsManageFamily,
              onTap: () => context.push(AppRoutes.familyManage),
              trailing: SettingsValue(context.l10n.memberCount(members.length)),
            ),
          ]),
          SectionLabel(context.l10n.settingsSectionApp),
          SettingsCard(children: [
            SettingsRow(
              icon: Icons.dark_mode_outlined,
              title: context.l10n.settingsAppearance,
              onTap: () => _pickAppearance(context, ref),
              trailing: SettingsValue(_appearanceName(context, ref.watch(appearanceProvider))),
            ),
            SettingsRow(
              icon: Icons.language_outlined,
              title: context.l10n.settingsLanguage,
              onTap: () => pickLanguage(context, ref),
              trailing: SettingsValue(languageLabel(context, ref.watch(languageProvider))),
            ),
            SettingsRow(
              icon: Icons.cloud_outlined,
              title: context.l10n.settingsBackend,
              trailing: SettingsValue(ref.watch(backendLabelProvider)),
            ),
            SettingsRow(
              icon: Icons.notification_add_outlined,
              title: context.l10n.settingsTestNotification,
              onTap: () async {
                final ok = await ref.read(sendTestNotificationProvider)();
                if (!context.mounted) return;
                ok
                    ? context.showSuccess(context.l10n.settingsTestNotificationSent)
                    : context.showFailure(const UnavailableFailure('Notifications are blocked in system settings.',
                        reason: FailureReason.notificationsBlocked));
              },
              trailing: Icon(Icons.chevron_right, color: context.palette.textMuted),
            ),
            SettingsRow(
              icon: Icons.checklist_outlined,
              title: context.l10n.settingsRoadmap,
              onTap: () => context.push(AppRoutes.roadmap),
              trailing: Icon(Icons.chevron_right, color: context.palette.textMuted),
            ),
            SettingsRow(
              icon: Icons.replay_outlined,
              title: context.l10n.settingsReplayOnboarding,
              onTap: () async {
                await ref.read(onboardingControllerProvider.notifier).reset();
                if (context.mounted) context.go(AppRoutes.onboarding);
              },
              trailing: Icon(Icons.chevron_right, color: context.palette.textMuted),
            ),
          ]),
          const SizedBox(height: 16),
          SettingsCard(children: [
            SettingsRow(
              icon: Icons.logout,
              title: context.l10n.commonSignOut,
              danger: true,
              onTap: () async {
                final ok = await withLoader(
                  context,
                  context.l10n.loadingSigningOut,
                  () => ref.read(authControllerProvider.notifier).signOut(),
                );
                if (ok && context.mounted) context.go(AppRoutes.signIn);
              },
            ),
          ]),
        ],
      ),
    );
  }

  /// Multi-select chips over the supported days-before-due offsets.
  Future<void> _editOffsets(BuildContext context, WidgetRef ref, NotificationPrefs prefs) async {
    const options = notifyOffsetOptions;
    final selected = {...prefs.defaultOffsets};
    final saved = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.settingsOffsetsTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
                const SizedBox(height: 4),
                Text(context.l10n.settingsOffsetsSubtitle,
                    style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final d in options)
                      FilterChip(
                        selected: selected.contains(d),
                        onSelected: (v) => setState(() => v ? selected.add(d) : selected.remove(d)),
                        label: Text(context.l10n.settingsDaysBefore(d)),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: selected.contains(d) ? Colors.white : context.palette.textSecondary),
                        selectedColor: context.palette.accent,
                        checkmarkColor: Colors.white,
                        backgroundColor: context.palette.background,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                            side: BorderSide(color: context.palette.border)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: context.palette.inverseSurface),
                    onPressed: selected.isEmpty ? null : () => Navigator.of(context).pop(true),
                    child: Text(context.l10n.commonSave, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (saved == true && context.mounted) {
      await runAction(
        context,
        () => ref.read(notificationPrefsProvider.notifier).setDefaultOffsets(selected),
        loading: context.l10n.loadingSavingSettings,
      );
    }
  }
}

/// Start/end time pickers for the do-not-disturb window; alerts landing
/// inside it are shifted to the window's end.
Future<void> _editQuietHours(BuildContext context, WidgetRef ref, NotificationPrefs prefs) async {
  TimeOfDay toTimeOfDay(String hhmm, ClockTime fallback) {
    final t = parseClockTime(hhmm, fallback);
    return TimeOfDay(hour: t.hour, minute: t.minute);
  }

  final start = await showTimePicker(
    context: context,
    helpText: context.l10n.settingsQuietHoursStart,
    initialTime: toTimeOfDay(prefs.quietStart, (hour: 22, minute: 0)),
  );
  if (start == null || !context.mounted) return;
  final end = await showTimePicker(
    context: context,
    helpText: context.l10n.settingsQuietHoursEnd,
    initialTime: toTimeOfDay(prefs.quietEnd, (hour: 7, minute: 0)),
  );
  if (end == null || !context.mounted) return;

  await runAction(
    context,
    () => ref.read(notificationPrefsProvider.notifier).setQuietHours(
          (hour: start.hour, minute: start.minute),
          (hour: end.hour, minute: end.minute),
        ),
    loading: context.l10n.loadingSavingSettings,
  );
}

String _appearanceName(BuildContext context, AppearanceMode mode) => switch (mode) {
      AppearanceMode.system => context.l10n.appearanceSystem,
      AppearanceMode.light => context.l10n.appearanceLight,
      AppearanceMode.dark => context.l10n.appearanceDark,
    };

Future<void> _pickAppearance(BuildContext context, WidgetRef ref) async {
  final current = ref.read(appearanceProvider);
  final picked = await showModalBottomSheet<AppearanceMode>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final mode in AppearanceMode.values)
            ListTile(
              title: Text(_appearanceName(context, mode), style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: mode == current ? Icon(Icons.check, color: context.palette.success) : null,
              onTap: () => Navigator.of(context).pop(mode),
            ),
        ],
      ),
    ),
  );
  if (picked != null) await ref.read(appearanceProvider.notifier).set(picked);
}
