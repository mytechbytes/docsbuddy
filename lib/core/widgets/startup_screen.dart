import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'db_logo.dart';

/// The launch screen shown while the app gets ready: the stacked brand lockup
/// (mark over wordmark) on the launcher-icon tint, with what the app is doing —
/// a spinner and message — or what went wrong underneath.
///
/// Always light, like the native splash it follows, whatever the theme. The
/// tint is the launcher icon's, so the OS splash, this screen and the app icon
/// read as one brand moment; the OS splash shows the mark alone, so the
/// wordmark appears as this screen takes over.
class StartupScreen extends StatelessWidget {
  /// Working: a spinner, what is happening, and where we are in the sequence.
  const StartupScreen.progress({super.key, required String this.message, required String this.stepLabel})
      : title = null,
        body = null,
        detail = null,
        retryLabel = null,
        onRetry = null;

  /// Stuck: what went wrong and a way to try again.
  const StartupScreen.failed({
    super.key,
    required String this.title,
    required String this.body,
    this.detail,
    required String this.retryLabel,
    required VoidCallback this.onRetry,
  })  : message = null,
        stepLabel = null;

  final String? message;
  final String? stepLabel;
  final String? title;
  final String? body;

  /// What actually went wrong, small and selectable, so it can be reported.
  final String? detail;
  final String? retryLabel;
  final VoidCallback? onRetry;

  bool get _failed => onRetry != null;

  @override
  Widget build(BuildContext context) {
    return Theme(
      // The logo reads the theme's palette; pin it to light so the wordmark
      // stays legible on the light tint even when the app is in dark mode.
      data: AppTheme.light,
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: SafeArea(
          // Centred when it fits; scrolls on a short screen or at a large font
          // size rather than overflowing.
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const DbLogo(size: 34, stacked: true),
                        const SizedBox(height: 40),
                        _failed
                            ? _Failure(title: title!, body: body!, detail: detail, retryLabel: retryLabel!, onRetry: onRetry!)
                            : _Progress(message: message!, stepLabel: stepLabel!),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.message, required this.stepLabel});
  final String message;
  final String stepLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.teal),
        ),
        const SizedBox(height: 16),
        // Announced to screen readers as it changes.
        Semantics(
          liveRegion: true,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              message,
              key: ValueKey(message),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(stepLabel, style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
      ],
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.title, required this.body, this.detail, required this.retryLabel, required this.onRetry});
  final String title;
  final String body;
  final String? detail;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline_rounded, size: 32, color: AppColors.red),
        const SizedBox(height: 12),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink)),
        const SizedBox(height: 6),
        Text(body,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13.5, height: 1.4, color: AppColors.muted)),
        if (detail != null) ...[
          const SizedBox(height: 10),
          SelectableText(detail!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11.5, height: 1.35, color: AppColors.muted, fontFamily: 'monospace')),
        ],
        const SizedBox(height: 18),
        FilledButton(
          onPressed: onRetry,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.ink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(retryLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
