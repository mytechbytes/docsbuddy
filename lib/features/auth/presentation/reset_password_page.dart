import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/feedback.dart';
import '../application/auth_controller.dart';
import '../domain/password_policy.dart';
import 'widgets/auth_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(authControllerProvider.notifier).resetPassword(_password.text, _confirm.text);
    if (ok && mounted) {
      context.showSuccess(context.l10n.authResetDone);
      context.go(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(ref, context);
    final loading = ref.watch(authControllerProvider).isLoading;
    final checks = checkPassword(_password.text);

    return AuthScaffold(
      showLogo: false,
      children: [
        const SizedBox(height: 14),
        const Center(child: HeroBadge(background: AppColors.amberSoft, foreground: AppColors.amberDeep, icon: Icons.lock_outline)),
        const SizedBox(height: 22),
        AuthHero(title: context.l10n.authResetTitle, subtitle: context.l10n.authResetSubtitle),
        const SizedBox(height: 20),
        AppTextField(label: context.l10n.authNewPassword, controller: _password, icon: Icons.lock_outline, hint: '••••••••', obscure: true, autofillHints: const [AutofillHints.newPassword]),
        const SizedBox(height: 14),
        AppTextField(label: context.l10n.authConfirmPassword, controller: _confirm, icon: Icons.lock_outline, hint: '••••••••', obscure: true, onSubmitted: (_) => _submit()),
        const SizedBox(height: 16),
        _RequirementsCard(
          rules: [
            (label: context.l10n.authRuleLength, ok: checks.length),
            (label: context.l10n.authRuleUpper, ok: checks.upper),
            (label: context.l10n.authRuleNumber, ok: checks.number),
            (label: context.l10n.authRuleSpecial, ok: checks.special),
          ],
        ),
        const SizedBox(height: 18),
        PrimaryButton(label: context.l10n.authResetCta, isLoading: loading, onPressed: _submit),
      ],
    );
  }
}

class _RequirementsCard extends StatelessWidget {
  const _RequirementsCard({required this.rules});
  final List<({String label, bool ok})> rules;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.authPasswordMustHave, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 8),
          for (final r in rules)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(color: r.ok ? AppColors.green : AppColors.hairline, shape: BoxShape.circle),
                    child: r.ok ? const Icon(Icons.check, size: 11, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 8),
                  Text(r.label, style: TextStyle(fontSize: 12, color: r.ok ? AppColors.ink : AppColors.muted)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
