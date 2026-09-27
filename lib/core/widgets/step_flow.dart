import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'buttons.dart';
import '../l10n/l10n.dart';

/// Header for a multi-step form: "STEP i OF n", the step title, and a
/// segmented progress bar.
class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.step, required this.total, required this.title, this.subtitle});

  /// Zero-based current step.
  final int step;
  final int total;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < total; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= step ? AppColors.chipBlue : AppColors.line,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        Text('STEP ${step + 1} OF $total',
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
        ],
      ],
    );
  }
}

/// Bottom navigation for a multi-step form: Back (when not on the first
/// step) and a primary Next / submit button.
class StepNav extends StatelessWidget {
  const StepNav({
    super.key,
    required this.step,
    required this.nextLabel,
    required this.onNext,
    this.onBack,
    this.busy = false,
  });

  final int step;
  final String nextLabel;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (step > 0 && onBack != null) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: busy ? null : onBack,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: AppColors.line, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(context.l10n.commonBack,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(flex: 2, child: PrimaryButton(label: nextLabel, isLoading: busy, onPressed: onNext)),
      ],
    );
  }
}
