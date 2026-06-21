import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';
import '../../features/catalog/application/catalog_providers.dart';

/// Background isolate handler — must be a top-level function. In the local-first
/// model these are silent data pushes; the real sync happens when the app next
/// opens, so there's nothing heavy to do here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

/// FCM is used only for **silent data pushes** that wake the app to refresh when
/// another family member changes something (see docs/push-setup.md). All calls
/// are guarded so platforms without Firebase config (iOS without a plist,
/// desktop, tests) degrade to a no-op instead of crashing.
class FcmService {
  FcmService(this._ref);
  final Ref _ref;
  bool _started = false;

  Future<void> init() async {
    if (_started) return;
    try {
      await Firebase.initializeApp();
      _started = true;

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await FirebaseMessaging.instance.requestPermission();

      await registerToken();
      FirebaseMessaging.instance.onTokenRefresh.listen((_) => registerToken());

      // Foreground data push → refresh the catalog (a family member changed something).
      FirebaseMessaging.onMessage.listen((_) {
        _ref.invalidate(upcomingRemindersProvider);
        _ref.invalidate(assetsProvider);
      });
    } catch (_) {/* Firebase not configured on this platform */}
  }

  /// Upserts this device's token into Supabase `user_devices` (when signed in).
  Future<void> registerToken() async {
    try {
      if (!Env.hasSupabase) return;
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) return;
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await client.from('user_devices').upsert(
        {
          'user_id': user.id,
          'fcm_token': token,
          'platform': defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
        },
        onConflict: 'user_id,fcm_token',
      );
    } catch (_) {/* no-op */}
  }
}

final fcmServiceProvider = Provider<FcmService>((ref) => FcmService(ref));
