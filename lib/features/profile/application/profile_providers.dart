import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../documents/application/document_providers.dart';
import '../data/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  if (Env.hasSupabase) {
    return SupabaseProfileRepository(Supabase.instance.client);
  }
  return FakeProfileRepository();
});

final profileProvider = FutureProvider<Profile>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  final profile = await repo.get();
  // Keep the server-side scheduler's timezone current (best-effort).
  unawaited(repo.syncTimezone());
  return profile;
});

/// The profile screen's stats row: (assets, reminders, documents).
final profileStatsProvider = FutureProvider<(int, int, int)>((ref) async {
  final assets = await ref.watch(assetsProvider.future);
  final reminders = await ref.watch(upcomingRemindersProvider.future);
  final documents = await ref.watch(documentRepositoryProvider).countAll();
  return (assets.length, reminders.length, documents);
});
