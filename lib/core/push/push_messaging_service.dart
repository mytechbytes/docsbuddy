import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Background isolate handler — must be a top-level function. In the local-first
/// model these are silent data pushes; the real sync happens when the app next
/// opens, so there's nothing heavy to do here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

/// Transport-only wrapper over FCM **silent data pushes** (docs/push-setup.md).
/// It knows nothing about the backend or features: callers register the
/// token themselves and react to [remoteChanges].
abstract interface class PushMessagingService {
  /// Initialises Firebase and asks for permission. Returns false when push
  /// isn't available here (no Firebase config, desktop, tests).
  Future<bool> start();

  Future<String?> token();

  Stream<String> get tokenRefreshes;

  /// Fires when another device changed shared data (foreground data push).
  Stream<void> get remoteChanges;
}

class FirebasePushMessagingService implements PushMessagingService {
  bool _started = false;

  // Broadcast so listeners can subscribe before [start] runs.
  final _changes = StreamController<void>.broadcast();
  final _tokens = StreamController<String>.broadcast();

  @override
  Future<bool> start() async {
    if (_started) return true;
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await FirebaseMessaging.instance.requestPermission();
      FirebaseMessaging.onMessage.listen((_) => _changes.add(null));
      FirebaseMessaging.instance.onTokenRefresh.listen(_tokens.add);
      return _started = true;
    } catch (_) {
      return false; // Firebase not configured on this platform
    }
  }

  @override
  Future<String?> token() async {
    if (!_started) return null;
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<String> get tokenRefreshes => _tokens.stream;

  @override
  Stream<void> get remoteChanges => _changes.stream;
}

/// Bound at the composition root (`bootstrap/dependencies.dart`).
final pushMessagingServiceProvider = Provider<PushMessagingService>(
  (ref) => throw UnimplementedError('pushMessagingServiceProvider must be overridden'),
);
