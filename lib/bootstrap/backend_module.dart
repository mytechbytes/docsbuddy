import 'package:flutter_riverpod/misc.dart';

import '../core/providers/core_providers.dart';
import '../features/auth/application/auth_providers.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/catalog/application/catalog_providers.dart';
import '../features/catalog/domain/catalog_repository.dart';
import '../features/devices/application/push_registration.dart';
import '../features/devices/domain/device_repository.dart';
import '../features/documents/application/document_providers.dart';
import '../features/documents/domain/document_repository.dart';
import '../features/family/application/family_controller.dart';
import '../features/family/domain/family_repository.dart';
import '../features/profile/application/profile_providers.dart';
import '../features/profile/domain/profile.dart';
import '../features/security/application/security_providers.dart';
import '../features/security/domain/security_repository.dart';
import '../features/settings/application/settings_providers.dart';
import '../features/settings/domain/notification_prefs_repository.dart';

/// Abstract factory for everything that talks to a backend.
///
/// One implementation per backend (Supabase, the in-memory fake, and later
/// your own API). Every repository the app needs is a method here, so a new
/// backend that forgets one fails to compile. Screens, controllers and
/// domain code never know which module is active.
abstract interface class BackendModule {
  /// Shown in Settings → App → Backend.
  String get label;

  AuthRepository createAuthRepository();
  CatalogRepository createCatalogRepository();
  DocumentRepository createDocumentRepository();
  FamilyRepository createFamilyRepository();
  ProfileRepository createProfileRepository();
  SecurityRepository createSecurityRepository();
  NotificationPrefsRepository createNotificationPrefsRepository();
  DeviceRepository createDeviceRepository();
}

/// Binds [backend] to the app's repository providers. Backend-independent
/// wiring rules live here once, not in each module.
List<Override> backendOverrides(BackendModule backend) => [
      backendLabelProvider.overrideWithValue(backend.label),
      authRepositoryProvider.overrideWith((ref) => backend.createAuthRepository()),
      catalogRepositoryProvider.overrideWith((ref) {
        // Family-scoped data: rebuild when membership changes (create/join/leave).
        ref.watch(familyScopeProvider);
        return backend.createCatalogRepository();
      }),
      documentRepositoryProvider.overrideWith((ref) => backend.createDocumentRepository()),
      familyRepositoryProvider.overrideWith((ref) => backend.createFamilyRepository()),
      profileRepositoryProvider.overrideWith((ref) => backend.createProfileRepository()),
      securityRepositoryProvider.overrideWith((ref) => backend.createSecurityRepository()),
      notificationPrefsRepositoryProvider.overrideWith((ref) => backend.createNotificationPrefsRepository()),
      deviceRepositoryProvider.overrideWith((ref) => backend.createDeviceRepository()),
    ];
