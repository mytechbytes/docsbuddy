import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizations l10n;
  setUpAll(() async => l10n = await AppLocalizations.delegate.load(const Locale('en')));

  test('plurals and placeholders render', () {
    expect(l10n.settingsMemberCount(1), '1 member');
    expect(l10n.settingsMemberCount(3), '3 members');
    expect(l10n.settingsDaysBefore(7), '7d before');
    expect(l10n.authOtpSubtitle('a@b.dev'), contains('a@b.dev'));
  });

  test('English is supported', () {
    expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
  });
}
