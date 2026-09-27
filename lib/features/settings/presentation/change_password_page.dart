import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/feedback.dart';
import '../../auth/domain/password_policy.dart';
import '../application/change_password_controller.dart';
import '../../../core/l10n/l10n.dart';

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
    try {
      await ref
          .read(changePasswordControllerProvider.notifier)
          .submit(current: _current.text, fresh: _fresh.text, confirmation: _confirm.text);
      if (!mounted) return;
      context.showSuccess(context.l10n.changePasswordDone);
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = failureMessage(e));
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
        title: Text(context.l10n.changePasswordTitle, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        children: [
          Text(
            context.l10n.changePasswordNotice,
            style: const TextStyle(fontSize: 13, color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 18),
          AppTextField(label: context.l10n.changePasswordCurrent, controller: _current, icon: Icons.lock_outline, obscure: true),
          const SizedBox(height: 14),
          AppTextField(
            label: context.l10n.authNewPassword,
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
              label: context.l10n.changePasswordConfirm,
              controller: _confirm,
              icon: Icons.lock_outline,
              obscure: true,
              errorText: _error),
          const SizedBox(height: 22),
          PrimaryButton(label: context.l10n.changePasswordCta, isLoading: ref.watch(changePasswordControllerProvider).isLoading, onPressed: _submit),
          const SizedBox(height: 10),
          GhostButton(label: context.l10n.commonCancel, onPressed: () => Navigator.of(context).pop()),
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
