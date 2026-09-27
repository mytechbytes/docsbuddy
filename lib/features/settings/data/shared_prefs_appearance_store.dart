import 'package:shared_preferences/shared_preferences.dart';

import '../domain/appearance.dart';

class SharedPrefsAppearanceStore implements AppearanceStore {
  SharedPrefsAppearanceStore(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'appearance_mode';

  @override
  AppearanceMode load() => AppearanceMode.values.asNameMap()[_prefs.getString(_key)] ?? AppearanceMode.system;

  @override
  Future<void> save(AppearanceMode mode) => _prefs.setString(_key, mode.name);
}
