enum DevicePlatform { ios, android }

/// Registers this device's push token so the backend can send silent
/// "something changed" pushes (docs/push-setup.md). Throws `AppFailure`.
abstract interface class DeviceRepository {
  Future<void> registerPushToken(String token, DevicePlatform platform);
}
