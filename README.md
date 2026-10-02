# DocsBuddy

Track your family's appliances, vehicles and documents, with service reminders
so you never miss a renewal. Flutter app (iOS + Android) on Supabase.

## Getting started

```bash
flutter pub get
```

**Offline (no backend, seeded demo data):**
```bash
flutter run --dart-define-from-file=config/fake.json
```

**Against your Supabase project:**
```bash
cp config/dev.example.json config/dev.json   # fill in SUPABASE_URL + SUPABASE_ANON_KEY
flutter run --dart-define-from-file=config/dev.json
```
`config/dev.json` is gitignored — see [config/README.md](config/README.md).
VS Code launch configurations for both are in `.vscode/launch.json`.

**Widget catalog** (every widget and screen, light/dark, any screen size and
font scale):
```bash
flutter run -d chrome -t widgetbook/main.dart
```
See [widgetbook/README.md](widgetbook/README.md).

After changing freezed models run `dart run build_runner build`; translations
are generated from `lib/l10n/app_en.arb` on `flutter pub get` / `flutter run`.

## Docs

| Topic | File |
|---|---|
| Supabase project + database | [docs/supabase-setup.md](docs/supabase-setup.md) |
| Google / Apple / Microsoft sign-in | [docs/social-sign-in.md](docs/social-sign-in.md) |
| Swapping or adding a backend | [docs/backends.md](docs/backends.md) |
| Localization | [docs/localization.md](docs/localization.md) |
| Theming & dark mode | [docs/theming.md](docs/theming.md) |
| Push notifications | [docs/push-setup.md](docs/push-setup.md) |
| Google Play release | [docs/play-store-release.md](docs/play-store-release.md) |
