# Configuring Supabase for DocsBuddy

By default the app runs with **no backend** — an in-memory fake auth/family
repository — so every screen works offline. This guide turns on real Supabase.

- [Part A — Supabase dashboard](#part-a--supabase-dashboard-configuration)
- [Part B — Database schema](#part-b--apply-the-database-schema)
- [Part C — Run the app with credentials](#part-c--run-the-app-with-credentials)
- [Part D — Where this maps in the codebase](#part-d--where-this-maps-in-the-codebase)
- [Part E — Deep links (only for OAuth / magic links)](#part-e--deep-links-only-for-oauth--magic-links)

---

## Part A — Supabase dashboard configuration

1. **Create a project** at <https://supabase.com/dashboard>.
2. **Project Settings → API** — copy two values:
   | Dashboard value | Used as |
   |---|---|
   | Project URL | `SUPABASE_URL` |
   | `anon` / publishable key | `SUPABASE_ANON_KEY` |
3. **Authentication → Providers / Sign In:**
   - **Email** — enable. For dev you may turn **Confirm email** off so sign-up
     logs in immediately; keep it on for production.
   - **Email OTP** — enable, length **6**. The forgot-password flow uses a
     6-digit code (`signInWithOtp` → `verifyOTP` → `updateUser`).
   - **Google / Apple** (optional, for the social buttons) — create OAuth
     credentials in Google Cloud / Apple Developer, paste client ID/secret here,
     and add the redirect URLs from Part E.
4. **Authentication → URL Configuration** — **required so confirm-email / magic
   links return to the app instead of `localhost`:**
   - **Redirect URLs** → add **`https://docsbuddy.mytechbytes.in/login-callback`**
     (this is `Env.authRedirectUrl`; the app passes it as `emailRedirectTo` /
     OAuth `redirectTo`). Also add the custom-scheme fallback
     `in.mytechbytes.docsbuddy://login-callback`.
   - **Site URL** → set to `https://docsbuddy.mytechbytes.in` (defaults to
     `http://localhost:3000`, which is what opens in the browser otherwise).
   - The HTTPS URL opens the app directly via **App Links / Universal Links** once
     the site serves `/.well-known/assetlinks.json` (Android) and
     `/.well-known/apple-app-site-association` (iOS) — see Part E.
   - **Dev shortcut:** while testing, you can turn **Confirm email = off**
     (Authentication → Providers → Email) so sign-up logs in immediately and
     skips the email round-trip entirely. Turn it back on for production.

## Part B — Apply the database schema

**Easiest:** paste **`supabase/all_migrations.sql`** (all migrations 0001–0008
combined, generated) into the SQL Editor and Run once on a fresh project.

Or apply the individual migrations in order (SQL Editor or CLI):

```bash
for f in supabase/migrations/*.sql; do psql "$DATABASE_URL" -f "$f"; done
```

- `0001_init.sql` — tables, RLS, `updated_at` triggers, `handle_new_user`,
  `is_family_member`, `accept_invite`, `complete_asset_date`.
- `0002_family_rpcs.sql` — `create_family` + `create_invite` (SECURITY DEFINER).
- `0003_short_invite_code.sql` — 8-char invite codes.
- `0004_storage.sql` — `docsbuddy-files` bucket + family-scoped storage RLS.
- `0005_seed_categories.sql` — category catalog seed, `asset_dates.kind`,
  category→FK backfill.
- `0006_service_fields.sql` — service provider/policy/cost/notes,
  location→FK backfill.
- `0007_whatsapp_channel.sql` — whatsapp notification channel.
- `0008_family_profile_visibility.sql` — family members can read each
  other's basic profile.

## Part C — Run the app with credentials

Pass the two values via `--dart-define` — **never commit keys**:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_OR_PUBLISHABLE_KEY
```

Same flags for release builds (source from CI secrets):

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

Tip: put them in a JSON file and use `--dart-define-from-file=env.json` (add the
file to `.gitignore`).

**Verify:** the Dashboard screen shows a **"Backend: Supabase"** chip when init
succeeded (vs **"Local (fake auth)"** when the defines are absent).

### CI builds (GitHub Actions)

The build workflows already forward the keys into `--dart-define` from repo
secrets — you only need to create the secrets:

1. **Repo → Settings → Secrets and variables → Actions → New repository secret:**
   - `SUPABASE_URL` = `https://YOUR_PROJECT.supabase.co`
   - `SUPABASE_ANON_KEY` = your anon/publishable key
2. The build steps that consume them:
   - `.github/workflows/build.yml` → Android `flutter build apk`
   - `.github/workflows/build-apple.yml` → macOS + iOS builds

Until the secrets exist, `${{ secrets.* }}` expands to empty → empty defines →
the artifact falls back to the local fake auth. So it's safe before secrets are
set, and "just works" once they are. Never hardcode keys in the workflow files.

## Part D — Where this maps in the codebase

You normally **don't edit Dart files** to switch backends — passing the two
`--dart-define`s is enough. Here's what each piece touches:

| Concern | File | What happens / when to edit |
|---|---|---|
| Reads the two env vars | `lib/core/config/env.dart` | `Env.supabaseUrl/anonKey`; `Env.hasSupabase` flips the app to Supabase. No edit needed. |
| Initializes the SDK | `lib/main.dart` | Calls `Supabase.initialize(...)` only when `Env.hasSupabase`. |
| Secure session storage | `lib/core/storage/secure_supabase_storage.dart` | Keychain/Keystore adapters passed to `authOptions`. No edit needed. |
| Auth: fake ↔ Supabase | `lib/features/auth/application/auth_providers.dart` | `authRepositoryProvider` picks `SupabaseAuthRepository` when configured. |
| Auth backend calls | `lib/features/auth/data/supabase_auth_repository.dart` | Edit only to change a flow (e.g. recovery-by-link vs OTP). |
| Family: fake ↔ Supabase | `lib/features/family/application/family_controller.dart` | `familyRepositoryProvider` picks the Supabase impl when configured. |
| Family backend calls | `lib/features/family/data/supabase_family_repository.dart` | Calls `create_family` / `create_invite` / `accept_invite` RPCs. |
| DB schema | `supabase/migrations/0001_init.sql`, `0002_family_rpcs.sql` | Run in the dashboard (Part B). |
| Deep links | `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`, `macos/Runner/Info.plist` | Only for OAuth / magic links (Part E). |

**To change the recovery flow** to a reset link instead of a 6-digit code:
in `supabase_auth_repository.dart`, swap `sendPasswordResetCode` from
`signInWithOtp(email:)` to `resetPasswordForEmail(email)` and adjust the
verify/reset screens accordingly.

## Part E — Deep links (App Links / Universal Links)

Email/password sign-in without email-confirm needs **none** of this. Confirm-email,
magic link, and OAuth use `Env.authRedirectUrl` =
`https://docsbuddy.mytechbytes.in/login-callback`.

**App side — already wired in this repo:**
- `signUp`/OAuth pass the URL (`supabase_auth_repository.dart`).
- **Android App Link** — verified `https` intent-filter on `MainActivity`
  (`autoVerify="true"`) + a custom-scheme fallback
  (`in.mytechbytes.docsbuddy://login-callback`).
- **iOS** — `ios/Runner/Runner.entitlements` is ready with
  `applinks:docsbuddy.mytechbytes.in`, plus the custom scheme in `Info.plist`.
  ⚠️ **Not yet enabled in Xcode** — turn on *Signing & Capabilities → Associated
  Domains* once iOS signing is set up (see the release TODO).

**Site side — you host on `docsbuddy.mytechbytes.in`** (these make the HTTPS link
open the app directly):
- `/.well-known/assetlinks.json` — Android, with the **Play App Signing** key's
  SHA-256.
- `/.well-known/apple-app-site-association` — iOS, with your **Apple Team ID**.
  Both must be served over HTTPS, `Content-Type: application/json`, no redirects.

**Supabase side:** add both URLs to **Redirect URLs** and set **Site URL** (Part A).

## Still stubbed / follow-ups

- **Google/Apple** call `signInWithOAuth` — they only complete once providers +
  redirects (Parts A & E) are configured.
- The recovery flow assumes **email OTP** (Part A).
- No live project was used to smoke-test the real GoTrue/PostgREST round-trips;
  the fake path is fully tested.
