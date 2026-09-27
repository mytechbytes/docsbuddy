import 'package:shared_preferences/shared_preferences.dart';

import '../domain/onboarding_store.dart';

/// Local-first: a device flag, so SharedPreferences is the right home for it
/// (session tokens still go to secure storage).
class SharedPrefsOnboardingStore implements OnboardingStore {
  SharedPrefsOnboardingStore(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'onboarding_complete';

  @override
  bool get isComplete => _prefs.getBool(_key) ?? false;

  @override
  Future<void> setComplete(bool value) => value ? _prefs.setBool(_key, true) : _prefs.remove(_key);
}
