# Localization

DocsBuddy ships in six languages and lets the user pick one — or follow the
device ("Automatic", the default). Everything about it lives in
`lib/core/l10n/`:

| File | What it is |
|---|---|
| `app_language.dart` | **The one list of languages** (`AppLanguage`), and `resolveLocale` — what "Automatic" picks for a given device |
| `language_store.dart` / `language_controller.dart` | Persists the choice; `languageProvider` (the pick), `effectiveLocaleProvider` (what is actually shown), `appLocalizationsProvider` (strings for code with no `BuildContext`) |
| `l10n.dart` | `context.l10n.someKey`, plus locale-aware date / money formatting and `context.tracking(…)` |
| `failure_text.dart` | Turns any error into text in the current language ([errors](errors-and-logging.md)) |
| `rich_template.dart` | Renders a translated sentence that has a link or bold name inside it |

| Language | Code | Notes |
|---|---|---|
| English | `en` | Template; the source of every string |
| Mandarin Chinese (Simplified) | `zh` | Traditional-script devices resolve here too |
| Hindi | `hi` | |
| Spanish | `es` | Neutral (tú) |
| French | `fr` | Formal (vous); punctuation spacing follows French typography |
| Standard Arabic | `ar` | **Right-to-left**; the layout mirrors automatically |

> **Review before release.** The five translations were drafted with AI and
> have not been reviewed by native speakers. Have each one checked — especially
> the legal links (Terms, Privacy), domain terms (AMC, "assets"), and the
> shorter strings that sit in tight UI (tabs, chips).

## How the language is chosen

- **Settings → Language** opens a sheet: *Automatic*, then each language by its
  **own name** (English, 中文 (简体), हिन्दी, Español, Français, العربية), so it can
  be found whatever language the app is in. The choice is stored on the device.
- **Automatic** follows the device: the first of the device's languages we
  translate wins; a device in a language we don't ship gets English.
- The same rule decides the language of **local reminder notifications**, which
  are composed outside the widget tree (`appLocalizationsProvider`), and they are
  re-scheduled when the language changes.
- On Android 13+ the per-app language setting lists the same six languages
  (`res/xml/locales_config.xml`); iOS/macOS declare them in `CFBundleLocalizations`.

## Writing strings

Strings live in `lib/l10n/app_en.arb` and are generated into
`lib/l10n/app_localizations*.dart` by `flutter gen-l10n` (also runs on
`flutter pub get`; config in `l10n.yaml`). Widgets read them with
`context.l10n.someKey`.

- **Keys** are prefixed by area: `common*`, `nav*`, `auth*`, `settings*`,
  `error*`, `loading*`, …
- **Plurals / placeholders** use ICU syntax — never build plurals in Dart.
  Chinese needs only `other`; Hindi/Spanish `=1`/`other`; French `one`/`other`
  (0 is singular); Arabic uses all of `one`, `two`, `few`, `many`, `other`.
- **One sentence, one string.** Never glue `lead + link + tail` in code — word
  order differs between languages. Put placeholders in the string and render
  them with `richTemplate`:

  ```dart
  Text.rich(TextSpan(children: richTemplate(
    context.l10n.authTermsAgreement('{terms}', '{privacy}'),
    {'terms': TextSpan(text: context.l10n.authTermsOfService, …),
     'privacy': TextSpan(text: context.l10n.authPrivacyPolicy, …)},
  )));
  ```
- **Dates and numbers** go through `context.formatDate`, `formatMoney`, …
  English keeps its day-first style; other languages use their own (`2026年3月5日`,
  `5 mars 2026`). Arabic uses Latin digits throughout so a screen never mixes
  two numeral systems.
- **Letter-spacing:** use `context.tracking(1.2)`, not a literal. Tracking breaks
  the joins in Arabic and the headline bar in Devanagari, so those get none.

## Right-to-left

Arabic mirrors the whole layout. Write layout that mirrors itself:

- `EdgeInsetsDirectional` (`start`/`end`), not `EdgeInsets.only(left/right)`
- `AlignmentDirectional.centerStart/End`, not `Alignment.centerLeft/Right`
- `PositionedDirectional(start/end)`, not `Positioned(left/right)`
- Icons like `chevron_right` flip by themselves; pictures of a thing don't need to.

The onboarding illustrations are fixed artwork and deliberately don't mirror.

## Adding a language

1. Add a value to `AppLanguage` (code, native name, `isRtl`).
2. Copy `app_en.arb` to `app_<code>.arb`, translate every value (keep the
   placeholder names; add plural forms the language needs), run `flutter gen-l10n`.
3. Add it to `android/app/src/main/res/xml/locales_config.xml` and to
   `CFBundleLocalizations` in `ios/Runner/Info.plist` and `macos/Runner/Info.plist`.
4. `flutter test` — the guards tell you what is missing.

## What the tests guard

- `test/core/l10n/translations_test.dart` — every language has every key, with the
  same placeholders, valid plurals, and nothing left in English (brand names and
  shared words are allow-listed per language). **Adding a string to English without
  translating it fails the build** instead of silently showing English.
- `test/platform/locale_config_test.dart` — Android/iOS/macOS declare exactly the
  languages in `AppLanguage`.
- `test/core/l10n/locale_smoke_test.dart` — 14 real screens × 6 languages build and
  fit a 360dp phone, and run the right way round.
- `formatting_test.dart`, `app_language_test.dart`, `language_controller_test.dart`,
  `failure_text_test.dart` (every error reason in every language).
- The widget catalog has a **Locale** switch (`widgetbook/`), Arabic included.

## What is localized

Every user-facing screen, dialog, snackbar, loading message and empty state
(~475 strings), plus:

- **Enum labels** — `kind.displayName(context)`, `role.displayName(context)`, …
  The domain `label`s stay English because some are stored as data.
- **Errors** — see [errors and logging](errors-and-logging.md). App-originated
  failures carry a `FailureReason`; the common server errors (wrong password,
  email not confirmed, rate limited, …) are mapped to reasons too. A server
  message we don't recognise is shown as the server wrote it (English).
- **Local reminder notifications** — the countdown text ("Due in 3 days").
  Titles are the user's own asset and reminder names.

## Not localized (yet)

- **Names stored as data:** built-in appliance types and property labels
  (`common_categories.dart`, `property_specs.dart`) and the default reminder
  labels they create ("Warranty", "Service Due") mirror backend seed data and are
  saved into the user's records, so they appear in English in every language.
  Localizing them needs a product decision (store a key and translate on display,
  or translate when creating) and, for the catalog, the backend seed.
- **Server-side text:** push notifications and emails sent by the Edge Functions
  (`supabase/functions`) are written there, not in the app.
- `features/roadmap` — an internal developer checklist.
- The startup screen (shown before preferences load) follows the device language,
  not a saved in-app choice.
- Store listing text, screenshots and the marketing site.
