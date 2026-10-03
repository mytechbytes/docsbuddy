import 'dart:ui';

/// The languages the app is translated into, plus "automatic" — the one place
/// that lists them. Adding a language means adding a value here and an
/// `app_<code>.arb` (see `docs/localization.md`); a test keeps this list and
/// the generated `AppLocalizations.supportedLocales` in step.
enum AppLanguage {
  /// Follow the device language; fall back to English when it isn't supported.
  system('system', null, false),
  english('en', 'English', false),

  /// Mandarin Chinese, Simplified script. Devices set to Traditional Chinese
  /// resolve here too (the closest supported language).
  mandarin('zh', '中文 (简体)', false),
  hindi('hi', 'हिन्दी', false),
  spanish('es', 'Español', false),
  french('fr', 'Français', false),

  /// Modern Standard Arabic; the only right-to-left language here.
  arabic('ar', 'العربية', true);

  const AppLanguage(this.code, this.nativeName, this.isRtl);

  /// What is stored on the device and what [Locale.languageCode] becomes.
  final String code;

  /// The language's own name, shown the same way whatever language the app is
  /// in so someone who can't read the current one can still find theirs.
  /// Null for [system], whose label is translated.
  final String? nativeName;

  final bool isRtl;

  bool get isAutomatic => this == system;

  /// The locale to force, or null to follow the device.
  Locale? get locale => isAutomatic ? null : Locale(code);

  /// Every language that can be picked explicitly, in display order.
  static const List<AppLanguage> explicit = [english, mandarin, hindi, spanish, french, arabic];

  /// Stored value → language; anything unknown (a language dropped in a later
  /// version, a corrupted value) means [system].
  static AppLanguage fromCode(String? code) =>
      values.firstWhere((l) => l.code == code, orElse: () => AppLanguage.system);
}

/// The locale the app should actually use: the chosen language, or — for
/// [AppLanguage.system] — the first of the device's locales we have a
/// translation for, else English. Same rule Flutter applies on its own, kept
/// here so code with no `BuildContext` (notifications) resolves identically.
Locale resolveLocale(AppLanguage language, List<Locale> deviceLocales) {
  final chosen = language.locale;
  if (chosen != null) return chosen;
  for (final device in deviceLocales) {
    for (final candidate in AppLanguage.explicit) {
      if (candidate.code == device.languageCode) return candidate.locale!;
    }
  }
  return AppLanguage.english.locale!;
}
