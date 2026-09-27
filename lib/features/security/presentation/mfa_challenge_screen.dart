import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/db_logo.dart';
import '../../../core/widgets/feedback.dart';
import '../../auth/application/auth_controller.dart';
import '../application/security_providers.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';

/// AAL2 step-up gate: shown when the account has a verified authenticator
/// but the current session hasn't passed the TOTP check yet.
class MfaChallengeScreen extends ConsumerStatefulWidget {
  const MfaChallengeScreen({super.key});

  @override
  ConsumerState<MfaChallengeScreen> createState() => _MfaChallengeScreenState();
}

class _MfaChallengeScreenState extends ConsumerState<MfaChallengeScreen> {
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
      await ref.read(securityActionsProvider).verifyMfaChallenge(_code.text);
    } catch (e) {
      if (mounted) setState(() => _error = context.failureText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          children: [
            const Center(child: DbLogo(size: 24)),
            const SizedBox(height: 28),
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColors.insuranceBg, shape: BoxShape.circle),
              child: const Icon(Icons.shield_outlined, size: 30, color: AppColors.insuranceFg),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(context.l10n.mfaTitle,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink)),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(context.l10n.mfaSubtitle,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ),
            const SizedBox(height: 22),
            AppTextField(
              label: context.l10n.mfaCodeLabel,
              controller: _code,
              icon: Icons.pin_outlined,
              keyboardType: TextInputType.number,
              errorText: _error,
              onSubmitted: (_) => _verify(),
            ),
            const SizedBox(height: 18),
            PrimaryButton(label: context.l10n.authOtpVerify, isLoading: _busy, onPressed: _verify),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                final ok = await ref.read(authControllerProvider.notifier).signOut();
                if (ok && context.mounted) context.go(AppRoutes.signIn);
              },
              child: Text(context.l10n.commonSignOut, style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
