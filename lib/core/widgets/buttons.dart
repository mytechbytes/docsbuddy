import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Filled dark CTA — matches `PrimaryBtn` in the design handoff.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;

  /// When true the button shows a spinner and ignores taps.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // 54dp is a minimum, not a fixed height: a long label or large text wraps
    // and the button grows with it instead of clipping.
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          backgroundColor: context.palette.inverseSurface,
          foregroundColor: context.palette.onInverse,
          disabledBackgroundColor: context.palette.inverseSurface,
          disabledForegroundColor: context.palette.onInverse,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: context.palette.onInverse),
              )
            : Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}

/// Outlined secondary CTA — matches `GhostBtn` in the design handoff.
class GhostButton extends StatelessWidget {
  const GhostButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          foregroundColor: context.palette.text,
          backgroundColor: context.palette.surface,
          side: BorderSide(color: context.palette.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
