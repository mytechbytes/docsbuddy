# Release TODO — DocsBuddy internal testing

Status of what's needed to ship a Play **internal testing** build.
`[x]` = done in the repo · `[ ]` = your action (account/keys/hosting).

> ⚠️ **Scope reality check.** The core product is built: onboarding → auth →
> families → dashboard, assets & reminders, documents, and notifications (see
> §G). What's still missing vs the design handoff — rooms, appliance picker,
> profile, security/2FA, asset photos — is tracked in **§H** and
> `docs/design-gap.md`. Decide if that's acceptable for testers to see.

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

## H. Design ↔ code gap — feature action items

Full detail + per-screen comparison in `docs/design-gap.md`. Screens: **11 of
21 done, 4 partial, 6 missing.** Almost nothing needs new tables — the work is
Dart models → repository mapping → screens.

### Done (shipped screens)
- [x] 00a–d Onboarding carousel
- [x] 01 Dashboard — redesigned to match handoff
- [x] 07 Asset detail — redesigned to match handoff
- [x] 09–13 Auth — sign-in/up (incl. Google/Apple), forgot, OTP, reset
- [x] `updatePassword` repo method (backend for Change password screen)
- [x] Document upload path to Supabase Storage (pattern reused for photos)

### Pending — data layer (schema already has the columns)
- [ ] A1 `Asset`: surface `serial_no, purchase_date, purchase_price, store,
      image_url, location_id` + collect model no. in the add form
- [ ] A2 Asset photos: upload to `docsbuddy-files` → `assets.image_url`;
      picker in add/edit; render thumbnails (dashboard, list, detail, rooms)
- [ ] A3 Per-reminder `notify_offsets`: model + repos + offsets chips in the
      reminder UI + feed `NotificationService` (replace global 30/7/1)
- [ ] A4 Category catalog: read `asset_categories`, auto-seed default
      reminders on create, **new** `0005_seed_categories.sql`
- [ ] A5 Profile data: `ProfileRepository` + avatar upload + real `avatar_url`
- [ ] A6 Real locations: back rooms with `public.locations` (photo, hierarchy,
      counts) instead of metadata grouping
- [ ] A7 Wire `notification_prefs` (channels, default offsets, quiet hours) to
      Settings toggles + Add-reminder defaults

### Pending — screens
- [ ] 02 Rooms (add-room composer, photo cards, asset counts, entry point)
- [ ] 03 Room detail (hero photo, edit, appliance grid, add-asset-here)
- [ ] 04 Asset list polish (in-page search bar, photo thumbnails, header style)
- [ ] 05 Appliance picker (searchable category grid → add-asset)
- [ ] 06 Add appliance: model no., serial, purchase date/price, store, AMC
      date → seeds reminder, invoice capture (file/camera), validation
- [ ] 08 Add reminder → full page: type tile grid, "in N days" helper,
      offsets chips, attach document, family-push note
- [ ] 14 Profile (avatar edit, stats row, family card + invite, menu rows)
- [ ] 15 Settings restyle: Account / Notifications / Family sections
- [ ] 16 Change password screen (strength meter; repo method exists)
- [ ] 17 Security: 2FA TOTP, biometric login + quick-unlock on sign-in,
      app lock/auto-lock, recovery codes, active sessions — **largest item**

### Pending — wiring & debt
- [ ] Wire decorative UI: search icon, notification bell/dot (inbox from
      `notification_log`), stat-card "View ›" links, filter tile, avatar tap
- [ ] Migrate `assets.metadata` category/location hack to real
      `category_id`/`location_id` FKs + backfill
- [ ] Decisions: WhatsApp reminders channel (not in schema — add or cut);
      "Active Invoices" stat-card semantics (assets vs documents count)
