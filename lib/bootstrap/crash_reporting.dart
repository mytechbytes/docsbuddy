import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../core/logging/app_logger.dart';
import '../core/logging/crashlytics_logger.dart';

/// Initialises Firebase once for the whole app (Crashlytics + push). False
/// when this platform has no Firebase config (e.g. iOS without
/// GoogleService-Info.plist, desktop).
Future<bool> initFirebase() async {
  if (Firebase.apps.isNotEmpty) return true; // already up (e.g. a startup retry)
  try {
    await Firebase.initializeApp();
    return true;
  } catch (_) {
    return false; // No logger exists yet; callers fall back to the console.
  }
}

/// Crashlytics in release builds when Firebase is up; the console otherwise.
AppLogger createLogger({required bool firebaseReady}) =>
    firebaseReady && !kDebugMode ? CrashlyticsAppLogger() : const DebugAppLogger();

/// Routes uncaught framework and platform errors to [logger].
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
