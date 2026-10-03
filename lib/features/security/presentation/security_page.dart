import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/loader.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/feedback.dart';
import '../application/security_providers.dart';
import '../domain/security_models.dart';
import 'widgets/security_widgets.dart';
import '../../../core/widgets/settings_list.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

/// Design screen 17 — Security: biometric login, TOTP 2FA (QR + copy key),
/// recovery codes, app lock with auto-lock, and session control.
class SecurityPage extends ConsumerWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(securityStatusProvider);
    final prefs = ref.watch(securityPrefsProvider);
    final bioAvailable = ref.watch(biometricsAvailableProvider).value ?? false;

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.palette.text),
        title: Text(context.l10n.securityTitle, style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          SectionLabel(context.l10n.securityBiometricSection),
          SettingsCard(children: [
            SettingsToggleRow(
              icon: Icons.fingerprint,
              title: context.l10n.securityUnlockBiometrics,
              subtitle: bioAvailable ? null : context.l10n.securityNoBiometrics,
              value: prefs.biometricUnlock && bioAvailable,
              onChanged: bioAvailable
                  ? (v) => ref.read(securityPrefsProvider.notifier).setBiometricUnlock(v)
                  : null,
            ),
            const BiometricTypesRow(),
          ]),
          SectionLabel(context.l10n.securityTwoFactorSection),
          status.when(
            loading: () => SettingsCard(children: [
              LoadingView.section(message: context.l10n.loadingSecurity),
            ]),
            error: (e, _) => SettingsCard(children: [
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(context.failureText(e), style: TextStyle(color: context.palette.textMuted))),
            ]),
            data: (s) => SettingsCard(children: [
              SettingsToggleRow(
                icon: Icons.shield_outlined,
                title: s.totpEnabled ? context.l10n.security2faEnabled : context.l10n.securityEnable2fa,
                subtitle: s.totpEnabled
                    ? (s.enrolledAt == null
                        ? context.l10n.securityAuthenticatorApp
                        : context.l10n.securityAuthenticatorSince(context.formatDate(s.enrolledAt!)))
                    : context.l10n.securityAuthenticatorHint,
                value: s.totpEnabled,
                onChanged: (v) => v ? _enroll(context, ref) : _disable(context, ref),
              ),
            ]),
          ),
          SectionLabel(context.l10n.securityMoreSection),
          SettingsCard(children: [
            SettingsToggleRow(
              icon: Icons.lock_outline,
              title: context.l10n.securityAppLock,
              subtitle: context.l10n.securityAppLockHint,
              value: prefs.appLock,
              onChanged: (v) => ref.read(securityPrefsProvider.notifier).setAppLock(v),
            ),
            SettingsRow(
              icon: Icons.timer_outlined,
              title: context.l10n.securityAutoLock,
              onTap: () => _pickAutoLock(context, ref, prefs.autoLockMinutes),
              trailing: Text(context.l10n.securityMinutesShort(prefs.autoLockMinutes),
                  style: TextStyle(color: context.palette.textMuted, fontWeight: FontWeight.w600, fontSize: 12.5)),
            ),
            SettingsRow(
              icon: Icons.devices_outlined,
              title: context.l10n.securityActiveSessions,
              onTap: () => _sessions(context, ref),
              trailing: Icon(Icons.chevron_right, color: context.palette.textMuted),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _enroll(BuildContext context, WidgetRef ref) async {
    final actions = ref.read(securityActionsProvider);
    TotpEnrollment? enrollment;
    await runAction(
      context,
      () async => enrollment = await actions.startTotpEnrollment(),
      loading: context.l10n.loadingPreparingAuthenticator,
    );
    if (enrollment == null || !context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => TotpEnrollSheet(enrollment: enrollment!),
    );
    actions.enrollmentFinished();
  }

  Future<void> _disable(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.palette.surface,
        title: Text(context.l10n.securityDisable2faTitle, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: Text(context.l10n.securityDisable2faMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.securityDisable, style: TextStyle(color: context.palette.danger, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await runAction(
      context,
      () => ref.read(securityActionsProvider).disableTotp(),
      loading: context.l10n.loadingTurningOffTwoStep,
    );
  }

  Future<void> _pickAutoLock(BuildContext context, WidgetRef ref, int current) async {
    final minutes = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final m in autoLockOptions)
              ListTile(
                title: Text(context.l10n.securityMinutes(m),
                    style: TextStyle(fontWeight: FontWeight.w600, color: context.palette.text)),
                trailing: m == current ? Icon(Icons.check, color: context.palette.success) : null,
                onTap: () => Navigator.of(context).pop(m),
              ),
          ],
        ),
      ),
    );
    if (minutes != null) await ref.read(securityPrefsProvider.notifier).setAutoLockMinutes(minutes);
  }

  Future<void> _sessions(BuildContext context, WidgetRef ref) async {
    final session = await ref.read(securityActionsProvider).currentSession();
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.securityActiveSessions,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.smartphone, color: context.palette.text),
                title: Text(session.device,
                    style: TextStyle(fontWeight: FontWeight.w700, color: context.palette.text)),
                subtitle: Text(
                  session.lastSignIn == null
                      ? context.l10n.securityCurrentSession
                      : context.l10n.securitySignedInAt(
                          '${context.formatDate(session.lastSignIn!.toLocal())}, ${TimeOfDay.fromDateTime(session.lastSignIn!.toLocal()).format(context)}'),
                  style: TextStyle(fontSize: 12.5, color: context.palette.textMuted),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration:
                      BoxDecoration(color: context.palette.successSoft, borderRadius: BorderRadius.circular(999)),
                  child: Text(context.l10n.securityThisDevice,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.successStrong)),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: context.l10n.securitySignOutOthers,
                onPressed: () async {
                  final ok = await runAction(
                    context,
                    () => ref.read(securityActionsProvider).signOutOtherDevices(),
                    loading: context.l10n.loadingSigningOutOthers,
                    success: context.l10n.securityOthersSignedOut,
                  );
                  if (ok && context.mounted) Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
