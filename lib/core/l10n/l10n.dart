import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// `context.l10n.someKey` — generated from `lib/l10n/app_en.arb`
/// (`flutter gen-l10n`, run automatically by `flutter pub get`/`run`).
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String get _locale => Localizations.localeOf(this).toString();

  /// English keeps the app's day-first style; other languages use their own date conventions.
  bool get _isEnglish => Localizations.localeOf(this).languageCode == 'en';

  /// e.g. "5 Mar 2026".
  String formatDate(DateTime date) =>
      _latinDigits((_isEnglish ? DateFormat('d MMM yyyy', _locale) : DateFormat.yMMMd(_locale)).format(date));

  /// e.g. "5 Mar".
  String formatShortDate(DateTime date) =>
      _latinDigits((_isEnglish ? DateFormat('d MMM', _locale) : DateFormat.MMMd(_locale)).format(date));

  /// e.g. "Mar 2026".
  String formatMonthYear(DateTime date) =>
      _latinDigits((_isEnglish ? DateFormat('MMM yyyy', _locale) : DateFormat.yMMM(_locale)).format(date));

  /// e.g. "05 / 03 / 2026".
  String formatNumericDate(DateTime date) =>
      _latinDigits((_isEnglish ? DateFormat('dd / MM / yyyy', _locale) : DateFormat.yMd(_locale)).format(date));

  /// Letter-spacing for localized text. Tracking breaks letter joins in Arabic and Devanagari, so ar/hi/zh get none.
  double tracking(double spacing) =>
      const {'ar', 'hi', 'zh'}.contains(Localizations.localeOf(this).languageCode) ? 0 : spacing;

  /// Amount in rupees, e.g. "₹ 42,000".
  String formatMoney(num amount) => '₹ ${NumberFormat('#,##0.##', _locale).format(amount)}';

  /// Days-before offsets, e.g. "30 · 7 · 1d".
  String formatOffsets(List<int> offsets) => offsets.map(l10n.durationDaysShort).join(' · ');
}

/// Arabic dates default to Arabic-Indic digits while every other number is Latin; normalised so a screen never mixes them.
String _latinDigits(String text) => text.replaceAllMapped(RegExp('[\u0660-\u0669\u06F0-\u06F9]'), (m) {
      final unit = m[0]!.codeUnitAt(0);
      return String.fromCharCode(0x30 + (unit >= 0x06F0 ? unit - 0x06F0 : unit - 0x0660));
    });
