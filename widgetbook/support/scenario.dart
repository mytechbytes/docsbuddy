// The "world" a use case runs in: which backend state the real controllers and
// repositories see. Screens are shown in the same four states a user meets.
import 'package:docsbuddy/core/l10n/language_controller.dart';
import 'package:docsbuddy/core/l10n/language_store.dart';
import 'package:docsbuddy/bootstrap/backend_module.dart';
import 'package:docsbuddy/bootstrap/backends/demo_backend.dart';
import 'package:docsbuddy/bootstrap/backends/fake_backend.dart';
import 'package:docsbuddy/core/logging/app_logger.dart';
import 'package:docsbuddy/core/notifications/notification_service.dart';
import 'package:docsbuddy/core/push/push_messaging_service.dart';
import 'package:docsbuddy/features/auth/domain/auth_repository.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_repository.dart';
import 'package:docsbuddy/features/devices/domain/device_repository.dart';
import 'package:docsbuddy/features/documents/domain/document_repository.dart';
import 'package:docsbuddy/features/family/domain/family_repository.dart';
import 'package:docsbuddy/features/onboarding/application/onboarding_controller.dart';
import 'package:docsbuddy/features/profile/domain/profile.dart';
import 'package:docsbuddy/features/security/application/security_providers.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:docsbuddy/features/security/domain/security_repository.dart';
import 'package:docsbuddy/features/settings/application/appearance_controller.dart';
import 'package:docsbuddy/features/settings/domain/notification_prefs_repository.dart';
import 'package:flutter_riverpod/misc.dart';

import 'platform_fakes.dart';
import 'unreachable_backend.dart';

/// The backend state a screen is shown in.
enum Scenario {
  /// A lived-in account: rooms, assets, reminders, documents and a family.
  populated('Populated'),

  /// A brand-new account: nothing added yet.
  empty('Empty'),

  /// Requests never finish, so the loading state stays on screen.
  loading('Loading'),

  /// The device is offline: every request fails.
  error('Error');

  const Scenario(this.label);

  final String label;
}

/// Knobs for the parts of a scenario that aren't about data.
class WorldOptions {
  const WorldOptions({this.totpEnabled = false, this.appLock = false, this.unlockResult});

  /// Two-step verification already set up on the account.
  final bool totpEnabled;

  /// App lock switched on in the device-local security preferences.
  final bool appLock;

  /// What the fingerprint / Face ID prompt ends in (default: success). Lets the
  /// lock screen be shown after a failed attempt.
  final BiometricResult? unlockResult;
}

/// The seeded records, looked up by name, so screens that take an id (or an
/// object to edit) can be pointed at real data without hard-coding the ids the
/// fake repository generates.
class DemoRefs {
  const DemoRefs({this.assets = const {}, this.rooms = const {}, this.reminders = const {}});

  final Map<String, Asset> assets;
  final Map<String, Location> rooms;

  /// Keyed by `'<asset name>|<reminder label>'`.
  final Map<String, Reminder> reminders;

  /// An id that resolves to nothing: the "not found" path.
  static const missing = 'missing';

  String assetId(String name) => assets[name]?.id ?? missing;

  Asset? asset(String name) => assets[name];

  String roomId(String name) => rooms[name]?.id ?? missing;

  Reminder? reminder(String assetName, String label) => reminders['$assetName|$label'];
}

class World {
  const World({required this.overrides, required this.refs});

  final List<Override> overrides;
  final DemoRefs refs;
}

Future<World> buildWorld(Scenario scenario, {WorldOptions options = const WorldOptions()}) async {
  final demo = await createDemoBackend(latency: Duration.zero);

  if (options.totpEnabled) {
    final security = demo.createSecurityRepository();
    final enrollment = await security.enrollTotp();
    await security.verifyTotp(factorId: enrollment.factorId, code: '123456');
  }

  final BackendModule backend = switch (scenario) {
    Scenario.populated => demo,
    Scenario.empty => FakeBackend(
        auth: demo.createAuthRepository(),
        catalog: FakeCatalogRepository(latency: Duration.zero, seed: false),
        security: demo.createSecurityRepository(),
      ),
    Scenario.loading => _UnreachableBackend(demo, Outage.hang),
    Scenario.error => _UnreachableBackend(demo, Outage.offline),
  };

  final refs = scenario == Scenario.populated ? await _refsOf(demo.createCatalogRepository()) : const DemoRefs();

  return World(
    overrides: [
      ..._platform(SecurityPrefs(appLock: options.appLock), unlockResult: options.unlockResult),
      ...backendOverrides(backend),
    ],
    refs: refs,
  );
}

Future<DemoRefs> _refsOf(CatalogRepository catalog) async {
  final assets = await catalog.assets();
  final rooms = await catalog.locations();
  final reminders = await catalog.upcomingReminders();
  return DemoRefs(
    assets: {for (final a in assets) a.name: a},
    rooms: {for (final r in rooms) r.name: r},
    reminders: {for (final r in reminders) '${r.assetName}|${r.label}': r},
  );
}

/// Every device/platform port, bound to something harmless.
List<Override> _platform(SecurityPrefs securityPrefs, {BiometricResult? unlockResult}) => [
      appLoggerProvider.overrideWithValue(const SilentLogger()),
      appearanceStoreProvider.overrideWithValue(InMemoryAppearanceStore()),
      languageStoreProvider.overrideWithValue(InMemoryLanguageStore()),
      onboardingStoreProvider.overrideWithValue(InMemoryOnboardingStore()),
      notificationServiceProvider.overrideWithValue(const NoopNotificationService()),
      pushMessagingServiceProvider.overrideWithValue(const NoopPushMessagingService()),
      biometricAuthenticatorProvider.overrideWithValue(DemoBiometrics(result: unlockResult)),
      securityPrefsStoreProvider.overrideWithValue(InMemorySecurityPrefsStore(securityPrefs)),
    ];

/// The healthy [base] backend with its server-backed repositories replaced by
/// ones that hang or fail. Auth, security and devices stay as they were: the
/// user is still signed in, only the data is unreachable.
class _UnreachableBackend implements BackendModule {
  _UnreachableBackend(this._base, this._outage);

  final BackendModule _base;
  final Outage _outage;

  @override
  String get label => 'Local (fake)';

  @override
  AuthRepository createAuthRepository() => _base.createAuthRepository();

  @override
  CatalogRepository createCatalogRepository() => UnreachableCatalog(_outage);

  @override
  DocumentRepository createDocumentRepository() => UnreachableDocuments(_outage);

  @override
  FamilyRepository createFamilyRepository() => UnreachableFamily(_outage);

  @override
  ProfileRepository createProfileRepository() => UnreachableProfile(_outage);

  @override
  SecurityRepository createSecurityRepository() => _base.createSecurityRepository();

  @override
  NotificationPrefsRepository createNotificationPrefsRepository() => UnreachableNotificationPrefs(_outage);

  @override
  DeviceRepository createDeviceRepository() => _base.createDeviceRepository();
}
