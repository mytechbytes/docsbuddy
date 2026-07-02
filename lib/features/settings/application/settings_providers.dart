import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/notification_prefs_repository.dart';

/// Notification prefs: Supabase-backed when configured, else in-memory.
final notificationPrefsRepositoryProvider = Provider<NotificationPrefsRepository>((ref) {
  if (Env.hasSupabase) {
    return SupabaseNotificationPrefsRepository(Supabase.instance.client);
  }
  return FakeNotificationPrefsRepository();
});

final notificationPrefsProvider = FutureProvider<NotificationPrefs>((ref) {
  return ref.watch(notificationPrefsRepositoryProvider).get();
});
