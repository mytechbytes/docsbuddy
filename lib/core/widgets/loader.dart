import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Runs [task] behind a blocking loader that says what is happening.
///
/// The loader is up before [task] starts and is always taken down afterwards —
/// whether [task] returns or throws — so the caller only has to act on the
/// outcome (a snackbar, a navigation). Taps and the back button are blocked
/// while it shows, which also stops a second tap from starting the work twice.
///
/// Only this call's own route is removed, so a screen the task pushed, or one
/// that already replaced this page (sign-in redirecting to the dashboard), is
/// never popped by mistake.
Future<T> withLoader<T>(BuildContext context, String message, Future<T> Function() task) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(canPop: false, child: LoaderDialog(message: message)),
  );
  unawaited(navigator.push(route));
  try {
    return await task();
  } finally {
    if (route.isActive) navigator.removeRoute(route);
  }
}

/// The dialog [withLoader] shows: a spinner and what is being done.
class LoaderDialog extends StatelessWidget {
  const LoaderDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Dialog(
      backgroundColor: palette.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        // Announced to screen readers when it appears.
        child: Semantics(
          liveRegion: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3, color: palette.accent)),
              const SizedBox(width: 18),
              // Wraps instead of clipping at large text sizes.
              Flexible(
                child: Text(message, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: palette.text)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// What a screen shows while its data loads: a spinner and what is loading.
/// Replaces a bare `CircularProgressIndicator` so the wait is never unlabeled.
class LoadingView extends StatelessWidget {
  /// A whole screen (or tab) body, centred.
  const LoadingView({super.key, required this.message}) : _section = false;

  /// One section inside a screen that has other content around it.
  const LoadingView.section({super.key, required this.message}) : _section = true;

  final String message;
  final bool _section;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final spinner = SizedBox(
      width: _section ? 20 : 28,
      height: _section ? 20 : 28,
      child: CircularProgressIndicator(strokeWidth: _section ? 2.4 : 3, color: palette.accent),
    );
    final label = Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: _section ? 13.5 : 15, fontWeight: FontWeight.w600, color: palette.textMuted),
    );
    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(_section ? 16 : 32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [spinner, SizedBox(height: _section ? 8 : 16), label]),
        ),
      ),
    );
  }
}
