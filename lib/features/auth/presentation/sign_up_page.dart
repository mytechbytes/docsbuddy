import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';
import '../domain/password_policy.dart';
import 'widgets/auth_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _agreed = true;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signUp(_name.text, _email.text, _password.text, acceptedTerms: _agreed);
    if (ok && mounted) context.go(AppRoutes.dashboard);
  }

  Future<void> _google() async {
    final ok = await ref.read(authControllerProvider.notifier).google();
    if (ok && mounted) context.go(AppRoutes.dashboard);
  }

  Future<void> _apple() async {
    final ok = await ref.read(authControllerProvider.notifier).apple();
    if (ok && mounted) context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(ref, context);
    final loading = ref.watch(authControllerProvider).isLoading;
    final (strength, strengthHint) = signUpStrength(_password.text);

    return AuthScaffold(
      children: [
        const SizedBox(height: 4),
        AuthHero(title: context.l10n.authSignUpTitle, subtitle: context.l10n.authSignUpSubtitle),
        const SizedBox(height: 20),
        AppTextField(label: context.l10n.authFullName, controller: _name, icon: Icons.person_outline, hint: context.l10n.authFullNameHint, textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.name]),
        const SizedBox(height: 14),
        AppTextField(label: context.l10n.commonEmail, controller: _email, icon: Icons.mail_outline, hint: context.l10n.commonEmailHint, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.email]),
        const SizedBox(height: 14),
        AppTextField(label: context.l10n.commonPassword, controller: _password, icon: Icons.lock_outline, hint: '••••••••', obscure: true, autofillHints: const [AutofillHints.newPassword]),
        const SizedBox(height: 10),
        _StrengthBar(strength: strength),
        const SizedBox(height: 6),
        Text(strengthHint, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
        const SizedBox(height: 14),
        _TermsRow(value: _agreed, onChanged: (v) => setState(() => _agreed = v)),
        const SizedBox(height: 16),
        PrimaryButton(label: context.l10n.authCreateAccountCta, isLoading: loading, onPressed: _submit),
        const OrDivider(),
        SocialButton(provider: SocialProvider.google, onPressed: _google),
        const SizedBox(height: 10),
        SocialButton(provider: SocialProvider.apple, onPressed: _apple),
        const SizedBox(height: 22),
        InlineLink(lead: context.l10n.authHaveAccountLead, action: context.l10n.commonSignIn, onTap: () => context.go(AppRoutes.signIn)),
      ],
    );
  }
}

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.strength});
  final int strength;

  @override
  Widget build(BuildContext context) {
    Color colorFor(int i) {
      if (i >= strength) return AppColors.hairline;
      return switch (strength) {
        1 => AppColors.red,
        2 => AppColors.amber,
        _ => AppColors.green,
      };
    }

    return Row(
      children: [
        for (var i = 0; i < 4; i++) ...[
          Expanded(
            child: Container(height: 4, decoration: BoxDecoration(color: colorFor(i), borderRadius: BorderRadius.circular(999))),
          ),
          if (i < 3) const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: value ? AppColors.chipBlue : AppColors.paper,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: value ? AppColors.chipBlue : AppColors.fieldBorder, width: 1.5),
            ),
            child: value ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 12, height: 1.45, color: AppColors.ink2),
              children: [
                TextSpan(text: context.l10n.authTermsLead),
                TextSpan(text: context.l10n.authTermsOfService, style: const TextStyle(color: AppColors.chipBlue, fontWeight: FontWeight.w700)),
                TextSpan(text: context.l10n.authTermsAnd),
                TextSpan(text: context.l10n.authPrivacyPolicy, style: const TextStyle(color: AppColors.chipBlue, fontWeight: FontWeight.w700)),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
