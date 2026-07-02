import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/security_providers.dart';
import '../data/security_repository.dart';

/// Design screen 17 — Security: biometric login, TOTP 2FA (QR + copy key),
/// recovery codes, app lock with auto-lock, and session control.
class SecurityPage extends ConsumerWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(securityStatusProvider);
    final prefs = ref.watch(securityPrefsProvider);
    final bioAvailable = ref.watch(biometricsAvailableProvider).valueOrNull ?? false;

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
          const _SectionLabel('Biometric login'),
          _Card(children: [
            _ToggleRow(
              icon: Icons.fingerprint,
              title: 'Unlock with biometrics',
              subtitle: bioAvailable ? null : 'No biometrics available on this device',
              value: prefs.biometricUnlock && bioAvailable,
              onChanged: bioAvailable
                  ? (v) async {
                      if (v) {
                        final ok = await ref
                            .read(biometricServiceProvider)
                            .authenticate('Confirm to enable biometric unlock');
                        if (!ok) return;
                      }
                      await ref.read(securityPrefsProvider.notifier).setBiometricUnlock(v);
                    }
                  : null,
            ),
            _BiometricTypesRow(),
          ]),
          const _SectionLabel('Two-factor authentication'),
          status.when(
            loading: () => const _Card(children: [
              Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator())),
            ]),
            error: (e, _) => _Card(children: [
              Padding(padding: const EdgeInsets.all(16), child: Text('$e', style: const TextStyle(color: AppColors.muted))),
            ]),
            data: (s) => _Card(children: [
              _ToggleRow(
                icon: Icons.shield_outlined,
                title: s.totpEnabled ? '2FA is enabled' : 'Enable 2FA',
                subtitle: s.totpEnabled
                    ? 'Authenticator app${s.enrolledAt == null ? '' : ' · since ${DateFormat('d MMM yyyy').format(s.enrolledAt!)}'}'
                    : 'Use Google Authenticator, Authy, 1Password, etc.',
                value: s.totpEnabled,
                onChanged: (v) => v ? _enroll(context, ref) : _disable(context, ref, s.totpFactorId!),
              ),
              _Row(
                icon: Icons.key_outlined,
                title: 'Recovery codes',
                onTap: () => _recoveryCodes(context, ref),
                trailing: Text(
                  s.unusedRecoveryCodes == 0 ? 'Generate' : '${s.unusedRecoveryCodes} unused',
                  style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
              ),
            ]),
          ),
          const _SectionLabel('More'),
          _Card(children: [
            _ToggleRow(
              icon: Icons.lock_outline,
              title: 'App lock',
              subtitle: 'Require unlock when reopening the app',
              value: prefs.appLock,
              onChanged: (v) => ref.read(securityPrefsProvider.notifier).setAppLock(v),
            ),
            _Row(
              icon: Icons.timer_outlined,
              title: 'Auto-lock after',
              onTap: () => _pickAutoLock(context, ref, prefs.autoLockMinutes),
              trailing: Text('${prefs.autoLockMinutes} min',
                  style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 12.5)),
            ),
            _Row(
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
    final repo = ref.read(securityRepositoryProvider);
    final TotpEnrollment enrollment;
    try {
      enrollment = await repo.enrollTotp();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not start enrollment: $e'), backgroundColor: AppColors.red));
      }
      return;
    }
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _EnrollSheet(enrollment: enrollment),
    );
    ref.invalidate(securityStatusProvider);
  }

  Future<void> _disable(BuildContext context, WidgetRef ref, String factorId) async {
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
    if (confirmed != true) return;
    try {
      await ref.read(securityRepositoryProvider).disableTotp(factorId);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not disable: $e'), backgroundColor: AppColors.red));
      }
    }
    ref.invalidate(securityStatusProvider);
  }

  Future<void> _recoveryCodes(BuildContext context, WidgetRef ref) async {
    final List<String> codes;
    try {
      codes = await ref.read(securityRepositoryProvider).generateRecoveryCodes();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not generate codes: $e'), backgroundColor: AppColors.red));
      }
      return;
    }
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
              const Text('Recovery codes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 4),
              const Text('Save these somewhere safe — they are shown only once and replace any previous codes.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  for (final c in codes)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.line)),
                      child: Text(c,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink, fontFeatures: [])),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Copy all',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: codes.join('\n')));
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
    ref.invalidate(securityStatusProvider);
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
            for (final m in const [1, 5, 15])
              ListTile(
                title: Text('$m minute${m == 1 ? '' : 's'}',
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
    final session = await ref.read(securityRepositoryProvider).currentSession();
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
                  try {
                    await ref.read(securityRepositoryProvider).signOutOtherDevices();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Other devices signed out.'), backgroundColor: AppColors.green));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.red));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// QR + secret + code verification for a pending TOTP enrollment.
class _EnrollSheet extends ConsumerStatefulWidget {
  const _EnrollSheet({required this.enrollment});
  final TotpEnrollment enrollment;

  @override
  ConsumerState<_EnrollSheet> createState() => _EnrollSheetState();
}

class _EnrollSheetState extends ConsumerState<_EnrollSheet> {
  final _code = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(securityRepositoryProvider)
          .verifyTotp(factorId: widget.enrollment.factorId, code: _code.text);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = '$e'.replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Set up authenticator app',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 4),
              const Text('Scan the QR with Google Authenticator, Authy, 1Password, etc., then enter the 6-digit code.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.line)),
                  child: QrImageView(data: widget.enrollment.uri, size: 160),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(widget.enrollment.secret,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink, letterSpacing: 1)),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: widget.enrollment.secret));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Key copied.'), backgroundColor: AppColors.green));
                      }
                    },
                    icon: const Icon(Icons.copy, size: 14),
                    label: const Text('Copy key', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppTextField(
                label: '6-digit code',
                controller: _code,
                icon: Icons.pin_outlined,
                keyboardType: TextInputType.number,
                errorText: _error,
              ),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Verify & enable', isLoading: _busy, onPressed: _verify),
            ],
          ),
        ),
      ),
    );
  }
}

class _BiometricTypesRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<BiometricType>>(
      future: ref.read(biometricServiceProvider).types(),
      builder: (context, snap) {
        final types = snap.data ?? const <BiometricType>[];
        if (types.isEmpty) return const SizedBox.shrink();
        final labels = [
          if (types.contains(BiometricType.face)) 'Face ID',
          if (types.contains(BiometricType.fingerprint)) 'Fingerprint',
          if (types.contains(BiometricType.strong) || types.contains(BiometricType.weak)) 'Device biometrics',
        ];
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Available: ${labels.toSet().join(' · ')}',
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
      child: Text(text.toUpperCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.title, this.trailing, this.onTap});
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.ink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink)),
      trailing: trailing,
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.icon, required this.title, this.subtitle, required this.value, this.onChanged});
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.ink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink)),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
      trailing: Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.green),
    );
  }
}
