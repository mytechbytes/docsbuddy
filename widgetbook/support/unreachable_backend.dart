// Decorators that make a healthy fake repository "slow forever" or "offline",
// so every screen can be shown in its Loading and Error states through the
// real controllers and repositories interfaces (not by faking widget state).
import 'dart:async';
import 'dart:typed_data';

import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_inputs.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_repository.dart';
import 'package:docsbuddy/features/documents/domain/document_models.dart';
import 'package:docsbuddy/features/documents/domain/document_repository.dart';
import 'package:docsbuddy/features/family/domain/family_models.dart';
import 'package:docsbuddy/features/family/domain/family_repository.dart';
import 'package:docsbuddy/features/profile/domain/profile.dart';
import 'package:docsbuddy/features/settings/domain/notification_prefs.dart';
import 'package:docsbuddy/features/settings/domain/notification_prefs_repository.dart';

/// What happens to every call that reaches the "server".
enum Outage {
  /// The request never completes: screens stay on their loading state.
  hang,

  /// The device is offline: every request fails with [NetworkFailure].
  offline,
}

/// The fate of a request that reaches the "server" during an [outage].
Future<T> _unreachable<T>(Outage outage) => switch (outage) {
      Outage.hang => Completer<T>().future,
      Outage.offline => Future<T>.error(const NetworkFailure()),
    };

class UnreachableCatalog implements CatalogRepository {
  const UnreachableCatalog(this.outage);

  final Outage outage;

  @override
  Future<List<Reminder>> upcomingReminders({int withinDays = 365}) => _unreachable(outage);

  @override
  Future<List<Asset>> assets() => _unreachable(outage);

  @override
  Future<Asset> asset(String id) => _unreachable(outage);

  @override
  Future<List<Reminder>> remindersFor(String assetId) => _unreachable(outage);

  @override
  Future<List<Location>> locations() => _unreachable(outage);

  @override
  Future<List<AssetCategory>> categories() => _unreachable(outage);

  @override
  Future<Asset> addAsset(AssetInput input) => _unreachable(outage);

  @override
  Future<Asset> updateAsset(String id, AssetInput input) => _unreachable(outage);

  @override
  Future<void> deleteAsset(String id) => _unreachable(outage);

  @override
  Future<Reminder> addReminder(String assetId, ReminderInput input) => _unreachable(outage);

  @override
  Future<Reminder> updateReminder(String id, ReminderInput input) => _unreachable(outage);

  @override
  Future<void> deleteReminder(String id) => _unreachable(outage);

  @override
  Future<void> completeReminder(String reminderId) => _unreachable(outage);

  @override
  Future<Location> createLocation(String name) => _unreachable(outage);

  @override
  Future<void> updateLocation(String id, {String? name}) => _unreachable(outage);

  @override
  Future<void> reorderLocations(List<String> orderedIds) => _unreachable(outage);

  @override
  Future<void> setLocationImage(
    String locationId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) =>
      _unreachable(outage);

  @override
  Future<Asset> setAssetImage(
    String assetId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) =>
      _unreachable(outage);

  @override
  Future<String?> resolveImageUrl(String? imageRef) => _unreachable(outage);
}

class UnreachableFamily implements FamilyRepository {
  const UnreachableFamily(this.outage);

  final Outage outage;

  @override
  String? get currentUserId => 'me';

  @override
  Future<Family?> currentFamily() => _unreachable(outage);

  @override
  Future<List<FamilyMember>> members(String familyId) => _unreachable(outage);

  @override
  Future<void> updateMemberRole({required String familyId, required String userId, required FamilyRole role}) =>
      _unreachable(outage);

  @override
  Future<void> removeMember({required String familyId, required String userId}) => _unreachable(outage);

  @override
  Future<Family> createFamily(String name) => _unreachable(outage);

  @override
  Future<FamilyInvite> createInvite({required String familyId, required FamilyRole role}) => _unreachable(outage);

  @override
  Future<Family> acceptInvite(String code) => _unreachable(outage);

  @override
  Future<void> leaveFamily(String familyId) => _unreachable(outage);
}

class UnreachableDocuments implements DocumentRepository {
  const UnreachableDocuments(this.outage);

  final Outage outage;

  @override
  Future<List<DocumentMeta>> forAsset(String assetId) => _unreachable(outage);

  @override
  Future<int> countAll() => _unreachable(outage);

  @override
  Future<DocumentMeta> upload({
    required String assetId,
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    required DocKind kind,
    String? assetDateId,
  }) =>
      _unreachable(outage);

  @override
  Future<String> viewUrl(DocumentMeta doc) => _unreachable(outage);

  @override
  Future<Uint8List> download(DocumentMeta doc) => _unreachable(outage);

  @override
  Future<void> delete(DocumentMeta doc) => _unreachable(outage);
}

class UnreachableProfile implements ProfileRepository {
  const UnreachableProfile(this.outage);

  final Outage outage;

  @override
  Future<Profile> get() => _unreachable(outage);

  @override
  Future<Profile> update({String? displayName, String? phone}) => _unreachable(outage);

  @override
  Future<Profile> setAvatar({required Uint8List bytes, required String fileName, required String mimeType}) =>
      _unreachable(outage);

  /// Fire-and-forget in the controller (`unawaited`), so it must never fail.
  @override
  Future<void> syncTimezone() async {}
}

class UnreachableNotificationPrefs implements NotificationPrefsRepository {
  const UnreachableNotificationPrefs(this.outage);

  final Outage outage;

  @override
  Future<NotificationPrefs> get() => _unreachable(outage);

  @override
  Future<NotificationPrefs> update(NotificationPrefs prefs) => _unreachable(outage);
}
