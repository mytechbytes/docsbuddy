import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/error/failure_reporter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  late RecordingLogger logger;
  late FailureReporter reporter;

  setUp(() {
    logger = RecordingLogger();
    reporter = FailureReporter(logger);
  });

  group('what gets reported', () {
    test('an unexpected failure is an error, with its real cause', () {
      reporter.report(UnknownFailure(StateError('boom')), StackTrace.current);
      expect(logger.errors, hasLength(1));
    });

    test('an exception nobody translated is an error too', () {
      reporter.report(StateError('boom'));
      expect(logger.errors, hasLength(1));
    });

    test('the server refusing a request is worth a warning', () {
      reporter.report(const ServerFailure('duplicate key'));
      expect(logger.warnings, hasLength(1));
      expect(logger.errors, isEmpty);
    });

    test('things users cause and the app expects are not logged', () {
      for (final expected in <AppFailure>[
        const NetworkFailure(),
        const AuthFailure('Invalid login credentials'),
        const ValidationFailure('Name required'),
        const UnavailableFailure('No backend'),
      ]) {
        reporter.report(expected);
      }
      expect(logger.errors, isEmpty);
      expect(logger.warnings, isEmpty);
    });

    test('a thrown string (legal in Dart) is still reported rather than crashing the reporter', () {
      reporter.report('just a string');
      expect(logger.errors, hasLength(1));
    });
  });

  test('the same failure reaching the reporter twice is logged once', () {
    final failure = UnknownFailure(StateError('boom'));
    reporter.report(failure); // e.g. seen by the provider observer…
    reporter.report(failure); // …and again when the UI shows it
    expect(logger.errors, hasLength(1));

    reporter.report(UnknownFailure(StateError('a different one')));
    expect(logger.errors, hasLength(2));
  });

  group('FailureObserver', () {
    test('reports a provider that failed to load, wherever it is read', () async {
      final loadsBadly = FutureProvider<int>((ref) => throw StateError('boom'));
      final container = ProviderContainer.test(observers: [FailureObserver(reporter)]);

      await expectLater(container.read(loadsBadly.future), throwsStateError);

      expect(logger.errors, hasLength(1));
    });

    test('says nothing while providers are healthy', () async {
      final fine = FutureProvider<int>((ref) async => 1);
      final container = ProviderContainer.test(observers: [FailureObserver(reporter)]);

      expect(await container.read(fine.future), 1);

      expect(logger.errors, isEmpty);
    });
  });
}
