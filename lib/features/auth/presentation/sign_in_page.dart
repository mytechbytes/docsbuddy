import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_widgets.dart';

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
    if (ok && mounted) context.go('/home');
  }

  Future<void> _google() async {
    final ok = await ref.read(authControllerProvider.notifier).google();
    if (ok && mounted) context.go('/home');
  }

  Future<void> _apple() async {
    final ok = await ref.read(authControllerProvider.notifier).apple();
    if (ok && mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(ref, context);
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthScaffold(
      showBack: false,
      children: [
        const SizedBox(height: 8),
        const AuthHero(title: 'Welcome back', subtitle: 'Sign in to keep your assets and reminders in sync.', big: true),
        const SizedBox(height: 22),
        AppTextField(label: 'Email', controller: _email, icon: Icons.mail_outline, hint: 'you@example.com', keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.email]),
        const SizedBox(height: 14),
        AppTextField(label: 'Password', controller: _password, icon: Icons.lock_outline, hint: '••••••••', obscure: true, textInputAction: TextInputAction.done, onSubmitted: (_) => _submit()),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => context.push('/forgot-password'),
            child: const Text('Forgot password?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.chipBlue)),
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Sign In', isLoading: loading, onPressed: _submit),
        const OrDivider(),
        SocialButton(provider: SocialProvider.google, onPressed: _google),
        const SizedBox(height: 10),
        SocialButton(provider: SocialProvider.apple, onPressed: _apple),
        const SizedBox(height: 22),
        InlineLink(lead: "Don't have an account? ", action: 'Sign up', onTap: () => context.push('/sign-up')),
      ],
    );
  }
}
