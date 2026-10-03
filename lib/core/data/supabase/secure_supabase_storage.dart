import 'package:supabase_flutter/supabase_flutter.dart';

import '../secure_store.dart';

/// Persists the Supabase session in secure storage (as an opaque string) instead of SharedPreferences.
/// The SDK reads it during `Supabase.initialize` unguarded, so the store must never throw (see [SecureStore]);
/// an unreadable session reads as `null`, i.e. signed out.
class SecureLocalStorage extends LocalStorage {
  const SecureLocalStorage(this._store);

  final SecureStore _store;
  static const _sessionKey = 'supabase_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() => _store.containsKey(_sessionKey);

  @override
  Future<String?> accessToken() => _store.read(_sessionKey);

  @override
  Future<void> removePersistedSession() => _store.delete(_sessionKey);

  @override
  Future<void> persistSession(String persistSessionString) => _store.write(_sessionKey, persistSessionString);
}

/// Stores the PKCE code verifier in secure storage during the OAuth/OTP flow.
class SecurePkceStorage extends GotrueAsyncStorage {
  const SecurePkceStorage(this._store);

  final SecureStore _store;

  @override
  Future<String?> getItem({required String key}) => _store.read(key);

  @override
  Future<void> setItem({required String key, required String value}) => _store.write(key, value);

  @override
  Future<void> removeItem({required String key}) => _store.delete(key);
}
