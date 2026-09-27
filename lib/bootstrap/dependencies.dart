import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/env.dart';
import '../core/logging/app_logger.dart';
import '../core/notifications/notification_service.dart';
import '../core/providers/core_providers.dart';
import '../core/push/push_messaging_service.dart';
import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/data/shared_prefs_onboarding_store.dart';
import '../features/security/application/security_providers.dart';
import '../features/security/data/device_security.dart';
import 'backend_module.dart';
import 'backends/fake_backend.dart';
import 'backends/supabase_backend.dart';

export 'backend_module.dart' show BackendModule, backendOverrides;

/// The composition root: the only place that picks concrete implementations.
/// Every repository/service provider in the app throws until bound here.

/// Builds the backend selected by `--dart-define=BACKEND=...` (see [Env]).
/// Adding a backend = one enum value + one case here + its module.
Future<BackendModule> createBackend(BackendKind kind, {required AppLogger logger}) async => switch (kind) {
      BackendKind.supabase => await SupabaseBackend.initialize(logger: logger),
      BackendKind.fake => FakeBackend(),
    };

/// Device and platform services — identical whichever backend is active.
List<Override> platformOverrides(
  SharedPreferences prefs, {
  required AppLogger logger,
  required bool firebaseReady,
}) =>
    [
      appLoggerProvider.overrideWithValue(logger),
      sharedPreferencesProvider.overrideWithValue(prefs),
      onboardingStoreProvider.overrideWith((ref) => SharedPrefsOnboardingStore(ref.watch(sharedPreferencesProvider))),
      securityPrefsStoreProvider
          .overrideWith((ref) => SharedPrefsSecurityPrefsStore(ref.watch(sharedPreferencesProvider))),
      biometricAuthenticatorProvider.overrideWith((ref) => LocalAuthBiometricAuthenticator()),
      notificationServiceProvider
          .overrideWith((ref) => LocalNotificationService(FlutterLocalNotificationsPlugin(), logger: logger)),
      pushMessagingServiceProvider
          .overrideWith((ref) => FirebasePushMessagingService(firebaseReady: firebaseReady, logger: logger)),
    ];
