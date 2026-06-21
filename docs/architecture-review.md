# DocsBuddy — Architecture Review

Review of `docs/DocsBuddy_Architecture.html` (v1.0). Recommendations are grouped
by severity. Every item marked **[applied]** has a concrete implementation in
`supabase/migrations/0001_init.sql` and/or an inline correction in the
architecture HTML.

The architecture is strong overall: family-scoped multi-tenancy with RLS as the
security boundary, category-schema JSONB for flexible asset metadata,
direct-to-Storage uploads with short-lived signed URLs, recursive-CTE tree
queries, and a sensible Riverpod / go_router / drift / secure-storage stack. The
items below are corrections and hardening, not a redesign.

> **Mode note.** The doc ships two notification modes and currently defaults to
> **local-first**. Items tagged _(mode)_ are specific to that choice.

---

## 🔴 Critical — would break or silently misbehave as written

### 1. Nothing updated `updated_at`, but sync depends on it — **[applied]**
`updated_at timestamptz default now()` only fires on INSERT. Delta sync
("rows where `updated_at > last_sync`") would miss every edit. Added
`moddatetime` triggers on all mutable tables.

### 2. RLS helper would infinite-recurse — **[applied]**
`is_family_member()` reads `family_members`; with RLS enabled on that table the
helper re-evaluates under RLS and recurses ("stack depth exceeded"). Marked the
function `security definer` with a pinned `search_path` so its read bypasses RLS
deterministically.

### 3. RLS write policy contradicted the permission matrix — **[applied]**
The matrix says a **Member can delete only their own assets**, but `for all
using is_family_member(...,'member')` let any member delete anything. Split into
explicit `select / insert / update / delete` policies; the delete policy is
`is_family_member(family_id,'admin') OR (member AND created_by = auth.uid())`.

### 4. Local-first merge referenced a non-existent field — **[applied]** _(mode)_
The merge function read `field_versions[field]` but the row model only had a
scalar `version`. Per-field LWW is impossible with a per-row version. Added a
`field_versions jsonb` column to synced tables (`asset_dates`, `documents`) and
to the Drift model in the doc, so per-field last-write-wins is actually
representable.

### 5. Sync engine under-specified where it's hardest — **[applied]** _(mode)_
`outbox` and the `last_sync` cursor were referenced but never defined, and a
per-table delta pull would violate FKs. Added a `sync_state` cursor table and
documented **dependency-ordered apply** (families → locations → assets →
asset_dates → documents). Tombstone columns (`deleted_at`) added where missing.

---

## 🟠 Strong recommendations

### 6. Prefer a hybrid over pure local-first — **[applied: doc]** _(mode)_
On iOS, `BGTaskScheduler` refills and silent `content-available` pushes are
throttled/not guaranteed, so a reminder months out on a rarely-opened phone may
never fire. Keep local notifications for offline/immediacy, but keep the
**server cron as the guaranteed backstop** (dedup on the client). Documented as
the recommended default in the HTML.

### 7. Replace `last_notified_offset` scalar with a log table — **[applied]**
A scalar can't represent "fired 7-day but not 1-day," breaks when `due_date` is
edited, and can't dedup per channel/device. Added `notification_log
(asset_date_id, offset_days, channel, sent_at)` with a composite PK.

### 8. Define the recurrence engine — **[applied]**
Nothing said how the next occurrence is created on completion. Added a
`complete_asset_date()` RPC that rolls `due_date` forward by the recurrence step
and clears the notification log (one-offs just set `completed_at`).

### 9. supabase_flutter persists the session insecurely by default — **[applied: doc]**
The SDK stores the refresh token in SharedPreferences out of the box. Must
inject a `flutter_secure_storage`-backed `LocalStorage` into
`Supabase.initialize(...)`. Called out explicitly in §1.3.

### 10. Auto-provision `public.users` — **[applied]**
Added the standard `handle_new_user()` trigger on `auth.users` insert.

### 11. Prefer Supabase Realtime over silent-FCM when online — **[applied: doc]** _(mode)_
Use Realtime for foreground cross-device sync; reserve FCM strictly for
backgrounded/killed apps.

---

## 🟡 Moderate / polish

- **Active-family context** — users can belong to multiple families; app needs a
  current-family selector and all queries scoped to it. _(doc)_
- **Invite codes** — 6-char codes are enumerable. **[applied]** now a 32-hex
  random token; `accept_invite()` RPC validates expiry/used atomically.
- **Email channel** — declared in prefs but unwired in the worker. Implement or
  drop. _(doc)_
- **Android exact alarms** — `exactAllowWhileIdle` needs `SCHEDULE_EXACT_ALARM`
  (Android 13+) with runtime handling + Play policy justification. _(doc)_
- **E2E encryption** — half-specified (no key-management story). Recommend
  cutting from v1 or specifying fully. _(doc)_
- **Storage RLS cast** — `(...)[1]::uuid` throws on non-UUID keys. **[applied]**
  guarded with a regex check before the cast.
- **Observability / CI** — add Sentry or Crashlytics and a basic analyze+test CI;
  note `build_runner` codegen for riverpod/drift/freezed. _(doc)_

---

## Keep as-is (good)
Family-scoped `family_id` tenancy + RLS boundary; category-schema JSONB; direct
Storage uploads with short signed URLs and never proxying bytes; recursive-CTE
tree queries; the mobile stack; and the auth → schema → families → assets →
docs → notifications shipping order.
