import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_widgets.dart';

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
    if (ok && mounted) context.push('/verify-otp?email=${Uri.encodeComponent(_email.text.trim())}');
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(ref, context);
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthScaffold(
      showLogo: false,
      children: [
        const SizedBox(height: 14),
        const Center(child: HeroBadge(background: Color(0xFFEEF3FB), foreground: AppColors.chipBlue, icon: Icons.vpn_key_outlined)),
        const SizedBox(height: 22),
        const AuthHero(title: 'Forgot password?', subtitle: "No worries. Enter your email and we'll send you a 6-digit code to reset it."),
        const SizedBox(height: 20),
        AppTextField(label: 'Email', controller: _email, icon: Icons.mail_outline, hint: 'you@example.com', keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.done, autofillHints: const [AutofillHints.email], onSubmitted: (_) => _submit()),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Send Verification Code', isLoading: loading, onPressed: _submit),
        const SizedBox(height: 22),
        InlineLink(lead: 'Remember it? ', action: 'Back to sign in', onTap: () => context.go('/sign-in')),
      ],
    );
  }
}
