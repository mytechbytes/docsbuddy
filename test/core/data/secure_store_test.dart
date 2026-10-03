import 'dart:async';

import 'package:docsbuddy/core/data/secure_store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_app.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

/// What the Android plugin throws when the Keystore can't decrypt an entry
/// (e.g. ciphertext restored from another device's Auto Backup).
PlatformException _keystoreFailure() =>
    PlatformException(code: 'Exception encountered', message: 'read', details: 'InvalidKeyException: Failed to unwrap key');

void main() {
  late _MockStorage storage;
  late RecordingLogger logger;
  late SecureStore store;

  setUp(() {
    storage = _MockStorage();
    logger = RecordingLogger();
    store = SecureStore(storage, logger: logger, timeout: const Duration(milliseconds: 50));
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});
  });

  group('when the keystore works', () {
    test('reads, writes, checks and deletes pass straight through', () async {
      when(() => storage.read(key: 'k')).thenAnswer((_) async => 'v');
      when(() => storage.containsKey(key: 'k')).thenAnswer((_) async => true);
      when(() => storage.write(key: 'k', value: 'v')).thenAnswer((_) async {});

      expect(await store.read('k'), 'v');
      expect(await store.containsKey('k'), isTrue);
      await store.write('k', 'v');
      await store.delete('k');

      verify(() => storage.write(key: 'k', value: 'v')).called(1);
      verify(() => storage.delete(key: 'k')).called(1);
      expect(logger.warnings, isEmpty);
    });
  });

  group('an entry the keystore cannot decrypt', () {
    test('reads as absent instead of throwing, and is dropped so it is not tripped over again', () async {
      when(() => storage.read(key: 'supabase_session')).thenThrow(_keystoreFailure());

      expect(await store.read('supabase_session'), isNull);

      verify(() => storage.delete(key: 'supabase_session')).called(1);
      expect(logger.warnings, hasLength(1), reason: 'reported, so a field problem is visible in Crashlytics');
    });

    test('still reports the entry as present until a read proves it unreadable', () async {
      when(() => storage.containsKey(key: 'k')).thenAnswer((_) async => true);
      expect(await store.containsKey('k'), isTrue);
    });

    test('a failing existence check answers "no" instead of throwing', () async {
      when(() => storage.containsKey(key: 'k')).thenThrow(_keystoreFailure());
      expect(await store.containsKey('k'), isFalse);
      expect(logger.warnings, hasLength(1));
    });

    test('failing to drop the entry is not fatal either', () async {
      when(() => storage.read(key: 'k')).thenThrow(_keystoreFailure());
      when(() => storage.delete(key: 'k')).thenThrow(_keystoreFailure());
      expect(await store.read('k'), isNull);
    });
  });

  group('a keystore that refuses writes', () {
    test('keeps the value for this process so the flow in flight still completes', () async {
      when(() => storage.write(key: 'verifier', value: 'abc')).thenThrow(_keystoreFailure());
      when(() => storage.read(key: 'verifier')).thenThrow(_keystoreFailure());

      await store.write('verifier', 'abc'); // must not throw

      expect(await store.containsKey('verifier'), isTrue);
      expect(await store.read('verifier'), 'abc');
      expect(logger.warnings, isNotEmpty);
    });

    test('a later successful write replaces the in-memory copy', () async {
      when(() => storage.write(key: 'k', value: 'old')).thenThrow(_keystoreFailure());
      await store.write('k', 'old');

      when(() => storage.write(key: 'k', value: 'new')).thenAnswer((_) async {});
      when(() => storage.read(key: 'k')).thenAnswer((_) async => 'new');
      await store.write('k', 'new');

      expect(await store.read('k'), 'new');
    });

    test('delete clears the in-memory copy too', () async {
      when(() => storage.write(key: 'k', value: 'v')).thenThrow(_keystoreFailure());
      when(() => storage.read(key: 'k')).thenAnswer((_) async => null);
      when(() => storage.containsKey(key: 'k')).thenAnswer((_) async => false);
      await store.write('k', 'v');

      await store.delete('k');

      expect(await store.read('k'), isNull);
      expect(await store.containsKey('k'), isFalse);
    });
  });

  group('a keystore call that never answers', () {
    // The Android plugin has a code path that neither succeeds nor fails.
    test('read gives up and answers "absent" rather than hanging start-up', () async {
      when(() => storage.read(key: 'k')).thenAnswer((_) => Completer<String?>().future);
      expect(await store.read('k'), isNull);
      expect(logger.warnings, hasLength(1));
    });

    test('write gives up and keeps the value in memory', () async {
      when(() => storage.write(key: 'k', value: 'v')).thenAnswer((_) => Completer<void>().future);
      await store.write('k', 'v');
      expect(await store.read('k'), 'v');
    });
  });
}
