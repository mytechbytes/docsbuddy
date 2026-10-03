import 'dart:ui';

import 'package:docsbuddy/core/l10n/app_language.dart';
import 'package:docsbuddy/core/l10n/language_controller.dart';
import 'package:docsbuddy/core/l10n/language_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('persists the chosen language and restores it after a restart', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    ProviderContainer make() =>
        ProviderContainer.test(overrides: [languageStoreProvider.overrideWithValue(SharedPrefsLanguageStore(prefs))]);

    final first = make();
    expect(first.read(languageProvider), AppLanguage.system, reason: 'automatic until the user chooses');
    await first.read(languageProvider.notifier).set(AppLanguage.hindi);
    expect(first.read(languageProvider), AppLanguage.hindi);

    expect(make().read(languageProvider), AppLanguage.hindi);
  });

  test('a stored value from a language we no longer ship falls back to automatic', () async {
    SharedPreferences.setMockInitialValues({'app_language': 'tlh'});
    final prefs = await SharedPreferences.getInstance();
    final container =
        ProviderContainer.test(overrides: [languageStoreProvider.overrideWithValue(SharedPrefsLanguageStore(prefs))]);

    expect(container.read(languageProvider), AppLanguage.system);
  });

  test('the effective locale follows the choice, or the device while automatic', () async {
    final container = ProviderContainer.test(overrides: [
      languageStoreProvider.overrideWithValue(InMemoryLanguageStore()),
      deviceLocalesProvider.overrideWithValue(const [Locale('es', 'ES')]),
    ]);

    expect(container.read(effectiveLocaleProvider), const Locale('es'), reason: 'automatic → the device');

    await container.read(languageProvider.notifier).set(AppLanguage.arabic);
    expect(container.read(effectiveLocaleProvider), const Locale('ar'));

    await container.read(languageProvider.notifier).set(AppLanguage.system);
    expect(container.read(effectiveLocaleProvider), const Locale('es'), reason: 'back to automatic');
  });

  test('code without a BuildContext gets the strings for the language in use', () async {
    final container = ProviderContainer.test(overrides: [
      languageStoreProvider.overrideWithValue(InMemoryLanguageStore()),
      deviceLocalesProvider.overrideWithValue(const [Locale('de')]),
    ]);

    expect(container.read(appLocalizationsProvider).commonCancel, 'Cancel', reason: 'unsupported device → English');
    await container.read(languageProvider.notifier).set(AppLanguage.english);
    expect(container.read(appLocalizationsProvider).localeName, 'en');
  });
}
