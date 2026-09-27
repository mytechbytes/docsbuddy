import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/supabase/supabase_guard.dart';
import '../domain/device_repository.dart';

/// Upserts into `user_devices` (no-op when signed out).
class SupabaseDeviceRepository implements DeviceRepository {
  SupabaseDeviceRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> registerPushToken(String token, DevicePlatform platform) => guardBackend(() async {
        final userId = _client.auth.currentUser?.id;
        if (userId == null) return;
        await _client.from('user_devices').upsert(
          {'user_id': userId, 'fcm_token': token, 'platform': platform.name},
          onConflict: 'user_id,fcm_token',
        );
      });
}

/// Offline build: nothing to register with.
class FakeDeviceRepository implements DeviceRepository {
  final registered = <String>[];

  @override
  Future<void> registerPushToken(String token, DevicePlatform platform) async => registered.add(token);
}
