import 'package:docsbuddy/core/data/secure_store.dart';
import 'package:docsbuddy/core/data/supabase/secure_supabase_storage.dart';
import 'package:docsbuddy/core/data/supabase/supabase_initializer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockVault extends Mock implements FlutterSecureStorage {}

/// A session store that has a saved session it can't decrypt — what a device
/// restored from another phone's backup looks like to `Supabase.initialize`.
class _UndecryptableSession extends LocalStorage {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => true;

  @override
  Future<String?> accessToken() async =>
      throw PlatformException(code: 'Exception encountered', message: 'read', details: 'Failed to unwrap key');

  @override
  Future<void> persistSession(String persistSessionString) async {}

  @override
  Future<void> removePersistedSession() async {}
}

class _MemoryLocalStorage extends LocalStorage {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => false;

  @override
  Future<String?> accessToken() async => null;

  @override
  Future<void> persistSession(String persistSessionString) async {}

  @override
  Future<void> removePersistedSession() async {}
}

class _MemoryPkce extends GotrueAsyncStorage {
  final items = <String, String>{};

  @override
  Future<String?> getItem({required String key}) async => items[key];

  @override
  Future<void> removeItem({required String key}) async => items.remove(key);

  @override
  Future<void> setItem({required String key, required String value}) async => items[key] = value;
}

FlutterAuthClientOptions _options(LocalStorage storage) =>
    FlutterAuthClientOptions(localStorage: storage, pkceAsyncStorage: _MemoryPkce(), detectSessionInUri: false);

Future<Supabase> _init(LocalStorage storage) =>
    initializeSupabase(url: 'https://example.supabase.co', publishableKey: 'key', authOptions: _options(storage));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // `Supabase.instance` itself asserts while the SDK is uninitialised.
  bool initialised() {
    try {
      return Supabase.instance.isInitialized;
    } on AssertionError {
      return false;
    }
  }

  tearDown(() async {
    if (initialised()) await Supabase.instance.dispose();
  });

  test('a failed initialise is rolled back, so a retry does a real one', () async {
    await expectLater(_init(_UndecryptableSession()), throwsA(isA<PlatformException>()));
    expect(initialised(), isFalse, reason: 'the SDK must not claim to be ready after failing');

    final retried = await _init(_MemoryLocalStorage());

    expect(retried.isInitialized, isTrue);
    expect(retried.client.auth.currentSession, isNull);
  });

  test('with the secure store, an undecryptable saved session no longer fails initialise at all', () async {
    final vault = _MockVault();
    when(() => vault.containsKey(key: any(named: 'key'))).thenAnswer((_) async => true);
    when(() => vault.read(key: any(named: 'key')))
        .thenThrow(PlatformException(code: 'Exception encountered', details: 'Failed to unwrap key'));
    when(() => vault.delete(key: any(named: 'key'))).thenAnswer((_) async {});

    final supabase = await _init(SecureLocalStorage(SecureStore(vault)));

    expect(supabase.isInitialized, isTrue);
    expect(supabase.client.auth.currentSession, isNull, reason: 'signed out, not dead');
    verify(() => vault.delete(key: 'supabase_session')).called(1);
  });
}
