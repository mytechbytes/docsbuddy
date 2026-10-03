import 'dart:ui';

import 'package:docsbuddy/core/l10n/app_language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLanguage', () {
    test('lists the six languages, in the order the picker shows them', () {
      expect(AppLanguage.explicit.map((l) => l.code), ['en', 'zh', 'hi', 'es', 'fr', 'ar']);
      expect(AppLanguage.explicit, isNot(contains(AppLanguage.system)));
    });

    test('automatic has no locale of its own; every other language does', () {
      expect(AppLanguage.system.locale, isNull);
      expect(AppLanguage.system.isAutomatic, isTrue);
      for (final language in AppLanguage.explicit) {
        expect(language.locale, Locale(language.code));
        expect(language.nativeName, isNotEmpty, reason: 'shown in the picker in its own script');
      }
    });

    test('Arabic is the only right-to-left language', () {
      expect(AppLanguage.values.where((l) => l.isRtl), [AppLanguage.arabic]);
    });

    test('a stored code maps back to its language; anything else means automatic', () {
      for (final language in AppLanguage.values) {
        expect(AppLanguage.fromCode(language.code), language);
      }
      expect(AppLanguage.fromCode(null), AppLanguage.system);
      expect(AppLanguage.fromCode('klingon'), AppLanguage.system);
      expect(AppLanguage.fromCode(''), AppLanguage.system);
    });
  });

  group('resolveLocale', () {
    test('a chosen language wins over whatever the device is set to', () {
      expect(resolveLocale(AppLanguage.french, const [Locale('ar', 'EG')]), const Locale('fr'));
    });

    test('automatic follows the device language', () {
      expect(resolveLocale(AppLanguage.system, const [Locale('hi', 'IN')]), const Locale('hi'));
      expect(resolveLocale(AppLanguage.system, const [Locale('es', 'MX')]), const Locale('es'));
      expect(resolveLocale(AppLanguage.system, const [Locale('ar', 'SA')]), const Locale('ar'));
    });

    test('automatic takes the first device language we translate, not just the first', () {
      expect(resolveLocale(AppLanguage.system, const [Locale('de'), Locale('fr', 'CA'), Locale('en')]), const Locale('fr'));
    });

    test('Traditional-script Chinese resolves to the Chinese translation we have', () {
      expect(resolveLocale(AppLanguage.system, const [Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW')]),
          const Locale('zh'));
    });

    test('automatic falls back to English for a language we do not translate, or no locales at all', () {
      expect(resolveLocale(AppLanguage.system, const [Locale('de'), Locale('ja')]), const Locale('en'));
      expect(resolveLocale(AppLanguage.system, const []), const Locale('en'));
    });
  });
}
