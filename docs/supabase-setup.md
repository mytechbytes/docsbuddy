# Configuring Supabase for DocsBuddy auth

The app runs **without** any backend by default (an in-memory fake auth
repository). To switch the auth screens onto real Supabase, do the following.

## 1. Create the project & get keys

1. Create a project at <https://supabase.com/dashboard>.
2. **Project Settings → API** → copy:
   - **Project URL** → `SUPABASE_URL`
   - **Publishable / anon key** → `SUPABASE_ANON_KEY`

These are passed at build/run time via `--dart-define` (below). The app only
calls `Supabase.initialize(...)` when both are present (`core/config/env.dart`);
otherwise it stays on the fake repository.

## 2. Apply the database schema

Run the corrected schema once (tables + RLS + triggers + RPCs):

```bash
# Supabase SQL editor: paste the file, or with the CLI:
supabase db push        # if using the CLI with this repo linked, or
psql "$DATABASE_URL" -f supabase/migrations/0001_init.sql
```

That file (`supabase/migrations/0001_init.sql`) creates `users`,
`families`, `assets`, `asset_dates`, `documents`, etc., the
`handle_new_user` trigger, the `is_family_member` RLS helper, and the
`accept_invite` / `complete_asset_date` RPCs.

## 3. Enable auth methods

In **Authentication → Providers / Sign In**:

- **Email**: enable. For dev, you may turn **Confirm email** off so sign-up
  logs you straight in; keep it on for production.
- **Email OTP**: the "forgot password" flow uses a 6-digit code
  (`signInWithOtp` → `verifyOTP(type: email)` → `updateUser(password:)`).
  Ensure email OTP is enabled and the OTP length is 6.
- **Google** & **Apple** (optional, for the social buttons):
  - Create OAuth credentials in Google Cloud / Apple Developer.
  - Paste the client ID/secret into the Supabase provider settings.
  - Add the redirect URL Supabase shows you, **and** the app deep link below.

## 4. Deep link / redirect (mobile OAuth + OTP)

OAuth and magic-link flows return to the app via a deep link. Pick a scheme,
e.g. `in.mytechbytes.docsbuddy://login-callback`, and:

- **Supabase → Authentication → URL Configuration → Redirect URLs**: add it.
- **Android** (`android/app/src/main/AndroidManifest.xml`): add an
  `intent-filter` on `MainActivity` for that scheme.
- **iOS/macOS** (`Info.plist`): add a `CFBundleURLTypes` entry for the scheme.

(Email/password sign-in works **without** any deep-link setup — wire deep links
only when you enable Google/Apple or magic links.)

## 5. Run with credentials

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_KEY
```

For CI/release, pass the same `--dart-define`s to `flutter build`, sourced from
secrets — never commit keys. The dashboard shows a **"Backend: Supabase"** chip
when initialization succeeded (vs "Local (fake auth)").

## 6. Session storage (already wired)

Sessions and the PKCE verifier are persisted in the **iOS Keychain / Android
Keystore** via `core/storage/secure_supabase_storage.dart`, passed to
`Supabase.initialize` as `authOptions.localStorage` / `pkceAsyncStorage`
(architecture review #9) — not the SDK's default SharedPreferences.

## What's still stubbed

- **Google/Apple** call `signInWithOAuth`, which needs the provider + redirect
  config above to actually complete.
- The recovery flow assumes **email OTP**; if you prefer reset-by-link, switch
  `sendPasswordResetCode` to `resetPasswordForEmail` in
  `SupabaseAuthRepository`.
