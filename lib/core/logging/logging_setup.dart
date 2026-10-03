import 'package:flutter/foundation.dart';

import 'app_logger.dart';
import 'crashlytics_logger.dart';

/// The app's logger: Crashlytics in release builds when Firebase is up, the
/// debug console otherwise. Everything that logs goes through the [AppLogger]
/// this returns (see `appLoggerProvider`).
AppLogger createLogger({required bool firebaseReady}) =>
    firebaseReady && !kDebugMode ? CrashlyticsAppLogger() : const DebugAppLogger();

/// Routes uncaught framework and platform errors to [logger] as fatal.
void reportUncaughtErrors(AppLogger logger) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.error('Uncaught Flutter error', error: details.exception, stackTrace: details.stack, fatal: true);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error('Uncaught platform error', error: error, stackTrace: stack, fatal: true);
    return true;
  };
}
