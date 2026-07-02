# Release TODO — DocsBuddy internal testing

Status of what's needed to ship a Play **internal testing** build.
`[x]` = done in the repo · `[ ]` = your action (account/keys/hosting).

> ⚠️ **Scope reality check.** The core product is built: onboarding → auth →
> families → dashboard, assets & reminders, documents, and notifications (see
> §G). What's still missing vs the design handoff — rooms, appliance picker,
> profile, security/2FA, asset photos — is tracked in **§H** and
> `docs/design-gap.md`. Decide if that's acceptable for testers to see.

## A. Backend (Supabase)
- [x] Schema + RLS + RPCs (`supabase/migrations/` — 10 feature-based files)
- [x] App wiring (activates when `SUPABASE_URL` + `SUPABASE_ANON_KEY` are set)
- [ ] Create the project; copy URL + anon key
- [ ] Run the migrations: paste **`supabase/all_migrations.sql`** (the 10
      feature-based files combined, generated) into the SQL editor once on a
      fresh project — or apply `supabase/migrations/0*.sql` in order
- [ ] Auth → Providers: enable **Email** (+ **Email OTP** length 6 for reset)
- [ ] Auth → URL Configuration: **Site URL** = `https://docsbuddy.mytechbytes.in`;
      **Redirect URLs** += `https://docsbuddy.mytechbytes.in/login-callback`
      **and** `in.mytechbytes.docsbuddy://login-callback`
- [ ] (Optional) Google/Apple OAuth providers + their redirect URLs
- [ ] WhatsApp reminders: deploy `send-reminders-whatsapp`, set
      `WHATSAPP_ACCESS_TOKEN` + `WHATSAPP_PHONE_NUMBER_ID` (+ optional
      template) secrets, schedule the daily cron — see the function README
- [ ] Email reminders: deploy `send-reminders-email`, set `RESEND_API_KEY`
      + `EMAIL_FROM` secrets, schedule the daily cron — see the README

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

### Data layer (schema already had the columns) — **phase 1 done**
- [x] A1 `Asset`: `serial_no, purchase_date, purchase_price, store,
      image_url, location_id` surfaced + model/serial/purchase/store inputs
      on Add asset
- [x] A2 Asset photos: upload to `docsbuddy-files` (path on
      `assets.image_url`, signed at render); picker on Add asset +
      change-photo on detail; thumbnails on dashboard, asset list, detail
      (room cards land with Rooms)
- [x] A3 Per-reminder `notify_offsets`: model + repos, real values rendered
      on rows/banner, scheduler uses per-service offsets (offsets-chips
      editor ships with the Add-reminder page rework)
- [x] A4 Category catalog: `0005_seed_categories.sql` seeds 19 types with
      default services; asset create auto-seeds them (AMC date overrides);
      explicit `asset_dates.kind`; `metadata.category` backfilled →
      `category_id` FK
- [x] A5 Profile data: `ProfileRepository` + avatar upload + timezone sync
- [x] A6 Real locations: `public.locations` backs `locations()` with counts /
      kind / hierarchy; find-or-create on asset save; `0006` backfills the
      old `metadata.location` shortcut into FKs
- [x] A7 `NotificationPrefsRepository` + provider (channels, default offsets,
      quiet hours)
- [x] A7b Prefs wired: Settings toggles (Push/Email/WhatsApp) +
      default-offsets editor; new reminders use the preferred offsets
- [x] A8 Service layer: `asset_dates` surfaced as the Service entity with
      per-service offsets and provider / policy no. / cost / notes
      (**`0006_service_fields.sql`**); add-reminder sheet collects them;
      documents carry `asset_date_id`; "Mark as done" wires
      `complete_asset_date()` roll-forward
- [ ] A8b Per-service document grouping on asset detail + attach-document in
      the reminder flow

### Pending — screens
- [x] 02 Rooms (add-room composer, photo cards + upload, asset counts,
      Rooms tab)
- [x] 03 Room detail (hero photo + change, rename, appliance grid with day
      pills, "Add here" flow)
- [x] 04 Asset list polish (in-page search bar, photo thumbnails, type chips)
- [x] 05 Appliance picker (searchable catalog list → add-asset)
- [x] 06 Add appliance: type dropdown, model/serial/purchase/store, photo,
      AMC date → seeds service, invoice attach (file); camera capture pending
- [x] 08 Add reminder → full page: type tile grid, "in N days" helper,
      offsets chips (pref-defaults), service-scoped attach document,
      family-push note
- [x] 14 Profile (avatar edit + upload, Verified badge, stats row, family
      card + invite, edit-info sheet)
- [x] 15 Settings restyle: Account / Notifications / Family / App sections
      (Security & 2FA row placeholder until screen 17)
- [x] 16 Change password screen (re-auth verify, strength meter)
- [x] 17 Security: 2FA TOTP (QR + verify) with AAL2 step-up on sign-in,
      biometric unlock, app lock/auto-lock with lock screen, sign-out other
      devices (recovery codes cut — account recovery is password reset)

### Pending — wiring & debt
- [x] Wire decorative UI: search page, notification inbox (offset-window
      derived; dot only when overdue), stat-card "View ›" deep links,
      reminder-type filter sheet, avatar bound to `avatar_url` + tap →
      Profile
- [x] Migrate `assets.metadata` **location** to real `locations` rows +
      `location_id` FK with backfill (`0006_service_fields.sql`)
- [ ] Migrate `assets.metadata` **category** to the `category_id` FK when the
      catalog is seeded (with A4)
- [x] WhatsApp reminders channel: `0007_whatsapp_channel.sql` +
      `send-reminders-whatsapp` Edge Function (Meta Cloud API, log-deduped);
      **you:** deploy + `WHATSAPP_ACCESS_TOKEN`/`WHATSAPP_PHONE_NUMBER_ID`
      secrets + daily cron (see the function README). Settings toggle = A7b
- [x] Dashboard stats: all tiles count services (Active Services / Secured /
      Expiring Soon / Expired) + full-width Total Active Appliances card
