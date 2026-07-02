# Design ↔ Code Gap — Summary & Action Plan

Screenshot-by-screenshot review of the design handoff (`design/screenshots/*`,
21 screens) against the built app (`lib/features/**`), plus the backing schema
(`supabase/migrations/*`). Replaces the earlier checklist. `[x]` = done ·
`[ ]` = pending. All pending items are mirrored in
`docs/release-todo.md` §H (the main release plan) and the in-app
"What's pending" page.

---

## Summary

**Scorecard: 21 of 21 screens done — the gap plan is complete.** All seven
sequencing phases shipped (data layer & services, photos, category catalog,
rooms, profile/settings/password, reminder page + wiring, security). The few
deliberate deferrals are listed under "Remaining polish" at the bottom.

**Root cause:** the Postgres schema already models ~90% of what the designs
need — the gap is almost entirely in the **Dart layer** (domain models →
repository mapping → UI expose only a thin slice of existing columns). Most
items need **no migration**. Known debt: `SupabaseCatalogRepository` stores
`category`/`location` in `assets.metadata` JSONB instead of the real
`category_id`/`location_id` FKs.

**New findings from this screenshot pass** (not in the earlier checklist):

1. **04 Asset list** — design has an in-page search bar ("Search Your
   Appliance"), back-arrow + centered-logo header, photo thumbnails and the
   category chip under the name; impl is a plain "Assets" AppBar list with
   icon tiles and a trailing chip.
2. **06 Add appliance** — the form never collects **model number**
   (`Asset.model` exists but `addAsset(...)` has no input for it), and the
   design also requires **purchase date**, an **AMC date** (which should seed
   an AMC reminder) and **"Add Invoice"** (file/camera capture → document
   upload during creation) with required-field validation.
3. **07 Asset detail** — header meta shows the registration/serial number
   ("TN 01 AB 1234" → `assets.serial_no`); the NEXT DUE banner and each
   reminder row show **per-reminder** notify offsets (impl hardcodes
   "30 · 7 · 1d"); Documents header shows a count with a **"View all"** link.
4. **08 Add reminder** — design is a **full page** with a 2×4 reminder-type
   tile grid, an "in N days" helper beside the due date, **multi-select
   notify-offset chips** (60/30/14/7/3/1 days before), an "Attach document"
   row and a "push to all family members" note; impl is a compact bottom
   sheet with none of those.
5. **09 Sign-in** — design shows a **biometric quick-unlock** button beside
   Sign In; not implemented (pairs with screen 17 biometrics).
6. **15 Settings** — `notification_prefs` (channels, `default_offsets`,
   quiet hours) exists in the schema but is **completely unwired** in Dart;
   it backs the design's Push/Email toggles and "Default offsets" row. The
   design also shows a **WhatsApp reminders** toggle — that channel is not in
   the schema's `push | local | email` set (decision needed).
7. **17 Security** — beyond GoTrue TOTP the design includes biometric-login
   toggles (Face ID / fingerprint — needs `local_auth`, not in pubspec),
   recovery codes, app lock with auto-lock timeout, and an active-sessions
   list.
8. **01 Dashboard** — design's first stat card is "Active **Invoices**"
   (document icon); impl counts **assets**. Design reminder rows show the
   asset photo and a category subtitle ("Vehicles"); impl shows the
   kind-icon bubble and label · date.
9. **02/03 Rooms** — design details: inline "Add a new room" composer row,
   photo cards with "N Registered" counts; room detail has a hero photo,
   edit-pencil, "managing N appliances" summary line and an appliance grid
   with day pills.
10. **14 Profile** — stats row (assets / reminders / documents counts),
    "Verified" badge, family card with member avatars and an Invite button.
11. **Missing middle layer — Services.** The product model is
    **appliance → service → reminders + documents**: an appliance carries
    services (AMC, insurance, pollution, road tax, fitness…), each service has
    its own reminder schedule, and documents attach to the appliance **and**
    to individual services (design 08 attaches "Insurance policy, receipt,
    photo…" to a reminder). The schema already models this — `asset_dates`
    **is** the service row (own label, recurrence, per-service
    `notify_offsets`, `complete_asset_date()` roll-forward) and
    `documents.asset_date_id` links a document to a service — but the Dart
    layer collapses it: `Reminder` is treated as a bare date and
    `DocumentMeta` has no `assetDateId`, so documents can only attach at the
    appliance level and services have no detail view.

---

## Screen-by-screen status

| # | Screen | Status | Gap vs design |
|---|--------|--------|---------------|
| 00a–d | Onboarding carousel | ✅ Done | — |
| 01 | Dashboard | ✅ Done | "Active Invoices" card counts assets not invoices; rows lack photo + category subtitle; search/bell/filter/View› decorative |
| 02 | Rooms | ✅ Done | — |
| 03 | Room detail | ✅ Done | — |
| 04 | Asset list | ✅ Done | — |
| 05 | Appliance picker | ✅ Done | — |
| 06 | Add appliance | ✅ Done | Camera capture for invoices/photos pending (`image_picker`) |
| 07 | Asset detail | ✅ Done | Photo, serial in header, real offsets on banner/rows, Documents "View all" |
| 08 | Add reminder | ✅ Done | — |
| 09–13 | Auth flows | ✅ Done | Biometric quick-unlock button on sign-in (needs 17) |
| 14 | Profile | ✅ Done | — |
| 15 | Settings | ✅ Done | Security & 2FA row is a placeholder until screen 17 |
| 16 | Change password | ✅ Done | — |
| 17 | Security / 2FA | ✅ Done | Recovery-code *login path* needs a server function (codes generate/store today) |

---

## Action items

Legend: **[schema ✓]** column/table already exists · **[new]** needs a
migration/backend addition.

### A. Data layer — surface existing columns

**A1. `Asset` — 7 dropped fields [schema ✓]**
`public.assets` has `serial_no, purchase_date, purchase_price, store,
image_url, location_id, category_id`; Dart `Asset` carries only
`id, name, category, locationName, brand, model`.
- [x] Add `serialNo, purchaseDate, purchasePrice, store, imageUrl, locationId` to `Asset` (`catalog_models.dart`)
- [x] Widen the `select` + map real columns in `supabase_catalog_repository.dart`
- [x] Extend the seed in `fake_catalog_repository.dart`
- [x] Extend `addAsset(...)` on the interface + both impls (incl. **model** — currently not passable)
- [x] Add inputs (model no., serial, purchase date/price, store) to `add_asset_page.dart`

**A2. Asset photo (`image_url`) — biggest visual gap [schema ✓]**
- [x] `setAssetImage(assetId, …)` → `docsbuddy-files` bucket → stores the bucket path on `assets.image_url`; `resolveImageUrl` signs it at render time (private bucket, RLS in `0004_storage.sql`); replaced photos are cleaned up
- [x] Image picker on Add asset (preview box) + change-photo on the asset-detail header (camera badge)
- [x] `AssetThumb` renders the photo (icon fallback) in dashboard rows, asset list, asset-detail header — room cards land with B-02

**A3. `Reminder.notifyOffsets` — hardcoded in UI [schema ✓]**
`asset_dates.notify_offsets int[]` exists per reminder; UI prints a static
"30 · 7 · 1d" and the scheduler uses a global `[30,7,1,0]`.
- [x] Add `List<int> notifyOffsets` to `Reminder` + map in both repos
- [x] Render real values on asset-detail rows + NEXT DUE banner ("Reminded 30/7/1")
- [x] Multi-select offsets chips (60/30/14/7/3/1d) on the Add-reminder page, pre-filled from prefs
- [x] Feed them into `NotificationService.buildAlerts` instead of the constant

**A4. Asset-category catalog (`asset_categories`) [schema ✓ table / new seed]**
- [x] `categories()` on `CatalogRepository` reading `asset_categories` (fake mirrors the seed offline)
- [x] On asset create, expand `default_dates` → services (`expandDefaultReminders`: dues relative to purchase date, past recurrings roll forward, expired one-offs skipped, AMC date overrides)
- [x] Seed the table + backfill (`0005_seed_categories.sql`: 5 generic groups + 14 specific types)
- [x] Explicit `asset_dates.kind` written at create (label inference is now only the fallback for old rows — retires fragile `_kindFromLabel`)

**A5. User profile (`users`) [schema ✓]**
- [x] `ProfileRepository` (get/update `users`, avatar upload to the family bucket folder) + `profileProvider` / `profileStatsProvider`
- [x] Real `avatar_url` rendered on the Profile screen (dashboard header avatar binds with the C-wiring pass)
- [x] Device `timezone` synced to `users.timezone` on profile load (for server-side scheduling)

**A6. Locations backed by the real table [schema ✓]**
- [x] Back `locations()` with `public.locations` (not metadata grouping)
- [x] `createLocation/updateLocation` (name; find-or-create on asset save); store `location_id` on assets — photo upload lands with A2
- [x] Expose `kind`, `image_url`, `parent_id` (room-within-home hierarchy)

**A7. Notification preferences (`notification_prefs`) — unwired [schema ✓] *(new)***
- [x] `NotificationPrefsRepository` (get/update channels, `default_offsets`, quiet hours)
- [x] Settings toggles (Push / Email / WhatsApp) + "Default offsets" chips editor backed by it
- [x] `default_offsets` used as the defaults for newly created reminders

**A8. Service layer — appliance → service → reminders + documents [schema ✓] *(new)***
`asset_dates` already is the service entity (label, recurrence, per-service
`notify_offsets`, `complete_asset_date()` roll-forward) and
`documents.asset_date_id` already scopes a document to a service; none of it
is surfaced in Dart.
- [x] Reframe/extend the Dart `Reminder` as the **Service** entity mapping `asset_dates` 1:1 (service kind, label, schedule) — reminders are its `notify_offsets` (A3)
- [x] Add `assetDateId` to `DocumentMeta`; map `asset_date_id` in `supabase_document_repository.dart`; accept it in `uploadDocument(...)`
- [ ] Asset detail: documents grouped per service (service row → its documents) in addition to the appliance-level Documents section
- [ ] Attach-document in add/edit reminder writes `asset_date_id` (pairs with B-08)
- [x] Service completion: wire `complete_asset_date()` ("Mark as done" on the service row → rolls due date forward per recurrence)
- [x] **[new]** Richer service fields — **decided: in scope for v1.** Migration
      `0006_service_fields.sql` adds `provider text, policy_no text,
      cost numeric(12,2), notes text` to `asset_dates`; mapped on the Dart
      model + both repos; provider/policy-no./cost/notes inputs on the
      add-reminder sheet; provider + policy no. shown on the service row
      (cost display lands with the service-detail view)

### B. Screens

- [x] **02 Rooms** — `RoomsPage` over real `locations`: "Add a new room" composer, photo cards (upload via `setLocationImage`), "N Registered" counts, Rooms tab in the bottom nav (A2/A6)
- [x] **03 Room detail** — `RoomDetailPage(locationId)`: hero photo (tap to change), rename dialog, "managing N appliances" line, 3-column appliance grid with day pills, "Add here" → picker with the room pre-filled
- [x] **05 Appliance picker** — searchable catalog list feeding add-asset, with a "Something else" escape hatch (A4)
- [x] **06 Add appliance** — type dropdown (catalog), model/serial/purchase/store (A1), photo (A2), AMC date (seeds/overrides the AMC service), invoice attach (file → invoice document), auto-seed note; *camera capture still pending (needs `image_picker`)*
- [x] **08 Add reminder** — full page: 4-across type tile grid, due date with "in N days" helper, repeat chips, multi-select offsets chips pre-filled from prefs, service details, service-scoped attach-document (uploads with `asset_date_id`), family-push note (A3/A7/A8)
- [x] **14 Profile** — avatar + camera edit (upload), name/email + Verified badge, stats row (assets/reminders/documents), family card with member avatars + Invite, edit-info sheet (name + WhatsApp phone), menu rows (A5)
- [x] **16 Change password** — current password verified by re-auth, strength meter (Weak→Excellent), confirm match, other-devices note; wired from Settings and Profile
- [x] **17 Security / 2FA** — GoTrue MFA/TOTP enroll → QR (`qr_flutter`) + copy key → challenge/verify, disable with confirm; biometric unlock toggle (`local_auth`, device-credential fallback; FragmentActivity + USE_BIOMETRIC + NSFaceIDUsageDescription wired); app lock + auto-lock (1/5/15 min) enforced by a lock screen on launch/resume — this is the biometric quick-unlock surface; recovery codes (generated client-side, hashes stored in user metadata — *sign-in-with-recovery-code needs a server function later*); active-sessions sheet with "Sign out other devices" (GoTrue scope)
- [x] **04 Asset list** — in-page "Search Your Appliance" bar, photo thumbnails (A2), specific-type chips
- [x] **15 Settings** — Account (Personal info → Profile, Email, Change password, Security & 2FA with live On/Off state), Notifications (Push/Email/WhatsApp toggles + Default-offsets editor via A7), Family (manage + member count), App utilities, Sign out
- [x] **00a–d Onboarding** — carousel implemented
- [x] **01 Dashboard** — redesigned to match handoff
- [x] **07 Asset detail** — redesigned to match handoff
- [x] **09–13 Auth** — sign-in/up (incl. Google/Apple), forgot, OTP, reset

### C. Decorative UI to wire — **all wired**

- [x] **Search icon** → `SearchPage` (assets by name/brand/model/serial/type/room; services by label/provider/policy no.)
- [x] **Notification bell / red dot** → notifications inbox (overdue + inside-offset-window alerts derived from each reminder's own offsets); the dot now shows only when something is overdue
- [x] **Stat-card "View ›"** → `/reminders/:filter` deep links (Active / Secured / Expiring Soon / Expired)
- [x] **Filter tile** on Upcoming → reminder-type filter sheet (chip multi-select; tile highlights when active)
- [x] **Avatar** → bound to `users.avatar_url` on dashboard + asset detail; tap → Profile

### D. Backend debt

- [x] **Metadata hack (location half)** — `location` migrated from `assets.metadata` to real `locations` rows + `location_id` FK with a one-time backfill (`0006_service_fields.sql`); the repo no longer writes it
- [x] **Metadata hack (category half)** — `0005` backfills `metadata.category` → `category_id` (via the generic group rows) and the repo now writes the FK; metadata is only the fallback when the catalog isn't seeded
- [x] **`_kindFromLabel` inference** — kind is stored on `asset_dates.kind`; label matching remains only as the read fallback for pre-0005 rows

### E. Design decisions *(resolved)*

- [x] **WhatsApp reminders** — **decided: in scope.** `whatsapp` documented as a
      channel value (`0007_whatsapp_channel.sql`); new cron-driven
      `send-reminders-whatsapp` Edge Function sends via the Meta WhatsApp
      Cloud API to opted-in members' `users.phone`, deduped through
      `notification_log`. Deploy + secrets + cron are a setup step
      (`docs/release-todo.md` §A); the Settings toggle ships with A7b/screen 15
- [x] **Dashboard stat cards** — **decided: services-based.** All four tiles
      count services (Active Services / Secured / Expiring Soon / Expired) and
      a full-width **Total Active Appliances** card shows the asset count
- [ ] **Dashboard reminder rows** — adopt design's photo + category subtitle once A1/A2 land

---

## Suggested sequencing (dependency + value)

1. [x] **Model + repo widening** (A1, A3, A6, A7, A8 service layer) + metadata→FK debt (D, location half — category half moves with step 3) — **done**
2. [x] **Asset photos** (A2) — biggest visual gap, self-contained — **done**
3. [x] **Category catalog + appliance picker + auto-seed reminders** (A4, B-05, B-06) — **done** (camera capture deferred)
4. [x] **Rooms + Room detail** (A6, B-02/03) — **done**
5. [x] **Profile + Change password + Settings restyle** (A5, A7b, B-14/15/16) — **done**
6. [x] **Add-reminder full page + wire decorative UI** (B-08, B-04, C) — **done**
7. [x] **2FA / security** (B-17) — **done**

**Net:** the schema was built ahead of the UI, and the plan closed with only
three small migrations (`0005` seed+kind+backfill, `0006` service fields +
location backfill, `0007` whatsapp channel) — everything else was Dart
models → repository mapping → screens.

---

## Post-plan requirements audit (2026-07-02)

A verification pass over data ↔ screen connections after the plan closed:

- [x] **Fixed: co-members rendered as "Member" on the real backend** — the
      `users` RLS was `self read` only, so the family screen's profile join
      returned NULL for everyone but the caller. `0008_family_profile_visibility.sql`
      adds a security-definer `shares_family_with()` policy; member tiles now
      show the **profile photo, name and contact number** (and the Profile
      screen's family stack uses real avatars)

## Remaining polish (deliberate deferrals)

- [x] Per-service document grouping — the service-detail sheet lists the
      documents attached to that service (`asset_date_id`), alongside its
      cost and full record
- [x] Asset & service editing — edit/delete for assets (services and
      document rows cascade) and services (tombstoned for sync); the
      add pages double as edit forms
- [x] Family role management — admins change roles / remove members
      (owner protected; RLS already permitted it); member tiles get
      tap-to-call and WhatsApp actions on their contact number
- [x] Quiet hours — editor in Settings; the local scheduler shifts alerts
      landing inside the window to its end (`applyQuietHours`, tested)
- [x] Email reminders sender — `send-reminders-email` Edge Function
      (Resend API, log-deduped) backs the Settings toggle
- [x] AAL2 step-up — sessions with an enrolled authenticator must pass the
      TOTP challenge screen before the app opens
- [x] Room reordering — long-press-drag on the Rooms tab persists
      `locations.sort_order` (nesting via `parent_id` still deferred)
- [x] Phone validation — profile phone is validated/normalized to E.164
      before saving (WhatsApp delivery requires it)
- [ ] Camera capture for invoices/photos (`image_picker` + iOS plist)
- [ ] Sign-in with a recovery code (server function to check the stored
      hashes; codes generate and persist today)
- [ ] Dashboard reminder rows: category subtitle per design (photo already
      shown)
- [ ] Room nesting UI (`locations.parent_id` is modeled; reordering shipped)
