import 'package:docsbuddy/bootstrap/app_startup.dart';
import 'package:docsbuddy/bootstrap/backends/fake_backend.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_app.dart';

void main() {
  late int firebaseRuns;
  late int backendRuns;
  late bool failBackend;

  AppStartup startup() => AppStartup(
        initFirebase: () async {
          firebaseRuns++;
          return false;
        },
        createLogger: ({required firebaseReady}) => RecordingLogger(),
        reportUncaughtErrors: (_) {},
        createBackend: (_) async {
          backendRuns++;
          if (failBackend) throw StateError('backend unreachable');
          return FakeBackend();
        },
        loadPreferences: () async {
          SharedPreferences.setMockInitialValues({});
          return SharedPreferences.getInstance();
        },
      );

  setUp(() {
    firebaseRuns = 0;
    backendRuns = 0;
    failBackend = false;
  });

  test('reports each step in order, then hands over everything the app needs', () async {
    final states = await startup().run().toList();

    expect(states.take(3).map((s) => (s as StartupRunning).step), StartupStep.values);
    final ready = states.last as StartupReady;
    expect(ready.bootstrap.firebaseReady, isFalse);
    expect(ready.bootstrap.backend, isA<FakeBackend>());
    expect(ready.bootstrap.prefs, isNotNull);
    expect(states, hasLength(4));
  });

  test('a failing step reports the failure instead of leaving the app blank', () async {
    failBackend = true;
    final states = await startup().run().toList();

    expect(states.last, isA<StartupFailed>());
    expect((states.last as StartupFailed).error, isA<StateError>());
    expect(states.whereType<StartupReady>(), isEmpty);
  });

  test('retry resumes at the failed step without re-initialising finished ones', () async {
    final s = startup();
    failBackend = true;
    await s.run().toList();
    expect((firebaseRuns, backendRuns), (1, 1));

    failBackend = false;
    final retry = await s.run().toList();

    expect(retry.first, isA<StartupRunning>().having((r) => r.step, 'step', StartupStep.account));
    expect(retry.last, isA<StartupReady>());
    expect(firebaseRuns, 1, reason: 'Firebase must not be initialised twice');
    expect(backendRuns, 2);
  });

  group('StartupFailed.summary', () {
    test('is the first line of the error, so the screen shows the real cause', () {
      final failed = StartupFailed(
        PlatformException(code: 'Exception encountered', message: 'read', details: 'Failed to unwrap key\n\tat javax.crypto.Cipher'),
      );
      expect(failed.summary, isNot(contains('\n')));
      expect(failed.summary, contains('Exception encountered'));
    });

    test('is capped so a long stack trace cannot fill the screen', () {
      final failed = StartupFailed(StateError('x' * 500));
      expect(failed.summary.length, lessThanOrEqualTo(141));
      expect(failed.summary, endsWith('…'));
    });
  });
}
