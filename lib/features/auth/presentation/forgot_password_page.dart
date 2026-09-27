import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(authControllerProvider.notifier).sendResetCode(_email.text);
    if (ok && mounted) context.push(AppRoutes.verifyOtp(_email.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(ref, context);
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthScaffold(
      showLogo: false,
      children: [
        const SizedBox(height: 14),
        const Center(child: HeroBadge(background: AppColors.blueSoft, foreground: AppColors.chipBlue, icon: Icons.vpn_key_outlined)),
        const SizedBox(height: 22),
        AuthHero(title: context.l10n.commonForgotPassword, subtitle: context.l10n.authForgotSubtitle),
        const SizedBox(height: 20),
        AppTextField(label: context.l10n.commonEmail, controller: _email, icon: Icons.mail_outline, hint: context.l10n.commonEmailHint, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.done, autofillHints: const [AutofillHints.email], onSubmitted: (_) => _submit()),
        const SizedBox(height: 16),
        PrimaryButton(label: context.l10n.authForgotSendCode, isLoading: loading, onPressed: _submit),
        const SizedBox(height: 22),
        InlineLink(lead: context.l10n.authRememberLead, action: context.l10n.authBackToSignIn, onTap: () => context.go(AppRoutes.signIn)),
      ],
    );
  }
}
