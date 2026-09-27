import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/formatters.dart';
import '../application/security_providers.dart';
import '../domain/security_models.dart';
import 'widgets/security_widgets.dart';
import '../../../core/widgets/settings_list.dart';

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
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const Text('Security', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const SectionLabel('Biometric login'),
          SettingsCard(children: [
            SettingsToggleRow(
              icon: Icons.fingerprint,
              title: 'Unlock with biometrics',
              subtitle: bioAvailable ? null : 'No biometrics available on this device',
              value: prefs.biometricUnlock && bioAvailable,
              onChanged: bioAvailable
                  ? (v) => ref.read(securityPrefsProvider.notifier).setBiometricUnlock(v)
                  : null,
            ),
            const BiometricTypesRow(),
          ]),
          const SectionLabel('Two-factor authentication'),
          status.when(
            loading: () => const SettingsCard(children: [
              Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator())),
            ]),
            error: (e, _) => SettingsCard(children: [
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(failureMessage(e), style: const TextStyle(color: AppColors.muted))),
            ]),
            data: (s) => SettingsCard(children: [
              SettingsToggleRow(
                icon: Icons.shield_outlined,
                title: s.totpEnabled ? '2FA is enabled' : 'Enable 2FA',
                subtitle: s.totpEnabled
                    ? 'Authenticator app${s.enrolledAt == null ? '' : ' · since ${DateFormat('d MMM yyyy').format(s.enrolledAt!)}'}'
                    : 'Use Google Authenticator, Authy, 1Password, etc.',
                value: s.totpEnabled,
                onChanged: (v) => v ? _enroll(context, ref) : _disable(context, ref),
              ),
            ]),
          ),
          const SectionLabel('More'),
          SettingsCard(children: [
            SettingsToggleRow(
              icon: Icons.lock_outline,
              title: 'App lock',
              subtitle: 'Require unlock when reopening the app',
              value: prefs.appLock,
              onChanged: (v) => ref.read(securityPrefsProvider.notifier).setAppLock(v),
            ),
            SettingsRow(
              icon: Icons.timer_outlined,
              title: 'Auto-lock after',
              onTap: () => _pickAutoLock(context, ref, prefs.autoLockMinutes),
              trailing: Text('${prefs.autoLockMinutes} min',
                  style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 12.5)),
            ),
            SettingsRow(
              icon: Icons.devices_outlined,
              title: 'Active sessions',
              onTap: () => _sessions(context, ref),
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _enroll(BuildContext context, WidgetRef ref) async {
    final actions = ref.read(securityActionsProvider);
    TotpEnrollment? enrollment;
    await runAction(context, () async => enrollment = await actions.startTotpEnrollment());
    if (enrollment == null || !context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => TotpEnrollSheet(enrollment: enrollment!),
    );
    actions.enrollmentFinished();
  }

  Future<void> _disable(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paper,
        title: const Text('Disable 2FA?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: const Text('Your account will no longer require an authenticator code to sign in.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Disable', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await runAction(context, () => ref.read(securityActionsProvider).disableTotp());
  }

  Future<void> _pickAutoLock(BuildContext context, WidgetRef ref, int current) async {
    final minutes = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final m in autoLockOptions)
              ListTile(
                title: Text(plural(m, 'minute'),
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink)),
                trailing: m == current ? const Icon(Icons.check, color: AppColors.green) : null,
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
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Active sessions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.smartphone, color: AppColors.ink),
                title: Text(session.device,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                subtitle: Text(
                  session.lastSignIn == null
                      ? 'Current session'
                      : 'Signed in ${DateFormat('d MMM yyyy, HH:mm').format(session.lastSignIn!.toLocal())}',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration:
                      BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(999)),
                  child: const Text('This device',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.greenLeaf)),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Sign out other devices',
                onPressed: () async {
                  final ok = await runAction(
                    context,
                    () => ref.read(securityActionsProvider).signOutOtherDevices(),
                    success: 'Other devices signed out.',
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
