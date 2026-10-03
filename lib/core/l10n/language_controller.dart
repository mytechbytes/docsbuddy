import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'app_language.dart';
import 'language_store.dart';

final languageStoreProvider = Provider<LanguageStore>(
  (ref) => throw UnimplementedError('languageStoreProvider must be overridden'),
);

class LanguageController extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => ref.watch(languageStoreProvider).load();

  Future<void> set(AppLanguage language) async {
    await ref.read(languageStoreProvider).save(language);
    state = language;
  }
}

final languageProvider = NotifierProvider<LanguageController, AppLanguage>(LanguageController.new);

/// The device's preferred locales; a provider so tests can fake any device language.
final deviceLocalesProvider = Provider<List<Locale>>((ref) => PlatformDispatcher.instance.locales);

/// The locale the app is showing in right now — the picked language, or the
/// best match for the device when it is automatic.
final effectiveLocaleProvider = Provider<Locale>(
  (ref) => resolveLocale(ref.watch(languageProvider), ref.watch(deviceLocalesProvider)),
);

/// The translations for [effectiveLocaleProvider], for code that has no
/// `BuildContext` (local notifications are composed outside the widget tree).
final appLocalizationsProvider = Provider<AppLocalizations>(
  (ref) => lookupAppLocalizations(ref.watch(effectiveLocaleProvider)),
);
