import 'package:shared_preferences/shared_preferences.dart';

import 'app_language.dart';

/// Persistence for the chosen [AppLanguage] (device-local, not synced).
abstract interface class LanguageStore {
  AppLanguage load();
  Future<void> save(AppLanguage language);
}

class SharedPrefsLanguageStore implements LanguageStore {
  SharedPrefsLanguageStore(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'app_language';

  @override
  AppLanguage load() => AppLanguage.fromCode(_prefs.getString(_key));

  @override
  Future<void> save(AppLanguage language) => _prefs.setString(_key, language.code);
}

/// Keeps the choice in memory — for tests, the widget catalog and demos.
class InMemoryLanguageStore implements LanguageStore {
  InMemoryLanguageStore([this.language = AppLanguage.system]);

  AppLanguage language;

  @override
  AppLanguage load() => language;

  @override
  Future<void> save(AppLanguage language) async => this.language = language;
}
