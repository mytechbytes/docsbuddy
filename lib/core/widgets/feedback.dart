import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/failure_reporter.dart';
import '../l10n/failure_text.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import 'loader.dart';

/// Snackbar feedback. Error text is always localized from the failure, so
/// widgets never decide how an error is worded.
extension FeedbackContext on BuildContext {
  /// Shows [error] as a snackbar — and reports it (see [FailureReporter]), so
  /// an unexpected failure is never both shown and forgotten.
  void showFailure(Object error, [StackTrace? stack]) {
    _report(error, stack);
    _snack(failureText(error), AppColors.red);
  }

  /// Text for an error shown inline (a form field) rather than as a snackbar;
  /// reported like [showFailure]. Call it from a `catch`, not from `build`.
  String failureMessage(Object error, [StackTrace? stack]) {
    _report(error, stack);
    return failureText(error);
  }

  /// Localized, user-facing text for [error] (see `localizeFailure`). Pure —
  /// safe to call while building; it does not report.
  String failureText(Object error) => localizeFailure(l10n, error);

  void _report(Object error, StackTrace? stack) {
    try {
      ProviderScope.containerOf(this, listen: false).read(failureReporterProvider).report(error, stack);
    } catch (_) {
      // No provider scope or logger here (a bare widget test, a catalog
      // page). Reporting is best-effort and must never break the UI.
    }
  }

  void showSuccess(String message) => _snack(message, AppColors.green);

  void _snack(String message, Color color) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}

/// Runs a controller action behind a loader that says what is happening ([loading] is required so no remote
/// call goes unannounced), then shows the failure (or [success]) as a snackbar. Returns whether it succeeded.
Future<bool> runAction(
  BuildContext context,
  Future<void> Function() action, {
  required String loading,
  String? success,
}) =>
    runLocalAction(context, () => withLoader(context, loading, action), success: success);

/// [runAction] without a loader, for work that isn't a remote call (opening the share sheet or an external viewer).
Future<bool> runLocalAction(BuildContext context, Future<void> Function() action, {String? success}) async {
  try {
    await action();
    if (success != null && context.mounted) context.showSuccess(success);
    return true;
  } catch (e, stack) {
    if (context.mounted) context.showFailure(e, stack);
    return false;
  }
}
