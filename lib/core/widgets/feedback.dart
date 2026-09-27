import 'package:flutter/material.dart';

import '../error/app_failure.dart';
import '../theme/app_colors.dart';

/// Snackbar feedback. Error text always comes from [AppFailure.message], so
/// widgets never decide how an error is worded.
extension FeedbackContext on BuildContext {
  void showFailure(Object error) => _snack(AppFailure.from(error).message, AppColors.red);

  void showSuccess(String message) => _snack(message, AppColors.green);

  void _snack(String message, Color color) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}

/// User-facing text for an [AsyncValue] error.
String failureMessage(Object error) => AppFailure.from(error).message;

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
