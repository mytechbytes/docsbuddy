import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/media/picked_media.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../documents/application/document_providers.dart';
import '../domain/phone_validation.dart';
import '../domain/profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => throw UnimplementedError('profileRepositoryProvider must be overridden'),
);

/// The signed-in user's profile and its edits. Edits throw `AppFailure`
/// (a `ValidationFailure` for a malformed phone number).
class ProfileController extends AsyncNotifier<Profile> {
  ProfileRepository get _repo => ref.read(profileRepositoryProvider);

  @override
  Future<Profile> build() async {
    final repo = ref.watch(profileRepositoryProvider);
    final profile = await repo.get();
    // Keep the server-side scheduler's timezone current (best-effort).
    unawaited(repo.syncTimezone());
    return profile;
  }

  /// [phone] is the raw field text: blank clears it, otherwise it must be a
  /// valid international number.
  Future<void> updateInfo({required String displayName, required String phone}) async {
    final normalized = validatePhoneInput(phone);
    state = AsyncData(await _repo.update(displayName: displayName, phone: normalized));
  }

  Future<void> setAvatar(PickedMedia photo) async {
    state = AsyncData(
      await _repo.setAvatar(bytes: photo.bytes, fileName: photo.name, mimeType: photo.imageMime),
    );
  }
}

final profileProvider = AsyncNotifierProvider<ProfileController, Profile>(ProfileController.new);

/// The profile screen's stats row.
typedef ProfileStats = ({int assets, int reminders, int documents});

final profileStatsProvider = FutureProvider<ProfileStats>((ref) async {
  final assets = await ref.watch(assetsProvider.future);
  final reminders = await ref.watch(upcomingRemindersProvider.future);
  final documents = await ref.watch(documentCountProvider.future);
  return (assets: assets.length, reminders: reminders.length, documents: documents);
});
