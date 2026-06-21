import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Injected in `main()` after `SharedPreferences.getInstance()`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override in ProviderScope'),
);

/// Tracks whether first-launch onboarding has been completed on this device.
///
/// Local-first: this is a device flag, not synced state, so SharedPreferences
/// is the right home for it (refresh tokens still go to secure storage).
class OnboardingController extends Notifier<bool> {
  static const _key = 'onboarding_complete';

  @override
  bool build() {
    return ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;
  }

  /// Marks onboarding finished and persists it.
  Future<void> complete() async {
    await ref.read(sharedPreferencesProvider).setBool(_key, true);
    state = true;
  }

  /// Clears the flag so the walkthrough shows again (used for testing/replay).
  Future<void> reset() async {
    await ref.read(sharedPreferencesProvider).remove(_key);
    state = false;
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, bool>(OnboardingController.new);
