import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/push/push_messaging_service.dart';
import '../domain/device_repository.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => throw UnimplementedError('deviceRepositoryProvider must be overridden'),
);

/// Starts push once signed in and keeps this device's token registered.
/// Watch it from the signed-in shell to activate. Best-effort throughout —
/// push is an optimisation, never a hard dependency.
final pushRegistrationProvider = FutureProvider<void>((ref) async {
  final push = ref.watch(pushMessagingServiceProvider);
  final devices = ref.watch(deviceRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  final platform = defaultTargetPlatform == TargetPlatform.iOS ? DevicePlatform.ios : DevicePlatform.android;

  Future<void> register(String? token) async {
    if (token == null) return;
    try {
      await devices.registerPushToken(token, platform);
    } catch (e, st) {
      // Retried on the next token refresh / launch.
      logger.warning('Push token registration failed', error: e, stackTrace: st);
    }
  }

  if (!await push.start()) return;
  await register(await push.token());
  final sub = push.tokenRefreshes.listen(register);
  ref.onDispose(sub.cancel);
});
