/// How the app picks light/dark (device-local preference).
enum AppearanceMode { system, light, dark }

/// Persistence for [AppearanceMode] (device-local, not synced).
abstract interface class AppearanceStore {
  AppearanceMode load();
  Future<void> save(AppearanceMode mode);
}
