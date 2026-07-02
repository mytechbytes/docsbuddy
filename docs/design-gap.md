# Design ↔ Code Gap — Summary & Action Plan

Screenshot-by-screenshot review of the design handoff (`design/screenshots/*`,
21 screens) against the built app (`lib/features/**`), plus the backing schema
(`supabase/migrations/*`). Replaces the earlier checklist. `[x]` = done ·
`[ ]` = pending. All pending items are mirrored in
`docs/release-todo.md` §H (the main release plan) and the in-app
"What's pending" page.

---

## Summary

**Scorecard: 11 of 21 screens done, 4 partial, 6 missing.**

- **Done** — 00a–d Onboarding, 01 Dashboard, 07 Asset detail, 09–13 Auth
  (sign-in/up incl. Google/Apple, forgot, OTP, reset). Minor deltas remain
  (photos, real notify-offsets, serial in header — tracked below).
- **Partial** — 04 Asset list, 06 Add appliance, 08 Add reminder, 15 Settings.
- **Missing** — 02 Rooms, 03 Room detail, 05 Appliance picker, 14 Profile,
  16 Change password, 17 Security/2FA.

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
| 02 | Rooms | ❌ Missing | Whole screen: add-room composer, photo cards, "N Registered", entry point |
| 03 | Room detail | ❌ Missing | Whole screen: hero photo, edit room, summary line, appliance grid |
| 04 | Asset list | 🟡 Partial | No in-page search; icon tiles instead of photos; header + chip styling |
| 05 | Appliance picker | ❌ Missing | Whole screen: searchable category list feeding add-asset |
| 06 | Add appliance | 🟡 Partial | No model no., purchase date/price, serial, store, AMC date, invoice capture, validation |
| 07 | Asset detail | ✅ Done | Photo, serial in header, real offsets on banner/rows, Documents "View all" |
| 08 | Add reminder | 🟡 Partial | Bottom sheet vs full page; no offsets chips, attach-document, "in N days", family note |
| 09–13 | Auth flows | ✅ Done | Biometric quick-unlock button on sign-in (needs 17) |
| 14 | Profile | ❌ Missing | Whole screen: avatar edit, stats, family card, menu rows |
| 15 | Settings | 🟡 Partial | Dev page today; needs Account/Notifications/Family sections, prefs wiring |
| 16 | Change password | ❌ Missing | Screen only — `updatePassword` repo method already exists |
| 17 | Security / 2FA | ❌ Missing | TOTP enrollment + biometrics, app lock, recovery codes, sessions |

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
- [ ] `uploadAssetImage(assetId, file)` → `docsbuddy-files` bucket → `assets.image_url` (reuse `SupabaseDocumentRepository` pattern; RLS in `0004_storage.sql`)
- [ ] Image picker in add/edit asset
- [ ] Render `Image.network` (category-icon fallback) in dashboard rows, asset list, asset-detail header, room cards

**A3. `Reminder.notifyOffsets` — hardcoded in UI [schema ✓]**
`asset_dates.notify_offsets int[]` exists per reminder; UI prints a static
"30 · 7 · 1d" and the scheduler uses a global `[30,7,1,0]`.
- [x] Add `List<int> notifyOffsets` to `Reminder` + map in both repos
- [x] Render real values on asset-detail rows + NEXT DUE banner ("Reminded 30/7/1")
- [ ] Multi-select offsets chips (60/30/14/7/3/1d) in the add/edit-reminder UI
- [x] Feed them into `NotificationService.buildAlerts` instead of the constant

**A4. Asset-category catalog (`asset_categories`) [schema ✓ table / new seed]**
- [ ] `CatalogTypesRepository.categories()` reading `asset_categories`
- [ ] On asset create, expand `default_dates` → `asset_dates` rows
- [ ] Seed the table (**new** `0005_seed_categories.sql`)
- [ ] Derive `ReminderKind` from the catalog (replaces fragile `_kindFromLabel`)

**A5. User profile (`users`) [schema ✓]**
- [ ] `ProfileRepository` (get/update `users`, avatar upload) + `profileProvider`
- [ ] Replace the decorative avatar with real `avatar_url`
- [ ] Feed `timezone` into notification scheduling

**A6. Locations backed by the real table [schema ✓]**
- [x] Back `locations()` with `public.locations` (not metadata grouping)
- [x] `createLocation/updateLocation` (name; find-or-create on asset save); store `location_id` on assets — photo upload lands with A2
- [x] Expose `kind`, `image_url`, `parent_id` (room-within-home hierarchy)

**A7. Notification preferences (`notification_prefs`) — unwired [schema ✓] *(new)***
- [x] `NotificationPrefsRepository` (get/update channels, `default_offsets`, quiet hours)
- [ ] Back the Settings toggles (Push / Email) + "Default offsets" row with it
- [ ] Use `default_offsets` as the pre-selected chips on Add reminder

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

- [ ] **02 Rooms** — `RoomsPage` over real `locations`: "Add a new room" composer, photo cards, "N Registered" counts; add tab/entry point (A2/A6)
- [ ] **03 Room detail** — `RoomDetailPage(locationId)`: hero photo, edit-room, "managing N appliances" line, appliance grid with day pills, add-asset-here
- [ ] **05 Appliance picker** — searchable category grid feeding add-asset (A4)
- [ ] **06 Add appliance** *(partial)* — model no., serial, purchase date/price, store, AMC date (seeds an AMC reminder), invoice capture (file/camera → document), photo, required-field validation (A1/A2)
- [ ] **08 Add reminder** *(partial)* — promote sheet to full page: type tile grid, "in N days" helper, offsets chips, attach-document row (service-scoped via `asset_date_id`, A8), family-push note (A3/A7)
- [ ] **14 Profile** — avatar + camera edit, name/email + Verified badge, stats row (assets/reminders/documents), family card + Invite, menu rows (A5)
- [ ] **16 Change password** — current/new/confirm + strength meter + "signs out other devices" note; `SupabaseAuthRepository.updatePassword` already exists — wire from Settings
- [ ] **17 Security / 2FA** — GoTrue MFA/TOTP (`auth.mfa.enroll/challenge/verify`) with QR + copy key; biometric login toggles (needs `local_auth`); app lock + auto-lock; recovery codes; active sessions; biometric quick-unlock on sign-in. **Largest single item**
- [ ] **04 Asset list** *(partial)* — in-page search bar, photo thumbnails (A2), header + chip styling per design
- [ ] **15 Settings** *(partial)* — Account section (Personal info, Email, Change password, Security & 2FA), Notifications section (toggles + Default offsets via A7), Family section (manage + member count)
- [x] **00a–d Onboarding** — carousel implemented
- [x] **01 Dashboard** — redesigned to match handoff
- [x] **07 Asset detail** — redesigned to match handoff
- [x] **09–13 Auth** — sign-in/up (incl. Google/Apple), forgot, OTP, reset

### C. Decorative UI to wire (renders, no-op today)

- [ ] **Search icon** (dashboard) → asset/reminder search + `SearchPage`
- [ ] **Notification bell / red dot** → notifications inbox (drive from `notification_log`) or drop the dot until built
- [ ] **Stat-card "View ›"** → deep-link to a filtered list (e.g. Expired → overdue)
- [ ] **Filter tile** on Upcoming → filter sheet
- [ ] **Avatar** → bind to `users.avatar_url` (A5); tap → Profile

### D. Backend debt

- [x] **Metadata hack (location half)** — `location` migrated from `assets.metadata` to real `locations` rows + `location_id` FK with a one-time backfill (`0006_service_fields.sql`); the repo no longer writes it
- [ ] **Metadata hack (category half)** — migrate `category` to the `category_id` FK once the catalog is seeded (A4, `0005_seed_categories.sql`)
- [ ] **`_kindFromLabel` inference** — derive kind from the catalog once A4 lands

### E. Open design decisions *(new)*

- [ ] **WhatsApp reminders** toggle (15) — channel not in schema (`push | local | email`); add the channel + a sender, or cut from v1
- [ ] **"Active Invoices" stat card** (01) — impl counts assets; decide semantics (documents/invoices count?) and wire accordingly
- [ ] **Dashboard reminder rows** — adopt design's photo + category subtitle once A1/A2 land

---

## Suggested sequencing (dependency + value)

1. [x] **Model + repo widening** (A1, A3, A6, A7, A8 service layer) + metadata→FK debt (D, location half — category half moves with step 3) — **done**
2. [ ] **Asset photos** (A2) — biggest visual gap, self-contained
3. [ ] **Category catalog + appliance picker + auto-seed reminders** (A4, B-05, B-06) — high product value
4. [ ] **Rooms + Room detail** (A6, B-02/03)
5. [ ] **Profile + Change password + Settings restyle** (A5, B-14/15/16)
6. [ ] **Add-reminder full page + wire decorative UI** (B-08, C)
7. [ ] **2FA / security** (B-17) — largest, do last

**Net:** almost none of this needs new tables — the schema was built ahead of
the UI. The work is Dart models → repository mapping → screens, two small
migrations (`0005_seed_categories.sql`, `0006_service_fields.sql`), the
`notification_prefs` wiring and fixing the `metadata` shortcut.
