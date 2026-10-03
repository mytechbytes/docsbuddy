import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../logging/app_logger.dart';

/// A Keychain / Keystore vault that can't take the app down with it.
///
/// `flutter_secure_storage` fails in ways the app has no control over: an Auto
/// Backup restore brings back ciphertext written under another device's key,
/// some OEM keystores refuse to unwrap or generate keys, and one plugin code
/// path neither succeeds nor fails. Its callers are the start-up and sign-in
/// paths, where an exception means a dead app, so every operation degrades
/// instead of throwing:
///
///  * an entry that can't be read is dropped and reads as absent (the user
///    signs in again — they would have to anyway);
///  * a write that fails is kept in memory for this process, so the flow in
///    flight (e.g. an OAuth round-trip) still completes;
///  * every call is bounded by [timeout].
///
/// Each failure is reported to [logger] so a device-specific problem shows up
/// in Crashlytics instead of as a silent dead end.
class SecureStore {
  SecureStore(this._storage, {this._logger, this.timeout = const Duration(seconds: 5)});

  final FlutterSecureStorage _storage;
  final AppLogger? _logger;
  final Duration timeout;

  /// Values the keystore wouldn't take; lives only as long as the process.
  final _memory = <String, String>{};

  Future<String?> read(String key) async {
    final held = _memory[key];
    if (held != null) return held;
    try {
      return await _bounded(() => _storage.read(key: key));
    } catch (error, stack) {
      _report('read', error, stack);
      await _drop(key);
      return null;
    }
  }

  Future<bool> containsKey(String key) async {
    if (_memory.containsKey(key)) return true;
    try {
      return await _bounded(() => _storage.containsKey(key: key));
    } catch (error, stack) {
      _report('containsKey', error, stack);
      return false;
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _bounded(() => _storage.write(key: key, value: value));
      _memory.remove(key);
    } catch (error, stack) {
      _report('write', error, stack);
      _memory[key] = value;
    }
  }

  Future<void> delete(String key) async {
    _memory.remove(key);
    await _drop(key);
  }

  Future<void> _drop(String key) async {
    try {
      await _bounded(() => _storage.delete(key: key));
    } catch (error, stack) {
      _report('delete', error, stack);
    }
  }

  Future<T> _bounded<T>(Future<T> Function() call) => call().timeout(timeout);

  void _report(String operation, Object error, StackTrace stack) =>
      _logger?.warning('Secure storage $operation failed', error: error, stackTrace: stack);
}
