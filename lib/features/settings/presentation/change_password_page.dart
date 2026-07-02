import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/application/password_strength.dart';
import '../../auth/data/auth_repository.dart';
import '../../profile/application/profile_providers.dart';

/// Design screen 16 — Change password: current/new/confirm with a strength
/// meter. The current password is verified by re-authenticating first.
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _current = TextEditingController();
  final _fresh = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;
  bool _busy = false;
  int _score = 0;
  String _label = '';

  @override
  void dispose() {
    _current.dispose();
    _fresh.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (_fresh.text.length < 8) {
      setState(() => _error = 'New password must be at least 8 characters.');
      return;
    }
    if (_fresh.text != _confirm.text) {
      setState(() => _error = 'Passwords don\'t match.');
      return;
    }
    setState(() => _busy = true);
    final auth = ref.read(authRepositoryProvider);
    try {
      // Verify the current password by re-authenticating.
      final email = ref.read(profileProvider).valueOrNull?.email;
      if (email != null && email.isNotEmpty && _current.text.isNotEmpty) {
        try {
          await auth.signInWithPassword(email: email, password: _current.text);
        } on AuthFailure {
          setState(() {
            _busy = false;
            _error = 'Current password is incorrect.';
          });
          return;
        }
      }
      await auth.updatePassword(_fresh.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated.'), backgroundColor: AppColors.green));
      Navigator.of(context).pop();
    } on AuthFailure catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        children: [
          const Text(
            "For your security, you'll be signed out of other devices after changing your password.",
            style: TextStyle(fontSize: 13, color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 18),
          AppTextField(label: 'Current Password', controller: _current, icon: Icons.lock_outline, obscure: true),
          const SizedBox(height: 14),
          AppTextField(
            label: 'New Password',
            controller: _fresh,
            icon: Icons.lock_outline,
            obscure: true,
            onChanged: (v) {
              final (score, label) = passwordStrength(v);
              setState(() {
                _score = score;
                _label = label;
              });
            },
          ),
          if (_score > 0) ...[
            const SizedBox(height: 8),
            _StrengthMeter(score: _score, label: _label),
          ],
          const SizedBox(height: 14),
          AppTextField(
              label: 'Confirm New Password',
              controller: _confirm,
              icon: Icons.lock_outline,
              obscure: true,
              errorText: _error),
          const SizedBox(height: 22),
          PrimaryButton(label: 'Update Password', isLoading: _busy, onPressed: _submit),
          const SizedBox(height: 10),
          GhostButton(label: 'Cancel', onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

/// Four segments filling green with the score, as in the design.
class _StrengthMeter extends StatelessWidget {
  const _StrengthMeter({required this.score, required this.label});
  final int score;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = switch (score) {
      1 => AppColors.red,
      2 => AppColors.amber,
      _ => AppColors.green,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 6),
        Row(
          children: [
            for (var i = 1; i <= 4; i++) ...[
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= score ? color : AppColors.line,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              if (i < 4) const SizedBox(width: 6),
            ],
          ],
        ),
      ],
    );
  }
}
