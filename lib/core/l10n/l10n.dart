import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// `context.l10n.someKey` — generated from `lib/l10n/app_en.arb`
/// (`flutter gen-l10n`, run automatically by `flutter pub get`/`run`).
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String get _locale => Localizations.localeOf(this).toString();

  /// e.g. "5 Mar 2026".
  String formatDate(DateTime date) => DateFormat('d MMM yyyy', _locale).format(date);

  /// e.g. "5 Mar".
  String formatShortDate(DateTime date) => DateFormat('d MMM', _locale).format(date);

  /// e.g. "Mar 2026".
  String formatMonthYear(DateTime date) => DateFormat('MMM yyyy', _locale).format(date);

  /// e.g. "05 / 03 / 2026".
  String formatNumericDate(DateTime date) => DateFormat('dd / MM / yyyy', _locale).format(date);

  /// Amount in rupees, e.g. "₹ 42,000".
  String formatMoney(num amount) => '₹ ${NumberFormat('#,##0.##', _locale).format(amount)}';

  /// Days-before offsets, e.g. "30 · 7 · 1d".
  String formatOffsets(List<int> offsets) => offsets.map(l10n.durationDaysShort).join(' · ');
}
