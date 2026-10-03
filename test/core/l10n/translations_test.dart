import 'dart:convert';
import 'dart:io';

import 'package:docsbuddy/core/l10n/app_language.dart';
import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the translation files themselves: a string added to English must
/// reach every language, with its placeholders intact, or the build fails —
/// instead of a Spanish user quietly seeing English (gen-l10n falls back).
void main() {
  Map<String, String> read(String code) {
    final json = jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync()) as Map<String, dynamic>;
    return {
      for (final e in json.entries)
        if (!e.key.startsWith('@')) e.key: e.value as String,
    };
  }

  final english = read('en');
  final translated = [for (final l in AppLanguage.explicit) if (l.code != 'en') l.code];

  // `{name}` placeholders, plus the argument a plural switches on.
  final placeholder = RegExp(r'\{([A-Za-z_][A-Za-z0-9_]*)\}');
  final pluralArg = RegExp(r'\{([A-Za-z_][A-Za-z0-9_]*),\s*plural');
  Set<String> argsOf(String message) =>
      {...placeholder.allMatches(message).map((m) => m.group(1)!), ...pluralArg.allMatches(message).map((m) => m.group(1)!)};

  // Strings that are legitimately the same as English: brand names and words
  // the language shares with English.
  const sameAsEnglish = {
    'all': {'kindAmc', 'familyWhatsapp', 'biometricFace'},
    'es': {'docKindManual', 'securityMinutesShort', 'illoSmartphone'},
    'fr': {
      'commonNotifications', 'groupDocument', 'catalogNotes', 'catalogType', 'docsTitle', 'docKindPhoto',
      'profileDocuments', 'securityMinutesShort', 'illoSmartphone',
    },
    'zh': {'commonEmailHint'},
    'ar': {'commonEmailHint'},
  };

  test('the supported locales are exactly the languages listed in AppLanguage', () {
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
      AppLanguage.explicit.map((l) => l.code).toSet(),
    );
  });

  test('English is the template and has no empty strings', () {
    expect(english, isNotEmpty);
    expect(english.entries.where((e) => e.value.trim().isEmpty), isEmpty);
  });

  for (final code in translated) {
    group('app_$code.arb', () {
      final strings = read(code);

      test('has every key English has, and no others', () {
        expect(english.keys.toSet().difference(strings.keys.toSet()), isEmpty, reason: 'missing translations');
        expect(strings.keys.toSet().difference(english.keys.toSet()), isEmpty, reason: 'keys English no longer has');
      });

      test('keeps every placeholder, with the same names', () {
        final broken = [
          for (final key in english.keys)
            if (strings[key] != null && argsOf(english[key]!).difference(argsOf(strings[key]!)).isNotEmpty ||
                strings[key] != null && argsOf(strings[key]!).difference(argsOf(english[key]!)).isNotEmpty)
              '$key: ${argsOf(english[key]!)} vs ${argsOf(strings[key]!)}',
        ];
        expect(broken, isEmpty);
      });

      test('plural messages stay plurals and always have an "other" form', () {
        final broken = [
          for (final key in english.keys)
            if (english[key]!.contains('plural,') &&
                (!strings[key]!.contains('plural,') || !strings[key]!.contains('other{')))
              key,
        ];
        expect(broken, isEmpty);
      });

      test('braces balance in every message', () {
        final broken = [
          for (final e in strings.entries)
            if ('{'.allMatches(e.value).length != '}'.allMatches(e.value).length) e.key,
        ];
        expect(broken, isEmpty);
      });

      test('is actually translated — nothing left in English except brand names and shared words', () {
        final allowed = {...?sameAsEnglish['all'], ...?sameAsEnglish[code]};
        final untranslated = [
          for (final key in english.keys)
            if (strings[key] == english[key] && !allowed.contains(key)) key,
        ];
        expect(untranslated, isEmpty);
      });
    });
  }
}
