import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The launch screen shown while the app gets ready: the brand mark centred on
/// the launcher-icon tint — exactly where the native splash draws it, so the
/// hand-off from the OS splash to this screen doesn't jump — with what the app
/// is doing (or what went wrong) underneath.
///
/// Always light, like the native splash it follows, whatever the theme.
class StartupScreen extends StatelessWidget {
  /// Working: a spinner, what is happening, and where we are in the sequence.
  const StartupScreen.progress({super.key, required String this.message, required String this.stepLabel})
      : title = null,
        body = null,
        retryLabel = null,
        onRetry = null;

  /// Stuck: what went wrong and a way to try again.
  const StartupScreen.failed({
    super.key,
    required String this.title,
    required String this.body,
    required String this.retryLabel,
    required VoidCallback this.onRetry,
  })  : message = null,
        stepLabel = null;

  /// Matches the native splash icon canvas (224 dp: fits the circle Android 12+ masks the splash icon to).
  static const markSize = 224.0;

  final String? message;
  final String? stepLabel;
  final String? title;
  final String? body;
  final String? retryLabel;
  final VoidCallback? onRetry;

  bool get _failed => onRetry != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/icon/adaptive_foreground.png',
              width: markSize,
              height: markSize,
              filterQuality: FilterQuality.medium,
              excludeFromSemantics: true,
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.62),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _failed ? _Failure(title: title!, body: body!, retryLabel: retryLabel!, onRetry: onRetry!) : _Progress(message: message!, stepLabel: stepLabel!),
            ),
          ),
        ],
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
  const _Failure({required this.title, required this.body, required this.retryLabel, required this.onRetry});
  final String title;
  final String body;
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
