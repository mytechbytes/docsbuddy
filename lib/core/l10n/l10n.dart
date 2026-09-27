import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// `context.l10n.someKey` — generated from `lib/l10n/app_en.arb`
/// (`flutter gen-l10n`, run automatically by `flutter pub get`/`run`).
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
