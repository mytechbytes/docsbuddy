import 'package:flutter/material.dart';

import '../l10n/failure_text.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';

/// Snackbar feedback. Error text is always localized from the failure, so
/// widgets never decide how an error is worded.
extension FeedbackContext on BuildContext {
  void showFailure(Object error) => _snack(failureText(error), AppColors.red);

  /// Localized, user-facing text for [error] (see `localizeFailure`).
  String failureText(Object error) => localizeFailure(l10n, error);

  void showSuccess(String message) => _snack(message, AppColors.green);

  void _snack(String message, Color color) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}

/// Runs a controller action from a widget callback: shows the failure (or
/// [success]) as a snackbar and reports whether it succeeded. Keeps widgets
/// free of try/catch and error wording.
Future<bool> runAction(BuildContext context, Future<void> Function() action, {String? success}) async {
  try {
    await action();
    if (success != null && context.mounted) context.showSuccess(success);
    return true;
  } catch (e) {
    if (context.mounted) context.showFailure(e);
    return false;
  }
}
