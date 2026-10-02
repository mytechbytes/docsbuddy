import 'package:flutter/material.dart';

import 'adaptive_layout.dart';
import 'buttons.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';

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
                    color: i <= step ? context.palette.accent : context.palette.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        Text('STEP ${step + 1} OF $total',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.textMuted, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: context.palette.text)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: TextStyle(fontSize: 13, color: context.palette.textMuted)),
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

  /// Narrowest (at the default font size) that fits Back and Next side by side.
  static const _sideBySideWidth = 240.0;

  @override
  Widget build(BuildContext context) {
    final showBack = step > 0 && onBack != null;
    final back = OutlinedButton(
      onPressed: busy ? null : onBack,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: context.palette.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(context.l10n.commonBack,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.palette.text)),
    );
    final next = PrimaryButton(label: nextLabel, isLoading: busy, onPressed: onNext);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Two buttons share the row until large text leaves "Back" too little
        // width for its own word; then Next goes on top, Back beneath it.
        if (!showBack || fitsAtScale(context, constraints.maxWidth, _sideBySideWidth)) {
          return Row(
            children: [
              if (showBack) ...[Expanded(child: back), const SizedBox(width: 12)],
              Expanded(flex: 2, child: next),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [next, const SizedBox(height: 10), back],
        );
      },
    );
  }
}
