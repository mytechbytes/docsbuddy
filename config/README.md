# Local build configuration

Compile-time values for `flutter run` / `flutter build`, read by
`lib/core/config/env.dart` via `String.fromEnvironment`.

| File | Committed | Use |
|---|---|---|
| `dev.example.json` | yes | Template — copy to `dev.json` |
| `dev.json` | **no** (gitignored) | Your Supabase project for local development |
| `fake.json` | yes | Offline in-memory backend, no keys needed |

```bash
cp config/dev.example.json config/dev.json   # then fill in the values
flutter run --dart-define-from-file=config/dev.json
flutter run --dart-define-from-file=config/fake.json
```

Values come from Supabase → **Project Settings → API** (Project URL and the
anon / publishable key). Only these public client values belong here — never
put provider secrets (Google/Apple/Microsoft client secrets, the Apple `.p8`
key) or the Supabase **service_role** key in the app or this folder; those live
only in the Supabase dashboard and the team password manager.

CI does not use these files: workflows pass `SUPABASE_URL` /
`SUPABASE_ANON_KEY` from GitHub repository secrets.
