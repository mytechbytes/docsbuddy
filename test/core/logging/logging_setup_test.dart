import 'dart:ui' show ErrorCallback;

import 'package:docsbuddy/core/logging/app_logger.dart';
import 'package:docsbuddy/core/logging/logging_setup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  group('createLogger', () {
    test('uses the debug console when crash reporting is unavailable', () {
      expect(createLogger(firebaseReady: false), isA<DebugAppLogger>());
    });

    test('uses the debug console in debug builds even when Firebase is up', () {
      // Tests run in debug mode: Crashlytics is for release builds only.
      expect(createLogger(firebaseReady: true), isA<DebugAppLogger>());
    });
  });

  group('reportUncaughtErrors', () {
    late FlutterExceptionHandler? originalFlutterHandler;
    late ErrorCallback? originalPlatformHandler;

    setUp(() {
      originalFlutterHandler = FlutterError.onError;
      originalPlatformHandler = PlatformDispatcher.instance.onError;
    });

    tearDown(() {
      FlutterError.onError = originalFlutterHandler;
      PlatformDispatcher.instance.onError = originalPlatformHandler;
    });

    test('sends framework errors to the logger as fatal', () {
      final logger = RecordingLogger();
      reportUncaughtErrors(logger);

      FlutterError.onError!(FlutterErrorDetails(exception: StateError('widget exploded'), silent: true));

      expect(logger.errors, ['Uncaught Flutter error']);
    });

    test('sends async platform errors to the logger and marks them handled', () {
      final logger = RecordingLogger();
      reportUncaughtErrors(logger);

      final handled = PlatformDispatcher.instance.onError!(StateError('async boom'), StackTrace.current);

      expect(handled, isTrue, reason: 'otherwise the engine would also kill the app');
      expect(logger.errors, ['Uncaught platform error']);
    });
  });
}
