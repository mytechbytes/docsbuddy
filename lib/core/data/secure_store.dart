import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../logging/app_logger.dart';

/// Keychain / Keystore vault that degrades instead of throwing.
///
/// `flutter_secure_storage` can fail on devices we don't control (Auto Backup restores ciphertext whose key is
/// gone, some OEM keystores refuse keys, one plugin path never answers) and its callers are startup and sign-in.
/// So unreadable entries are dropped and read as absent, failed writes are kept in memory for the process,
/// every call is bounded by [timeout], and each failure is reported to [logger].
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
