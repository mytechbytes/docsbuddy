# Localization

Strings live in `lib/l10n/app_en.arb` and are generated into
`lib/l10n/app_localizations*.dart` by `flutter gen-l10n` (runs automatically
on `flutter pub get` / `flutter run`; config in `l10n.yaml`). Widgets read
them with `context.l10n.someKey` (`lib/core/l10n/l10n.dart`).

- **Keys** are prefixed by area: `common*`, `nav*`, `auth*`, `settings*`, …
- **Plurals / placeholders** use ICU syntax, e.g.
  `"{count, plural, =1{1 member} other{{count} members}}"` — never build
  plurals in Dart.
- **Adding a language:** copy `app_en.arb` to `app_<locale>.arb`, translate
  the values, and run `flutter gen-l10n`. `supportedLocales` updates itself.
  On iOS also add the locale to `CFBundleLocalizations` in `Info.plist`.

## What's localized

Every user-facing screen, dialog, snackbar and empty state (~400 strings),
plus:

- **Enum labels** — shown via presentation extensions
  (`kind.displayName(context)`, `role.displayName(context)`, …). The domain
  `label`s stay English because some are stored as data (e.g. a service's
  default label).
- **Errors** — app-originated failures carry a `FailureReason`;
  `context.failureText(error)` / `context.showFailure(error)` translate it
  (`core/l10n/failure_text.dart`). Messages that come from the server have
  no reason and are shown as-is.
- **Dates, money, offsets** — `context.formatDate`, `formatShortDate`,
  `formatMoney`, `formatOffsets` use the current locale.

Deliberately not localized:
- `features/roadmap` — an internal developer checklist.
- Built-in appliance type names and property labels
  (`common_categories.dart`, `property_specs.dart`) — they mirror the
  backend seed data; localize them server-side if needed.
- Product names in the onboarding sample illustrations.
