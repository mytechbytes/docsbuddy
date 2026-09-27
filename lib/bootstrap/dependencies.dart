import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/env.dart';
import '../core/data/file_storage.dart';
import '../core/notifications/notification_service.dart';
import '../core/providers/core_providers.dart';
import '../core/push/push_messaging_service.dart';
import '../features/auth/application/auth_providers.dart';
import '../features/auth/data/auth_remote_data_source.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/auth/data/fake_auth_repository.dart';
import '../features/auth/data/remote_auth_repository.dart';
import '../features/catalog/application/catalog_providers.dart';
import '../features/catalog/data/catalog_remote_data_source.dart';
import '../features/catalog/data/fake_catalog_repository.dart';
import '../features/catalog/data/remote_catalog_repository.dart';
import '../features/catalog/domain/catalog_repository.dart';
import '../features/devices/application/push_registration.dart';
import '../features/devices/data/device_repositories.dart';
import '../features/devices/domain/device_repository.dart';
import '../features/documents/application/document_providers.dart';
import '../features/documents/data/document_remote_data_source.dart';
import '../features/documents/data/fake_document_repository.dart';
import '../features/documents/data/remote_document_repository.dart';
import '../features/documents/domain/document_repository.dart';
import '../features/family/application/family_controller.dart';
import '../features/family/data/fake_family_repository.dart';
import '../features/family/data/family_remote_data_source.dart';
import '../features/family/data/remote_family_repository.dart';
import '../features/family/domain/family_repository.dart';
import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/data/shared_prefs_onboarding_store.dart';
import '../features/profile/application/profile_providers.dart';
import '../features/profile/data/fake_profile_repository.dart';
import '../features/profile/data/profile_remote_data_source.dart';
import '../features/profile/data/remote_profile_repository.dart';
import '../features/profile/domain/profile.dart';
import '../features/security/application/security_providers.dart';
import '../features/security/data/device_security.dart';
import '../features/security/data/fake_security_repository.dart';
import '../features/security/data/remote_security_repository.dart';
import '../features/security/data/security_remote_data_source.dart';
import '../features/security/domain/security_repository.dart';
import '../features/settings/application/settings_providers.dart';
import '../features/settings/data/fake_notification_prefs_repository.dart';
import '../features/settings/data/notification_prefs_remote_data_source.dart';
import '../features/settings/data/remote_notification_prefs_repository.dart';
import '../features/settings/domain/notification_prefs_repository.dart';

/// The composition root: the only place that picks concrete implementations.
/// Every repository/service provider in the app throws until bound here.

/// Device and platform services, shared by both backends.
List<Override> platformOverrides(SharedPreferences prefs) => [
      sharedPreferencesProvider.overrideWithValue(prefs),
      onboardingStoreProvider.overrideWith((ref) => SharedPrefsOnboardingStore(ref.watch(sharedPreferencesProvider))),
      securityPrefsStoreProvider
          .overrideWith((ref) => SharedPrefsSecurityPrefsStore(ref.watch(sharedPreferencesProvider))),
      biometricAuthenticatorProvider.overrideWith((ref) => LocalAuthBiometricAuthenticator()),
      notificationServiceProvider.overrideWith((ref) => LocalNotificationService(FlutterLocalNotificationsPlugin())),
      pushMessagingServiceProvider.overrideWith((ref) => FirebasePushMessagingService()),
    ];

/// Supabase-backed repositories (when SUPABASE_URL/ANON_KEY are provided).
List<Override> supabaseBackendOverrides(SupabaseClient client) {
  final files = SupabaseFileStorage(client);
  return [
    backendLabelProvider.overrideWithValue('Supabase'),
    authRepositoryProvider.overrideWith(
      (ref) => RemoteAuthRepository(SupabaseAuthRemoteDataSource(client), redirectUrl: Env.authRedirectUrl),
    ),
    catalogRepositoryProvider.overrideWith((ref) {
      // Rebuild (dropping the cached family id) when membership changes.
      ref.watch(familyScopeProvider);
      return RemoteCatalogRepository(SupabaseCatalogRemoteDataSource(client), files);
    }),
    documentRepositoryProvider
        .overrideWith((ref) => RemoteDocumentRepository(SupabaseDocumentRemoteDataSource(client), files)),
    familyRepositoryProvider.overrideWith((ref) => RemoteFamilyRepository(SupabaseFamilyRemoteDataSource(client))),
    profileRepositoryProvider.overrideWith((ref) => RemoteProfileRepository(
          SupabaseProfileRemoteDataSource(client),
          files,
          localTimezone: FlutterTimezone.getLocalTimezone,
        )),
    securityRepositoryProvider
        .overrideWith((ref) => RemoteSecurityRepository(SupabaseSecurityRemoteDataSource(client))),
    notificationPrefsRepositoryProvider.overrideWith(
      (ref) => RemoteNotificationPrefsRepository(SupabaseNotificationPrefsRemoteDataSource(client)),
    ),
    deviceRepositoryProvider.overrideWith((ref) => SupabaseDeviceRepository(client)),
  ];
}

/// In-memory repositories so every screen runs without a backend (local dev,
/// tests, the screenshot harness). Pass an instance to swap one fake.
List<Override> fakeBackendOverrides({
  AuthRepository? auth,
  CatalogRepository? catalog,
  DocumentRepository? documents,
  FamilyRepository? family,
  ProfileRepository? profile,
  SecurityRepository? security,
  NotificationPrefsRepository? notificationPrefs,
  DeviceRepository? devices,
}) =>
    [
      authRepositoryProvider.overrideWith((ref) => auth ?? FakeAuthRepository()),
      catalogRepositoryProvider.overrideWith((ref) => catalog ?? FakeCatalogRepository()),
      documentRepositoryProvider.overrideWith((ref) => documents ?? FakeDocumentRepository()),
      familyRepositoryProvider.overrideWith((ref) => family ?? FakeFamilyRepository()),
      profileRepositoryProvider.overrideWith((ref) => profile ?? FakeProfileRepository()),
      securityRepositoryProvider.overrideWith((ref) => security ?? FakeSecurityRepository()),
      notificationPrefsRepositoryProvider
          .overrideWith((ref) => notificationPrefs ?? FakeNotificationPrefsRepository()),
      deviceRepositoryProvider.overrideWith((ref) => devices ?? FakeDeviceRepository()),
    ];
