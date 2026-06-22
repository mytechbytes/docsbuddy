# Release TODO — DocsBuddy internal testing

Status of what's needed to ship a Play **internal testing** build.
`[x]` = done in the repo · `[ ]` = your action (account/keys/hosting).

> ⚠️ **Scope reality check.** The app today is **onboarding → auth → families →
> a placeholder dashboard**. The core product — locations/assets, reminders/due
> dates, documents, and push notifications — is **not built yet**. An internal
> testing release now exercises sign-up/login and family sharing, not the full
> app. Decide if that's what you want testers to see.

## A. Backend (Supabase)
- [x] Schema + RLS + RPCs (`supabase/migrations/0001_init.sql`, `0002_family_rpcs.sql`)
- [x] App wiring (activates when `SUPABASE_URL` + `SUPABASE_ANON_KEY` are set)
- [ ] Create the project; copy URL + anon key
- [ ] Run both migrations (SQL editor / psql)
- [ ] Auth → Providers: enable **Email** (+ **Email OTP** length 6 for reset)
- [ ] Auth → URL Configuration: **Site URL** = `https://docsbuddy.mytechbytes.in`;
      **Redirect URLs** += `https://docsbuddy.mytechbytes.in/login-callback`
      **and** `in.mytechbytes.docsbuddy://login-callback`
- [ ] (Optional) Google/Apple OAuth providers + their redirect URLs

## B. Signing key (you lost the old one)
- [ ] Generate a new upload keystore (`keytool -genkey … -alias upload`)
- [ ] **Request upload key reset** in Play Console (App integrity → upload the new
      cert PEM); wait for Google approval — see `docs/play-store-release.md`

## C. GitHub secrets (Settings → Secrets and variables → Actions)
- [ ] `ANDROID_KEYSTORE_BASE64` (`base64 -i docsbuddy-upload.jks`)
- [ ] `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`
- [ ] `SUPABASE_URL`, `SUPABASE_ANON_KEY` (bake backend into the build)
- [ ] (Optional) `PLAY_SERVICE_ACCOUNT_JSON` for auto-upload — you're uploading
      manually, so skip

## D. Deep links / App Links
- [x] Android verified `https` intent-filter (`autoVerify="true"`) + scheme fallback
- [x] `Env.authRedirectUrl` = the HTTPS URL
- [x] iOS `Runner.entitlements` prepared (`applinks:docsbuddy.mytechbytes.in`)
- [ ] **Host on the domain** (over HTTPS, `application/json`, no redirects):
      `/.well-known/assetlinks.json` (Play App Signing **SHA-256**) and
      `/.well-known/apple-app-site-association` (**Apple Team ID**)
- [ ] After install, verify: `adb shell pm verify-app-links --re-verify in.mytechbytes.docsbuddy`
- [ ] **iOS only:** enable Associated Domains in Xcode (Signing & Capabilities)
      once iOS signing exists — intentionally not pre-wired (would break signed builds)

## E. Build & upload the AAB (manual)
- [x] `version: 2.0.62+30` (> your prior 29 / 2.0.61) and release signing config
- [x] `Release AAB + Play deploy (manual)` workflow builds the signed AAB
- [ ] Run it (Actions → Run workflow) → download `docsbuddy-release-aab`
- [ ] Play Console → Internal testing → Create release → upload the AAB → add
      testers → roll out

## F. Play Console first-time requirements
- [ ] App created with package **`in.mytechbytes.docsbuddy`** (must match the v29 listing)
- [ ] **Privacy policy URL** (e.g. `https://docsbuddy.mytechbytes.in/privacy`)
- [ ] Data safety form, content rating, target audience
- [ ] Confirm **Play App Signing** is enabled
- [ ] Store listing assets (icon, screenshots) — for testing tracks these are light

## G. Known gaps / next features
- [x] Core features: assets, locations & reminders (dashboard, asset CRUD, add
      reminder)
- [x] Supabase-backed catalog — persists when `SUPABASE_*` is configured (maps
      to the 0001 tables; falls back to the seeded fake otherwise). **Needs live
      testing against a real project.**
- [x] Documents — attach / upload / view via Supabase Storage (bucket +
      RLS in 0004_storage.sql). **Needs live testing.**
- [x] On-device reminder notifications (local scheduler, 30/7/1-day @ 09:00)
- [x] FCM wired (Android): google-services.json + firebase_messaging +
      device-token registration to user_devices
- [x] FCM sender — `supabase/functions/notify-family` (silent data push on a
      family member's change). Signs the FCM HTTP-v1 token with Web Crypto (no
      external module). **You:** `supabase functions deploy notify-family
      --use-api`, set `FIREBASE_SERVICE_ACCOUNT`, add a Database Webhook on
      `asset_dates`/`assets`/`documents`. **Not live-tested.**
- [x] App icon applied via `flutter_launcher_icons` (`assets/icon/*`); regenerate
      with `dart run flutter_launcher_icons`
- [x] Release build green on CI — AGP 9 / Flutter plugin JVM-target (→17) and
      `compileSdk` (→36) alignment handled in `android/build.gradle.kts` via the
      AGP variant `finalizeDsl` hook; signed AAB artifact produced
- [ ] Splash screen still the Flutter default (icon is set; branded splash TODO)
- [ ] KGP deprecation: device_info_plus, flutter_timezone, package_info_plus,
      passkeys_android, ua_client_hints still apply the legacy Kotlin Gradle
      Plugin — only a warning today, will break a future Flutter; bump them when
      Built-in-Kotlin versions ship
- [ ] iOS push: GoogleService-Info.plist + APNs key (when shipping iOS)
- [ ] iOS signing + provisioning (Team ID, certs) if you ship iOS
