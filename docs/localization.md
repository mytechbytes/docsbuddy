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

## Migration status

Localized: app shell (navigation), the whole auth flow, Settings and Change
Password.

Still English literals (migrate feature by feature, same pattern):
catalog (assets, rooms, add/edit asset, asset detail, search), reminders,
dashboard, family, profile, security, documents, onboarding.

Domain-side text is not localized yet and needs a small design step:
- enum labels (`ReminderKind.label`, `Recurrence.label`, `DocKind.label`,
  `FamilyRole.label`) → map to l10n in the presentation layer via
  extensions instead of reading `.label`;
- `AppFailure.message` → give failures a code the UI maps to a localized
  message, keeping `message` as the English fallback.
