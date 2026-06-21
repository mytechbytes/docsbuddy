import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_widgets.dart';

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

  bool get _hasLength => _password.text.length >= 8;
  bool get _hasUpper => RegExp(r'[A-Z]').hasMatch(_password.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_password.text);
  bool get _hasSpecial => RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_password.text);

  Future<void> _submit() async {
    if (!(_hasLength && _hasUpper && _hasNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please meet the password requirements.'), backgroundColor: AppColors.red),
      );
      return;
    }
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.'), backgroundColor: AppColors.red),
      );
      return;
    }
    final ok = await ref.read(authControllerProvider.notifier).updatePassword(_password.text);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated. Please sign in.'), backgroundColor: AppColors.green),
      );
      context.go('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(ref, context);
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthScaffold(
      showLogo: false,
      children: [
        const SizedBox(height: 14),
        const Center(child: HeroBadge(background: Color(0xFFFDF1E0), foreground: Color(0xFFC68318), icon: Icons.lock_outline)),
        const SizedBox(height: 22),
        const AuthHero(title: 'Set a new password', subtitle: "Choose a strong password you haven't used here before."),
        const SizedBox(height: 20),
        AppTextField(label: 'New Password', controller: _password, icon: Icons.lock_outline, hint: '••••••••', obscure: true, autofillHints: const [AutofillHints.newPassword]),
        const SizedBox(height: 14),
        AppTextField(label: 'Confirm Password', controller: _confirm, icon: Icons.lock_outline, hint: '••••••••', obscure: true, onSubmitted: (_) => _submit()),
        const SizedBox(height: 16),
        _RequirementsCard(
          rules: [
            (label: 'At least 8 characters', ok: _hasLength),
            (label: 'One uppercase letter', ok: _hasUpper),
            (label: 'One number', ok: _hasNumber),
            (label: r'One special character (!@#$…)', ok: _hasSpecial),
          ],
        ),
        const SizedBox(height: 18),
        PrimaryButton(label: 'Reset Password', isLoading: loading, onPressed: _submit),
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
        border: Border.all(color: const Color(0xFFEEF2F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Password must have', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink)),
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
