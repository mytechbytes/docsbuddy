import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(authControllerProvider.notifier).signIn(_email.text, _password.text);
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

    return AuthScaffold(
      showBack: false,
      children: [
        const SizedBox(height: 8),
        AuthHero(title: context.l10n.authSignInTitle, subtitle: context.l10n.authSignInSubtitle, big: true),
        const SizedBox(height: 22),
        AppTextField(label: context.l10n.commonEmail, controller: _email, icon: Icons.mail_outline, hint: context.l10n.commonEmailHint, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.email]),
        const SizedBox(height: 14),
        AppTextField(label: context.l10n.commonPassword, controller: _password, icon: Icons.lock_outline, hint: '••••••••', obscure: true, textInputAction: TextInputAction.done, onSubmitted: (_) => _submit()),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.forgotPassword),
            child: Text(context.l10n.commonForgotPassword, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.accent)),
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(label: context.l10n.authSignInCta, isLoading: loading, onPressed: _submit),
        const OrDivider(),
        SocialButton(provider: SocialProvider.google, onPressed: _google),
        const SizedBox(height: 10),
        SocialButton(provider: SocialProvider.apple, onPressed: _apple),
        const SizedBox(height: 22),
        InlineLink(lead: context.l10n.authNoAccountLead, action: context.l10n.authSignUpAction, onTap: () => context.push(AppRoutes.signUp)),
      ],
    );
  }
}
