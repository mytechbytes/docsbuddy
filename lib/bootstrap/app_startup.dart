import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/env.dart';
import '../core/logging/app_logger.dart';
import 'backend_module.dart';
import '../core/logging/logging_setup.dart' as logging;
import 'firebase_init.dart' as firebase;
import 'dependencies.dart' as deps;

/// What the startup screen tells the user, in the order it happens.
enum StartupStep {
  /// Firebase (crash reporting + push) and the error handlers.
  services,

  /// The backend client, including restoring a saved sign-in.
  account,

  /// On-device settings (onboarding flag, appearance, app lock).
  preferences,
}

/// Everything the app needs before its first real screen can be built.
final class AppBootstrap {
  const AppBootstrap({required this.logger, required this.firebaseReady, required this.backend, required this.prefs});

  final AppLogger logger;
  final bool firebaseReady;
  final BackendModule backend;
  final SharedPreferences prefs;
}

sealed class StartupState {
  const StartupState();
}

final class StartupRunning extends StartupState {
  const StartupRunning(this.step);
  final StartupStep step;
}

/// A step threw; [AppStartup.run] again to retry from that step.
final class StartupFailed extends StartupState {
  const StartupFailed(this.error);
  final Object error;

  /// One line saying what actually broke, for the failure screen: a tester can report it, and the screen can tell a
  /// network problem from a broken keystore.
  String get summary {
    final line = error.toString().split('\n').first.trim();
    return line.length <= 140 ? line : '${line.substring(0, 140)}…';
  }
}

final class StartupReady extends StartupState {
  const StartupReady(this.bootstrap);
  final AppBootstrap bootstrap;
}

/// Runs the one-off work that must finish before the app can start, reporting each step so the UI shows progress.
/// Completed steps are remembered, so a retry resumes at the failed step instead of re-initialising Firebase or Supabase.
class AppStartup {
  AppStartup({
    Future<bool> Function()? initFirebase,
    AppLogger Function({required bool firebaseReady})? createLogger,
    void Function(AppLogger logger)? reportUncaughtErrors,
    Future<BackendModule> Function(AppLogger logger)? createBackend,
    Future<SharedPreferences> Function()? loadPreferences,
  })  : _initFirebase = initFirebase ?? firebase.initFirebase,
        _createLogger = createLogger ?? logging.createLogger,
        _reportUncaughtErrors = reportUncaughtErrors ?? logging.reportUncaughtErrors,
        _createBackend = createBackend ?? ((logger) => deps.createBackend(Env.backend, logger: logger)),
        _loadPreferences = loadPreferences ?? SharedPreferences.getInstance;

  final Future<bool> Function() _initFirebase;
  final AppLogger Function({required bool firebaseReady}) _createLogger;
  final void Function(AppLogger logger) _reportUncaughtErrors;
  final Future<BackendModule> Function(AppLogger logger) _createBackend;
  final Future<SharedPreferences> Function() _loadPreferences;

  // Results of completed steps, kept so a retry doesn't repeat them.
  bool? _firebaseReady;
  AppLogger? _logger;
  BackendModule? _backend;
  SharedPreferences? _prefs;

  Stream<StartupState> run() async* {
    try {
      if (_logger == null) {
        yield const StartupRunning(StartupStep.services);
        final ready = await _timed('services', _initFirebase);
        final logger = _createLogger(firebaseReady: ready);
        _reportUncaughtErrors(logger);
        _firebaseReady = ready;
        _logger = logger;
      }
      if (_backend == null) {
        yield const StartupRunning(StartupStep.account);
        _backend = await _timed('account', () => _createBackend(_logger!));
      }
      if (_prefs == null) {
        yield const StartupRunning(StartupStep.preferences);
        _prefs = await _timed('preferences', _loadPreferences);
      }
      yield StartupReady(AppBootstrap(logger: _logger!, firebaseReady: _firebaseReady!, backend: _backend!, prefs: _prefs!));
    } catch (error, stack) {
      (_logger ?? const DebugAppLogger()).error('App startup failed', error: error, stackTrace: stack);
      yield StartupFailed(error);
    }
  }

  /// Debug builds print how long each step took, to see what slows a launch.
  Future<T> _timed<T>(String name, Future<T> Function() step) async {
    final clock = Stopwatch()..start();
    try {
      return await step();
    } finally {
      if (kDebugMode) debugPrint('startup: $name took ${clock.elapsedMilliseconds} ms');
    }
  }
}
