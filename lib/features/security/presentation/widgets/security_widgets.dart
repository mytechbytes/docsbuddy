import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/widgets/loader.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/settings_list.dart';
import '../../application/security_providers.dart';
import '../../domain/security_models.dart';
import '../../../../core/l10n/l10n.dart';
import '../security_names.dart';
import '../../../../core/theme/app_theme.dart';

/// QR + secret + code verification for a pending TOTP enrollment.
class TotpEnrollSheet extends ConsumerStatefulWidget {
  const TotpEnrollSheet({super.key, required this.enrollment});
  final TotpEnrollment enrollment;

  @override
  ConsumerState<TotpEnrollSheet> createState() => _TotpEnrollSheetState();
}

class _TotpEnrollSheetState extends ConsumerState<TotpEnrollSheet> {
  final _code = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() => _error = null);
    try {
      await withLoader(
        context,
        context.l10n.loadingVerifyingCode,
        () => ref.read(securityActionsProvider).confirmTotp(widget.enrollment, _code.text),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e, stack) {
      if (mounted) setState(() => _error = context.failureMessage(e, stack));
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
              Text(context.l10n.securitySetupTitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
              const SizedBox(height: 4),
              Text(context.l10n.securitySetupBody,
                  style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.palette.border)),
                  child: QrImageView(data: widget.enrollment.uri, size: 160),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(widget.enrollment.secret,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.text, letterSpacing: 1)),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: widget.enrollment.secret));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(context.l10n.securityKeyCopied), backgroundColor: AppColors.green));
                      }
                    },
                    icon: const Icon(Icons.copy, size: 14),
                    label: Text(context.l10n.securityCopyKey, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppTextField(
                label: context.l10n.mfaCodeLabel,
                controller: _code,
                icon: Icons.pin_outlined,
                keyboardType: TextInputType.number,
                errorText: _error,
              ),
              const SizedBox(height: 16),
              PrimaryButton(label: context.l10n.securityVerifyEnable, onPressed: _verify),
            ],
          ),
        ),
      ),
    );
  }
}

class BiometricTypesRow extends ConsumerWidget {
  const BiometricTypesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kinds = ref.watch(biometricKindsProvider).value ?? const <BiometricKind>[];
    if (kinds.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(context.l10n.securityAvailable(kinds.map((k) => k.displayName(context)).join(' · ')),
            style: TextStyle(fontSize: 12, color: context.palette.textMuted)),
      ),
    );
  }
}

/// The one switch for the app lock — on Settings and on the Security screen
/// alike, both driving the same preference. Worded for what the device offers
/// ("Lock with Face ID", "Lock with fingerprint", …); disabled, with the reason,
/// on a device that can't authenticate at all.
class AppLockToggleRow extends ConsumerWidget {
  const AppLockToggleRow({super.key});

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool enabled) async {
    final result = await ref.read(securityPrefsProvider.notifier).setAppLock(enabled);
    if (!context.mounted) return;
    final problem = result.message(context);
    if (problem != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(problem)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(biometricsAvailableProvider).value ?? false;
    final kinds = ref.watch(biometricKindsProvider).value ?? const <BiometricKind>[];
    final locked = ref.watch(securityPrefsProvider.select((p) => p.appLock));
    return SettingsToggleRow(
      icon: kinds.lockIcon,
      title: kinds.lockTitle(context),
      subtitle: available ? context.l10n.securityAppLockHint : context.l10n.lockNeedsScreenLock,
      value: locked && available,
      onChanged: available ? (enabled) => _toggle(context, ref, enabled) : null,
    );
  }
}
