import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds a context in [code]'s locale and hands it to [check].
Future<void> _inLocale(WidgetTester tester, String code, void Function(BuildContext context) check) async {
  late BuildContext context;
  await tester.pumpWidget(MaterialApp(
    locale: Locale(code),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(builder: (c) {
      context = c;
      return const SizedBox();
    }),
  ));
  await tester.pumpAndSettle();
  check(context);
}

void main() {
  final date = DateTime(2026, 3, 5);

  testWidgets('English keeps the app’s day-first style exactly as before', (tester) async {
    await _inLocale(tester, 'en', (context) {
      expect(context.formatDate(date), '5 Mar 2026');
      expect(context.formatShortDate(date), '5 Mar');
      expect(context.formatMonthYear(date), 'Mar 2026');
      expect(context.formatNumericDate(date), '05 / 03 / 2026');
      expect(context.formatMoney(42000), '₹ 42,000');
      expect(context.formatOffsets([30, 7, 1]), '30d · 7d · 1d');
    });
  });

  testWidgets('other languages use their own date conventions, not English’s', (tester) async {
    const expected = {
      'zh': ('2026年3月5日', '3月5日', '2026年3月'),
      'hi': ('5 मार्च 2026', '5 मार्च', 'मार्च 2026'),
      'es': ('5 mar 2026', '5 mar', 'mar 2026'),
      'fr': ('5 mars 2026', '5 mars', 'mars 2026'),
      'ar': ('5 مارس 2026', '5 مارس', 'مارس 2026'),
    };
    for (final e in expected.entries) {
      await _inLocale(tester, e.key, (context) {
        expect(context.formatDate(date), e.value.$1, reason: e.key);
        expect(context.formatShortDate(date), e.value.$2, reason: e.key);
        expect(context.formatMonthYear(date), e.value.$3, reason: e.key);
      });
    }
  });

  testWidgets('Arabic dates use the same Latin digits as the numbers next to them', (tester) async {
    await _inLocale(tester, 'ar', (context) {
      expect(context.formatDate(date), isNot(matches(RegExp('[٠-٩]'))));
      expect(context.formatNumericDate(date), contains('2026'));
      expect(context.formatMoney(42000), '₹ 42,000');
    });
  });

  testWidgets('grouping follows the language: 42,000 · 42.000 · 42 000', (tester) async {
    await _inLocale(tester, 'es', (context) => expect(context.formatMoney(42000), '₹ 42.000'));
    await _inLocale(tester, 'fr', (context) => expect(context.formatMoney(42000).replaceAll(RegExp(r'\s'), ' '), '₹ 42 000'));
  });

  testWidgets('plurals follow each language’s rules, including Arabic’s six forms', (tester) async {
    await _inLocale(tester, 'en', (c) => expect([c.l10n.memberCount(1), c.l10n.memberCount(3)], ['1 member', '3 members']));
    await _inLocale(tester, 'fr', (c) => expect([c.l10n.memberCount(1), c.l10n.memberCount(3)], ['1 membre', '3 membres']));
    await _inLocale(tester, 'zh', (c) => expect(c.l10n.memberCount(3), '3 位成员'));
    await _inLocale(tester, 'ar', (c) {
      expect(c.l10n.memberCount(1), 'عضو واحد');
      expect(c.l10n.memberCount(2), 'عضوان');
      expect(c.l10n.memberCount(3), '3 أعضاء');
      expect(c.l10n.memberCount(11), '11 عضوًا');
      expect(c.l10n.memberCount(100), '100 عضو');
    });
  });

  testWidgets('a sentence with a placeholder keeps it in the right place', (tester) async {
    await _inLocale(tester, 'es', (c) => expect(c.l10n.authOtpSubtitle('a@b.dev'), contains('a@b.dev')));
    await _inLocale(tester, 'ar', (c) => expect(c.l10n.errorUploadsFailed(2, 5), 'فشل رفع 2 من أصل 5.'));
  });

  testWidgets('letter-spacing applies to Latin scripts only — it would break Arabic and Devanagari joins', (tester) async {
    for (final code in ['en', 'es', 'fr']) {
      await _inLocale(tester, code, (c) {
        expect(c.tracking(1.2), 1.2, reason: code);
        expect(c.tracking(-0.5), -0.5, reason: code);
      });
    }
    for (final code in ['ar', 'hi', 'zh']) {
      await _inLocale(tester, code, (c) {
        expect(c.tracking(1.2), 0, reason: code);
        expect(c.tracking(-0.5), 0, reason: code);
      });
    }
  });

  testWidgets('the step header counts in the user’s language', (tester) async {
    await _inLocale(tester, 'en', (c) => expect(c.l10n.commonStepOf(2, 3), 'STEP 2 OF 3'));
    await _inLocale(tester, 'es', (c) => expect(c.l10n.commonStepOf(2, 3), 'PASO 2 DE 3'));
    await _inLocale(tester, 'ar', (c) => expect(c.l10n.commonStepOf(2, 3), 'الخطوة 2 من 3'));
  });
}
