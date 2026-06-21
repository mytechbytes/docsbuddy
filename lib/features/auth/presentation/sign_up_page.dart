import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_widgets.dart';

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

  /// 0–4 strength based on length + character classes.
  int get _strength {
    final p = _password.text;
    if (p.isEmpty) return 0;
    var s = 0;
    if (p.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(p)) s++;
    return s;
  }

  String get _strengthLabel => switch (_strength) {
        0 || 1 => 'Use 8+ chars with a number and symbol.',
        2 => 'Fair — add an uppercase letter or symbol.',
        3 => 'Strong — keep going for excellent.',
        _ => 'Excellent password.',
      };

  Future<void> _submit() async {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms to continue.'), backgroundColor: AppColors.red),
      );
      return;
    }
    final ok = await ref.read(authControllerProvider.notifier).signUp(_name.text, _email.text, _password.text);
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
      children: [
        const SizedBox(height: 4),
        const AuthHero(title: 'Create your account', subtitle: 'Track warranties, bills and renewals with your family — never miss a due date.'),
        const SizedBox(height: 20),
        AppTextField(label: 'Full Name', controller: _name, icon: Icons.person_outline, hint: 'Your name', textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.name]),
        const SizedBox(height: 14),
        AppTextField(label: 'Email', controller: _email, icon: Icons.mail_outline, hint: 'you@example.com', keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.email]),
        const SizedBox(height: 14),
        AppTextField(label: 'Password', controller: _password, icon: Icons.lock_outline, hint: '••••••••', obscure: true, autofillHints: const [AutofillHints.newPassword]),
        const SizedBox(height: 10),
        _StrengthBar(strength: _strength),
        const SizedBox(height: 6),
        Text(_strengthLabel, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
        const SizedBox(height: 14),
        _TermsRow(value: _agreed, onChanged: (v) => setState(() => _agreed = v)),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Create Account', isLoading: loading, onPressed: _submit),
        const OrDivider(),
        SocialButton(provider: SocialProvider.google, onPressed: _google),
        const SizedBox(height: 10),
        SocialButton(provider: SocialProvider.apple, onPressed: _apple),
        const SizedBox(height: 22),
        InlineLink(lead: 'Already have an account? ', action: 'Sign in', onTap: () => context.go('/sign-in')),
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
        const Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 12, height: 1.45, color: AppColors.ink2),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(text: 'Terms of Service', style: TextStyle(color: AppColors.chipBlue, fontWeight: FontWeight.w700)),
                TextSpan(text: ' and '),
                TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.chipBlue, fontWeight: FontWeight.w700)),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
