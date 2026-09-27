import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'app_logger.dart';

/// Sends warnings and errors to Firebase Crashlytics (non-fatal unless
/// [fatal]) and breadcrumbs for [info]. Requires Firebase to be initialised.
class CrashlyticsAppLogger implements AppLogger {
  CrashlyticsAppLogger([FirebaseCrashlytics? crashlytics]) : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseCrashlytics _crashlytics;

  @override
  void info(String message) => _crashlytics.log(message);

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _crashlytics.log(message);
    if (error != null) _crashlytics.recordError(error, stackTrace, reason: message);
  }

  @override
  void error(String message, {required Object error, StackTrace? stackTrace, bool fatal = false}) =>
      _crashlytics.recordError(error, stackTrace, reason: message, fatal: fatal);
}
