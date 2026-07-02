# Design ↔ Implementation gap checklist

Tracks the distance between the design handoff (`design/screenshots/*`) and the
app. `[x]` = done · `[ ]` = to do.

> **Root cause:** the Postgres schema (`supabase/migrations/0001_init.sql`)
> already models ~90% of what the designs need. The gap is almost entirely in
> the **Dart layer** — domain models → repository mapping → UI expose only a
> thin slice of the existing columns. Most items below need **no migration**.
> One piece of debt: `SupabaseCatalogRepository` stores `category`/`location` in
> the `assets.metadata` JSONB instead of the real `category_id`/`location_id`
> FKs.

Legend: **[schema ✓]** the column/table already exists · **[new]** needs a
migration or backend addition.

---

## A. Data-model gaps (surface existing columns)

### A1. `Asset` — 7 dropped fields  [schema ✓]
`public.assets` has `serial_no, purchase_date, purchase_price, store,
image_url, location_id, category_id, metadata`; Dart `Asset` has only
`id, name, category, locationName, brand, model` and the repo selects
`id, name, brand, model, metadata`.
- [ ] Add `serialNo, purchaseDate, purchasePrice, store, imageUrl, locationId` to `Asset` (`catalog_models.dart`)
- [ ] Widen the `select` + map real columns in `supabase_catalog_repository.dart`
- [ ] Extend the seed in `fake_catalog_repository.dart`
- [ ] Extend `addAsset(...)` on the interface + both impls
- [ ] Add inputs (serial, purchase date/price, store) to `add_asset_page.dart`

### A2. Asset photo (`image_url`) — biggest visual gap  [schema ✓]
Design rows/headers show a photo thumbnail; there's no upload/render path.
- [ ] `uploadAssetImage(assetId, file)` → `docsbuddy-files` bucket → store URL on `assets.image_url` (reuse `SupabaseDocumentRepository` pattern; RLS in `0004_storage.sql`)
- [ ] Image picker in add/edit asset
- [ ] Render `Image.network` (category-icon tile as fallback) in dashboard rows + asset-detail header + asset list

### A3. `Reminder.notifyOffsets` — hardcoded in UI  [schema ✓]
`asset_dates.notify_offsets int[] default '{30,7,1}'` exists per reminder; the
UI prints a static "30 · 7 · 1d" and the scheduler uses a global `[30,7,1,0]`.
- [ ] Add `List<int> notifyOffsets` to `Reminder` + map in both repos
- [ ] Render real values in the asset-detail row + NEXT DUE banner
- [ ] Offsets editor in the add/edit-reminder UI
- [ ] Feed them into `NotificationService.buildAlerts` instead of the constant

### A4. Asset-category catalog (`asset_categories`) — powers appliance picker  [schema ✓ table / new seed]
`asset_categories(slug, name, icon, default_dates jsonb, schema jsonb)` exists
but is unused; app uses the hardcoded `AssetCategoryKind` enum and seeds no
reminders.
- [ ] `CatalogTypesRepository.categories()` reading `asset_categories`
- [ ] On asset create, expand `default_dates` → `asset_dates` rows
- [ ] Seed the table (**new** `0005_seed_categories.sql`)
- [ ] Derive `ReminderKind` from the catalog (replaces fragile `_kindFromLabel`)

### A5. User profile (`users`) — not surfaced  [schema ✓]
`users` has `display_name, avatar_url, phone, locale, timezone, onboarded_at`;
no Dart profile model/repo/screen (only the auth session).
- [ ] `ProfileRepository` (get/update `users`, avatar upload)
- [ ] `profileProvider`
- [ ] Replace the decorative avatar with real `avatar_url`
- [ ] Feed `timezone` into notification scheduling

### A6. Locations are faked, not real  [schema ✓]
`public.locations` is a full table (`kind`, `parent_id` hierarchy, `image_url`,
`sort_order`), but Dart `Location` is derived by grouping
`asset.metadata.location` strings.
- [ ] Back `locations()` with the real table
- [ ] `createLocation/updateLocation`; store `location_id` on assets
- [ ] Expose `kind`, `image_url`, `parent_id` (room-within-home hierarchy)

---

## B. Missing / partial screens

- [ ] **02 Rooms** — `RoomsPage` over real `locations` (grid: image + asset count); add tab/entry
- [ ] **03 Room detail** — `RoomDetailPage(locationId)` → assets in room + add-asset-here
- [ ] **05 Appliance picker** — category-catalog grid feeding add-asset (needs A4)
- [ ] **06 Add appliance** *(partial)* — extend `add_asset_page` with serial, purchase date/price, store, photo (A1/A2)
- [ ] **08 Add reminder** *(partial)* — promote bottom sheet to a full page + offsets editor (A3)
- [ ] **14 Profile** — profile view/edit (A5)
- [ ] **16 Change password** — build screen; `SupabaseAuthRepository.updatePassword` already exists, just wire from Settings
- [ ] **17 Security / 2FA** — GoTrue MFA/TOTP (`auth.mfa.enroll/challenge/verify`) + enrollment UI; no schema change; **largest single item**
- [x] **01 Dashboard** — redesigned to match handoff
- [x] **07 Asset detail** — redesigned to match handoff
- [x] **09–13 Auth** (sign-in/up, forgot, OTP, reset) — implemented
- [ ] **04 Asset list** *(exists)* — verify styling vs design; add photo thumbnails (A2)
- [ ] **15 Settings** *(exists)* — restyle; add Profile / Change-password / Security rows

---

## C. Decorative UI to wire (renders, no-op today)

- [ ] **Search icon** → asset/reminder search + `SearchPage`
- [ ] **Notification bell / red dot** → notifications inbox (drive from `notification_log`) or drop the dot until built
- [ ] **Stat-card "View ›"** → deep-link to a filtered list (e.g. Expired → overdue)
- [ ] **Filter tile** on Upcoming → filter sheet
- [ ] **Avatar** → bind to `users.avatar_url` (A5); tap → Profile

---

## D. Backend debt to fix alongside

- [ ] **Metadata hack** — `SupabaseCatalogRepository` writes `category`/`location` into `assets.metadata` instead of `category_id`/`location_id` FKs. Migrate to FKs (A1/A4/A6) + one-time backfill for existing rows
- [ ] **`_kindFromLabel` inference** is fragile — derive kind from the catalog once A4 lands

---

## Suggested sequencing (dependency + value)

1. [ ] **Model + repo widening** (A1, A3, A6) + fix metadata→FK debt (D) — unblocks everything, low UI
2. [ ] **Asset photos** (A2) — biggest visual gap, self-contained
3. [ ] **Category catalog + appliance picker + auto-seed reminders** (A4, B-05) — high product value
4. [ ] **Rooms + Room detail** (A6, B-02/03)
5. [ ] **Profile + Change password** (A5, B-14/16) — mostly UI; repo methods largely exist
6. [ ] **Wire decorative UI** (C): search, stat-card links, filter
7. [ ] **2FA / security** (B-17) — largest, do last

**Net:** almost none of this needs new tables — the schema was built ahead of
the UI. The work is Dart models → repository mapping → screens, plus one seed
migration (categories) and fixing the `metadata` shortcut.
