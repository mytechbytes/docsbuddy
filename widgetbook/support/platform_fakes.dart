// In-memory stand-ins for the device/platform ports (logging, notifications,
// push, biometrics, local preferences) so screens run in the browser with no
// plugins and no side effects. The app's real bindings live in
// `lib/bootstrap/dependencies.dart`; this is the catalog's own composition root.
import 'dart:async';

import 'package:docsbuddy/core/logging/app_logger.dart';
import 'package:docsbuddy/core/notifications/local_alert.dart';
import 'package:docsbuddy/core/notifications/notification_service.dart';
import 'package:docsbuddy/core/push/push_messaging_service.dart';
import 'package:docsbuddy/features/onboarding/domain/onboarding_store.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:docsbuddy/features/security/domain/security_repository.dart';
import 'package:docsbuddy/features/settings/domain/appearance.dart';

/// Drops every log line: a catalog has no crash reporter to feed.
class SilentLogger implements AppLogger {
  const SilentLogger();

  @override
  void info(String message) {}

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void error(String message, {required Object error, StackTrace? stackTrace, bool fatal = false}) {}
}

/// Accepts permission and scheduling calls without touching the OS.
class NoopNotificationService implements NotificationService {
  const NoopNotificationService();

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> replaceAll(List<LocalAlert> alerts) async {}

  @override
  Future<void> showTest() async {}
}

/// Push that never starts, so the shell's registration provider is a no-op.
class NoopPushMessagingService implements PushMessagingService {
  const NoopPushMessagingService();

  @override
  Future<bool> start() async => false;

  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get tokenRefreshes => const Stream.empty();

  @override
  Stream<void> get remoteChanges => const Stream.empty();
}

/// A device with Face ID and a fingerprint reader that always succeeds, so the
/// security screens show their enabled state and the lock screen can be passed.
/// [result] lets a scenario show how the lock screen reads when it doesn't.
class DemoBiometrics implements BiometricAuthenticator {
  const DemoBiometrics({this.available = true, this.result});

  final bool available;

  /// What every prompt ends in; by default success when [available], else unavailable.
  final BiometricResult? result;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<List<BiometricKind>> kinds() async =>
      available ? const [BiometricKind.face, BiometricKind.fingerprint] : const [];

  @override
  Future<BiometricResult> authenticate(String reason) async =>
      result ?? (available ? BiometricResult.success : BiometricResult.unavailable);
}

class InMemorySecurityPrefsStore implements SecurityPrefsStore {
  InMemorySecurityPrefsStore([this.prefs = const SecurityPrefs()]);

  SecurityPrefs prefs;

  @override
  SecurityPrefs load() => prefs;

  @override
  Future<void> save(SecurityPrefs next) async => prefs = next;
}

class InMemoryAppearanceStore implements AppearanceStore {
  InMemoryAppearanceStore([this.mode = AppearanceMode.system]);

  AppearanceMode mode;

  @override
  AppearanceMode load() => mode;

  @override
  Future<void> save(AppearanceMode next) async => mode = next;
}

class InMemoryOnboardingStore implements OnboardingStore {
  InMemoryOnboardingStore({this.isComplete = false});

  @override
  bool isComplete;

  @override
  Future<void> setComplete(bool value) async => isComplete = value;
}
