import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Diagnostics sink. Best-effort paths (photo upload, timezone sync, push) swallow failures so users aren't
/// blocked, but report them here.
abstract interface class AppLogger {
  void info(String message);

  /// Something failed but the app recovered (a best-effort step).
  void warning(String message, {Object? error, StackTrace? stackTrace});

  /// An unexpected failure; [fatal] for uncaught errors.
  void error(String message, {required Object error, StackTrace? stackTrace, bool fatal = false});
}

/// Writes to the debug console (`dart:developer`). Used in debug builds and
/// whenever crash reporting isn't available.
class DebugAppLogger implements AppLogger {
  const DebugAppLogger();

  @override
  void info(String message) => developer.log(message, name: 'docsbuddy');

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) =>
      developer.log(message, name: 'docsbuddy', level: 900, error: error, stackTrace: stackTrace);

  @override
  void error(String message, {required Object error, StackTrace? stackTrace, bool fatal = false}) =>
      developer.log(message, name: 'docsbuddy', level: 1000, error: error, stackTrace: stackTrace);
}

final appLoggerProvider = Provider<AppLogger>(
  (ref) => throw UnimplementedError('appLoggerProvider must be overridden'),
);
