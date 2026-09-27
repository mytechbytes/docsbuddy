import '../../features/auth/data/fake_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/catalog/data/fake_catalog_repository.dart';
import '../../features/catalog/domain/catalog_repository.dart';
import '../../features/devices/data/device_repositories.dart';
import '../../features/devices/domain/device_repository.dart';
import '../../features/documents/data/fake_document_repository.dart';
import '../../features/documents/domain/document_repository.dart';
import '../../features/family/data/fake_family_repository.dart';
import '../../features/family/domain/family_repository.dart';
import '../../features/profile/data/fake_profile_repository.dart';
import '../../features/profile/domain/profile.dart';
import '../../features/security/data/fake_security_repository.dart';
import '../../features/security/domain/security_repository.dart';
import '../../features/settings/data/fake_notification_prefs_repository.dart';
import '../../features/settings/domain/notification_prefs_repository.dart';
import '../backend_module.dart';

/// In-memory backend so every screen runs without a server (local dev, tests,
/// the screenshot harness). Each repository is created once and reused, so
/// its in-memory data survives provider rebuilds. Pass an instance to swap
/// one fake (tests).
class FakeBackend implements BackendModule {
  FakeBackend({
    AuthRepository? auth,
    CatalogRepository? catalog,
    DocumentRepository? documents,
    FamilyRepository? family,
    ProfileRepository? profile,
    SecurityRepository? security,
    NotificationPrefsRepository? notificationPrefs,
    DeviceRepository? devices,
  })  : _auth = auth ?? FakeAuthRepository(),
        _catalog = catalog ?? FakeCatalogRepository(),
        _documents = documents ?? FakeDocumentRepository(),
        _family = family ?? FakeFamilyRepository(),
        _profile = profile ?? FakeProfileRepository(),
        _security = security ?? FakeSecurityRepository(),
        _notificationPrefs = notificationPrefs ?? FakeNotificationPrefsRepository(),
        _devices = devices ?? FakeDeviceRepository();

  final AuthRepository _auth;
  final CatalogRepository _catalog;
  final DocumentRepository _documents;
  final FamilyRepository _family;
  final ProfileRepository _profile;
  final SecurityRepository _security;
  final NotificationPrefsRepository _notificationPrefs;
  final DeviceRepository _devices;

  @override
  String get label => 'Local (fake)';

  @override
  AuthRepository createAuthRepository() => _auth;

  @override
  CatalogRepository createCatalogRepository() => _catalog;

  @override
  DocumentRepository createDocumentRepository() => _documents;

  @override
  FamilyRepository createFamilyRepository() => _family;

  @override
  ProfileRepository createProfileRepository() => _profile;

  @override
  SecurityRepository createSecurityRepository() => _security;

  @override
  NotificationPrefsRepository createNotificationPrefsRepository() => _notificationPrefs;

  @override
  DeviceRepository createDeviceRepository() => _devices;
}
