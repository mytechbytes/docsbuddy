import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Default vault: iOS Keychain / Android Keystore-backed (hardware where
/// available). One instance is shared by both adapters below.
const _vault = FlutterSecureStorage();

/// Persists the Supabase session in secure storage instead of the SDK's default
/// SharedPreferences (architecture review #9). The session string is treated as
/// an opaque blob — exactly how `SharedPreferencesLocalStorage` treats it.
class SecureLocalStorage extends LocalStorage {
  const SecureLocalStorage();

  final FlutterSecureStorage _storage = _vault;
  static const _sessionKey = 'supabase_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() => _storage.containsKey(key: _sessionKey);

  @override
  Future<String?> accessToken() => _storage.read(key: _sessionKey);

  @override
  Future<void> removePersistedSession() => _storage.delete(key: _sessionKey);

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: _sessionKey, value: persistSessionString);
}

/// Stores the PKCE code verifier in secure storage during the OAuth/OTP flow.
class SecurePkceStorage extends GotrueAsyncStorage {
  const SecurePkceStorage();

  final FlutterSecureStorage _storage = _vault;

  @override
  Future<String?> getItem({required String key}) => _storage.read(key: key);

  @override
  Future<void> setItem({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> removeItem({required String key}) => _storage.delete(key: key);
}
