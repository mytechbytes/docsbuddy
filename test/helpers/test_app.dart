import 'dart:async';

import 'package:docsbuddy/bootstrap/backends/fake_backend.dart';
import 'package:docsbuddy/bootstrap/dependencies.dart';
import 'package:docsbuddy/core/notifications/local_alert.dart';
import 'package:docsbuddy/core/notifications/notification_service.dart';
import 'package:docsbuddy/core/providers/core_providers.dart';
import 'package:docsbuddy/core/push/push_messaging_service.dart';
import 'package:docsbuddy/features/auth/domain/auth_repository.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_repository.dart';
import 'package:docsbuddy/features/documents/domain/document_repository.dart';
import 'package:docsbuddy/features/family/domain/family_repository.dart';
import 'package:docsbuddy/features/onboarding/application/onboarding_controller.dart';
import 'package:docsbuddy/features/onboarding/domain/onboarding_store.dart';
import 'package:docsbuddy/features/profile/domain/profile.dart';
import 'package:docsbuddy/features/security/application/security_providers.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:docsbuddy/features/security/domain/security_repository.dart';
import 'package:docsbuddy/features/settings/domain/notification_prefs_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

// ── In-memory platform fakes ──

class RecordingNotificationService implements NotificationService {
  final scheduled = <List<LocalAlert>>[];
  bool permission = true;
  int tests = 0;

  @override
  Future<bool> requestPermission() async => permission;

  @override
  Future<void> replaceAll(List<LocalAlert> alerts) async => scheduled.add(alerts);

  @override
  Future<void> showTest() async => tests++;
}

class FakePushMessagingService implements PushMessagingService {
  final changes = StreamController<void>.broadcast();
  final tokens = StreamController<String>.broadcast();
  bool available = false;
  String? currentToken;

  @override
  Future<bool> start() async => available;

  @override
  Future<String?> token() async => currentToken;

  @override
  Stream<String> get tokenRefreshes => tokens.stream;

  @override
  Stream<void> get remoteChanges => changes.stream;
}

class FakeBiometrics implements BiometricAuthenticator {
  bool available = false;
  bool succeeds = true;
  List<BiometricKind> availableKinds = const [];
  int prompts = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<List<BiometricKind>> kinds() async => availableKinds;

  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return succeeds;
  }
}

class InMemorySecurityPrefsStore implements SecurityPrefsStore {
  InMemorySecurityPrefsStore([this.prefs = const SecurityPrefs()]);
  SecurityPrefs prefs;

  @override
  SecurityPrefs load() => prefs;

  @override
  Future<void> save(SecurityPrefs next) async => prefs = next;
}

class InMemoryOnboardingStore implements OnboardingStore {
  InMemoryOnboardingStore({this.isComplete = false});

  @override
  bool isComplete;

  @override
  Future<void> setComplete(bool value) async => isComplete = value;
}

/// Every binding the app needs, backed by fakes. Pass an instance to swap one.
List<Override> testOverrides({
  AuthRepository? auth,
  CatalogRepository? catalog,
  DocumentRepository? documents,
  FamilyRepository? family,
  ProfileRepository? profile,
  SecurityRepository? security,
  NotificationPrefsRepository? notificationPrefs,
  OnboardingStore? onboarding,
  NotificationService? notifications,
  PushMessagingService? push,
  BiometricAuthenticator? biometrics,
  SecurityPrefsStore? securityPrefs,
  DateTime Function()? clock,
}) =>
    [
      ...backendOverrides(FakeBackend(
        auth: auth,
        catalog: catalog,
        documents: documents,
        family: family,
        profile: profile,
        security: security,
        notificationPrefs: notificationPrefs,
      )),
      onboardingStoreProvider.overrideWithValue(onboarding ?? InMemoryOnboardingStore()),
      notificationServiceProvider.overrideWithValue(notifications ?? RecordingNotificationService()),
      pushMessagingServiceProvider.overrideWithValue(push ?? FakePushMessagingService()),
      biometricAuthenticatorProvider.overrideWithValue(biometrics ?? FakeBiometrics()),
      securityPrefsStoreProvider.overrideWithValue(securityPrefs ?? InMemorySecurityPrefsStore()),
      if (clock != null) clockProvider.overrideWithValue(clock),
    ];

/// No automatic retries in tests — failures should surface immediately.
Duration? noRetry(int _, Object _) => null;

/// A container for application-layer tests (no widget tree).
ProviderContainer makeContainer({List<Override> overrides = const []}) =>
    ProviderContainer.test(overrides: overrides.isEmpty ? testOverrides() : overrides, retry: noRetry);

/// Wraps [child] in a ProviderScope with the fake bindings and a MaterialApp.
Widget testApp(Widget child, {List<Override>? overrides}) => ProviderScope(
      overrides: overrides ?? testOverrides(),
      retry: noRetry,
      child: MaterialApp(home: child),
    );

/// Elapses the fakes' simulated latency (timers, not frames) and settles.
Future<void> settle(WidgetTester tester, [Duration latency = const Duration(seconds: 2)]) async {
  await tester.pump();
  await tester.pump(latency);
  await tester.pumpAndSettle();
}
