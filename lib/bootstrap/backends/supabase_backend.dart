import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/env.dart';
import '../../core/data/file_storage.dart';
import '../../core/data/supabase/supabase_file_storage.dart';
import '../../core/logging/app_logger.dart';
import '../../core/data/supabase/secure_supabase_storage.dart';
import '../../features/auth/data/auth_remote_data_source.dart';
import '../../features/auth/data/remote_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/catalog/data/catalog_remote_data_source.dart';
import '../../features/catalog/data/remote_catalog_repository.dart';
import '../../features/catalog/domain/catalog_repository.dart';
import '../../features/devices/data/device_repositories.dart';
import '../../features/devices/domain/device_repository.dart';
import '../../features/documents/data/document_remote_data_source.dart';
import '../../features/documents/data/remote_document_repository.dart';
import '../../features/documents/domain/document_repository.dart';
import '../../features/family/data/family_remote_data_source.dart';
import '../../features/family/data/remote_family_repository.dart';
import '../../features/family/domain/family_repository.dart';
import '../../features/profile/data/profile_remote_data_source.dart';
import '../../features/profile/data/remote_profile_repository.dart';
import '../../features/profile/domain/profile.dart';
import '../../features/security/data/remote_security_repository.dart';
import '../../features/security/data/security_remote_data_source.dart';
import '../../features/security/domain/security_repository.dart';
import '../../features/settings/data/notification_prefs_remote_data_source.dart';
import '../../features/settings/data/remote_notification_prefs_repository.dart';
import '../../features/settings/domain/notification_prefs_repository.dart';
import '../backend_module.dart';

/// Supabase (Postgres + GoTrue + Storage). Everything Supabase-specific —
/// SDK initialisation, session storage, the client — stays inside this file.
class SupabaseBackend implements BackendModule {
  SupabaseBackend(this._client, {required this._logger}) : _files = SupabaseFileStorage(_client);

  final SupabaseClient _client;
  final AppLogger _logger;
  final FileStorage _files;

  /// Initialises the SDK from [Env] and returns the module.
  static Future<SupabaseBackend> initialize({required AppLogger logger}) async {
    final supabase = await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
      // Review #9: persist the session + PKCE verifier in Keychain/Keystore
      // rather than the SDK's default SharedPreferences.
      authOptions: const FlutterAuthClientOptions(
        localStorage: SecureLocalStorage(),
        pkceAsyncStorage: SecurePkceStorage(),
      ),
    );
    return SupabaseBackend(supabase.client, logger: logger);
  }

  @override
  String get label => 'Supabase';

  @override
  AuthRepository createAuthRepository() =>
      RemoteAuthRepository(SupabaseAuthRemoteDataSource(_client), redirectUrl: Env.authRedirectUrl);

  @override
  CatalogRepository createCatalogRepository() =>
      RemoteCatalogRepository(SupabaseCatalogRemoteDataSource(_client), _files, logger: _logger);

  @override
  DocumentRepository createDocumentRepository() =>
      RemoteDocumentRepository(SupabaseDocumentRemoteDataSource(_client), _files);

  @override
  FamilyRepository createFamilyRepository() => RemoteFamilyRepository(SupabaseFamilyRemoteDataSource(_client));

  @override
  ProfileRepository createProfileRepository() => RemoteProfileRepository(
        SupabaseProfileRemoteDataSource(_client),
        _files,
        localTimezone: FlutterTimezone.getLocalTimezone,
        logger: _logger,
      );

  @override
  SecurityRepository createSecurityRepository() =>
      RemoteSecurityRepository(SupabaseSecurityRemoteDataSource(_client), logger: _logger);

  @override
  NotificationPrefsRepository createNotificationPrefsRepository() =>
      RemoteNotificationPrefsRepository(SupabaseNotificationPrefsRemoteDataSource(_client));

  @override
  DeviceRepository createDeviceRepository() => SupabaseDeviceRepository(_client);
}
