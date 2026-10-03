import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logging/app_logger.dart';
import 'app_failure.dart';

/// Decides which failures are worth a log line, and logs each once.
/// Unexpected failures ([UnknownFailure], or an untranslated exception) are errors with the real cause;
/// [ServerFailure] is a warning; failures the user causes and the app expects (offline, wrong password,
/// blank form) are not logged.
class FailureReporter {
  FailureReporter(this._logger);

  final AppLogger _logger;

  /// Failures already reported, so one that is seen twice (by the provider
  /// observer, then again when a screen shows it) is logged once.
  final _seen = Expando<bool>('reported failure');

  void report(Object error, [StackTrace? stack]) {
    if (!_firstSighting(error)) return;
    switch (error) {
      case UnknownFailure(:final cause):
        _logger.error('Unexpected failure', error: cause ?? error, stackTrace: stack);
      case ServerFailure():
        _logger.warning('Server rejected the request', error: error, stackTrace: stack);
      case AppFailure():
        break; // expected: the user can see it and act on it
      default:
        _logger.error('Unhandled exception', error: error, stackTrace: stack);
    }
  }

  bool _firstSighting(Object error) {
    try {
      if (_seen[error] ?? false) return false;
      _seen[error] = true;
    } on ArgumentError {
      // Strings and numbers can't be tracked (a thrown string is legal Dart);
      // better a possible duplicate than a missed report.
    }
    return true;
  }
}

final failureReporterProvider = Provider<FailureReporter>((ref) => FailureReporter(ref.watch(appLoggerProvider)));

/// Reports every provider that ends in an error (a screen failing to load, a controller in its error state).
final class FailureObserver extends ProviderObserver {
  const FailureObserver(this._reporter);

  final FailureReporter _reporter;

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) =>
      _reporter.report(error, stackTrace);
}
