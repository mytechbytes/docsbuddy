-- ============================================================================
-- DocsBuddy — ALL migrations combined (0001 → 0008)
--
-- One-shot setup script for the Supabase SQL editor: paste and run once on a
-- fresh project instead of applying migrations/ one by one.
--
-- GENERATED from supabase/migrations/*.sql — do not edit here; change the
-- individual migration and regenerate:
--   cat supabase/migrations/*.sql > supabase/all_migrations.sql  (plus header)
--
-- Safe to re-run only where the statements are idempotent (seeds use
-- ON CONFLICT; ALTERs use IF NOT EXISTS) — CREATE TABLE/POLICY statements
-- are not, so run it once on a clean database.
-- ============================================================================


-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0001_init.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- DocsBuddy — initial schema
--
-- This migration is the concrete, corrected implementation of the design in
-- docs/DocsBuddy_Architecture.html, with every fix from
-- docs/architecture-review.md applied. Recommendation numbers (Rec #N) below
-- map to that review.
-- ============================================================================

create extension if not exists "pgcrypto";   -- gen_random_uuid()
create extension if not exists moddatetime;  -- Rec #1: updated_at maintenance

-- ============================================================================
-- SECTION 1 — USERS
-- ============================================================================

create table public.users (
  id            uuid primary key references auth.users(id) on delete cascade,
  email         text not null unique,
  display_name  text,
  avatar_url    text,
  phone         text,
  locale        text default 'en',
  timezone      text default 'UTC',          -- used to schedule local-08:00 notifications
  onboarded_at  timestamptz,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- Rec #10: auto-provision a public.users row whenever an auth user is created.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, email, display_name, avatar_url)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

create table public.user_devices (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.users(id) on delete cascade,
  fcm_token     text not null,
  platform      text check (platform in ('ios','android')),
  app_version   text,
  last_seen_at  timestamptz default now(),
  unique (user_id, fcm_token)
);

-- ============================================================================
-- SECTION 3 — FAMILIES & RBAC  (defined before locations/assets for FK order)
-- ============================================================================

create table public.families (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  owner_id    uuid not null references public.users(id),
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

create type family_role as enum ('owner','admin','member','viewer');

create table public.family_members (
  family_id   uuid references public.families(id) on delete cascade,
  user_id     uuid references public.users(id) on delete cascade,
  role        family_role not null default 'member',
  joined_at   timestamptz default now(),
  primary key (family_id, user_id)
);
create index on public.family_members (user_id);

create table public.family_invites (
  id          uuid primary key default gen_random_uuid(),
  family_id   uuid references public.families(id) on delete cascade,
  email       text,
  -- Rec (moderate): 6-char codes are enumerable. Use a long random token.
  code        text unique not null default encode(gen_random_bytes(16), 'hex'),
  role        family_role default 'member',
  invited_by  uuid references public.users(id),
  expires_at  timestamptz default now() + interval '7 days',
  accepted_at timestamptz
);

-- Rec #2: SECURITY DEFINER + pinned search_path so the helper's own read of
-- family_members bypasses RLS deterministically and cannot recurse.
create or replace function public.is_family_member(fid uuid, min_role family_role default 'viewer')
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.family_members fm
    where fm.family_id = fid
      and fm.user_id = auth.uid()
      and case min_role
            when 'viewer' then true
            when 'member' then fm.role in ('owner','admin','member')
            when 'admin'  then fm.role in ('owner','admin')
            when 'owner'  then fm.role = 'owner'
          end
  );
$$;

-- ============================================================================
-- SECTION 2 — LOCATIONS, CATEGORIES, ASSETS, ASSET DATES
-- ============================================================================

create type location_kind as enum ('home','office','vehicle','room','shelf','custom');

create table public.locations (
  id          uuid primary key default gen_random_uuid(),
  family_id   uuid not null references public.families(id) on delete cascade,
  parent_id   uuid references public.locations(id) on delete cascade,
  name        text not null,
  kind        location_kind not null default 'custom',
  image_url   text,
  sort_order  int default 0,
  created_by  uuid references public.users(id),
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);
create index on public.locations (family_id, parent_id);

create table public.asset_categories (
  id             uuid primary key default gen_random_uuid(),
  slug           text unique,
  name           text,
  icon           text,
  default_dates  jsonb,
  schema         jsonb
);

create table public.assets (
  id             uuid primary key default gen_random_uuid(),
  family_id      uuid not null references public.families(id) on delete cascade,
  location_id    uuid references public.locations(id) on delete set null,
  category_id    uuid references public.asset_categories(id),
  name           text not null,
  brand          text,
  model          text,
  serial_no      text,
  purchase_date  date,
  purchase_price numeric(12,2),
  store          text,
  image_url      text,
  metadata       jsonb default '{}',
  created_by     uuid references public.users(id),
  created_at     timestamptz default now(),
  updated_at     timestamptz default now()
);
create index on public.assets (family_id);
create index on public.assets (location_id);

create type recurrence as enum ('none','monthly','quarterly','half_yearly','yearly');

create table public.asset_dates (
  id              uuid primary key default gen_random_uuid(),
  asset_id        uuid not null references public.assets(id) on delete cascade,
  label           text not null,
  due_date        date not null,
  recurrence      recurrence default 'none',
  notify_offsets  int[] default '{30,7,1}',
  completed_at    timestamptz,
  -- Rec #4: per-field versions for last-write-wins-per-field sync.
  field_versions  jsonb default '{}',
  created_at      timestamptz default now(),
  updated_at      timestamptz default now(),
  deleted_at      timestamptz                     -- tombstone for sync (Rec #4/#5)
);
create index on public.asset_dates (due_date);
create index on public.asset_dates (asset_id);

-- Rec #7: replace the fragile scalar last_notified_offset with a log table.
-- One row per (reminder, offset, channel) makes the worker idempotent, dedupes
-- per channel, and survives due_date edits.
create table public.notification_log (
  asset_date_id  uuid not null references public.asset_dates(id) on delete cascade,
  offset_days    int not null,
  channel        text not null default 'push',     -- push | local | email
  sent_at        timestamptz default now(),
  primary key (asset_date_id, offset_days, channel)
);

-- Rec #8: recurrence engine. Completing a recurring reminder rolls the due_date
-- forward to the next occurrence and clears the notification log for it, instead
-- of the reminder firing once and dying.
create or replace function public.complete_asset_date(p_id uuid)
returns public.asset_dates
language plpgsql
security definer
set search_path = public
as $$
declare
  rec public.asset_dates;
  step interval;
begin
  select * into rec from public.asset_dates where id = p_id for update;
  if not found then
    raise exception 'asset_date % not found', p_id;
  end if;

  step := case rec.recurrence
            when 'monthly'     then interval '1 month'
            when 'quarterly'   then interval '3 months'
            when 'half_yearly' then interval '6 months'
            when 'yearly'      then interval '1 year'
            else null
          end;

  if step is null then
    -- one-off: mark done.
    update public.asset_dates
       set completed_at = now()
     where id = p_id
     returning * into rec;
  else
    -- recurring: advance to next occurrence and reset its notification history.
    delete from public.notification_log where asset_date_id = p_id;
    update public.asset_dates
       set due_date     = (rec.due_date + step)::date,
           completed_at = null
     where id = p_id
     returning * into rec;
  end if;

  return rec;
end;
$$;

-- ============================================================================
-- SECTION 4 — DOCUMENTS
-- ============================================================================

create type doc_kind as enum ('invoice','warranty','insurance','manual','photo','other');

create table public.documents (
  id            uuid primary key default gen_random_uuid(),
  family_id     uuid not null references public.families(id) on delete cascade,
  asset_id      uuid references public.assets(id) on delete cascade,
  asset_date_id uuid references public.asset_dates(id) on delete set null,
  kind          doc_kind default 'other',
  title         text,
  storage_path  text not null,
  mime_type     text,
  size_bytes    bigint,
  sha256        text,                              -- Rec: dedup support
  thumb_path    text,
  uploaded_by   uuid references public.users(id),
  created_at    timestamptz default now(),
  updated_at    timestamptz default now(),
  deleted_at    timestamptz                        -- tombstone for sync
);
create index on public.documents (family_id);
create index on public.documents (asset_id);

-- ============================================================================
-- SECTION 5 — NOTIFICATION PREFERENCES (server-stored in either mode)
-- ============================================================================

create table public.notification_prefs (
  user_id         uuid primary key references public.users(id) on delete cascade,
  channels        text[] default '{push,local}',  -- push | local | email
  default_offsets int[]  default '{30,7,1}',
  quiet_start     time default '22:00',
  quiet_end       time default '07:00',
  updated_at      timestamptz default now()
);

-- ============================================================================
-- SECTION 6 — LOCAL-FIRST SYNC SUPPORT  (Rec #5)
-- ============================================================================

-- Per-device, per-table cursor so each device pulls only deltas it hasn't seen.
create table public.sync_state (
  user_id        uuid not null references public.users(id) on delete cascade,
  device_id      text not null,
  table_name     text not null,
  last_synced_at timestamptz not null default 'epoch',
  primary key (user_id, device_id, table_name)
);

-- ============================================================================
-- Rec #1 — updated_at maintenance on every mutable / synced table.
-- ============================================================================
create trigger set_updated_at before update on public.users
  for each row execute function moddatetime(updated_at);
create trigger set_updated_at before update on public.families
  for each row execute function moddatetime(updated_at);
create trigger set_updated_at before update on public.locations
  for each row execute function moddatetime(updated_at);
create trigger set_updated_at before update on public.assets
  for each row execute function moddatetime(updated_at);
create trigger set_updated_at before update on public.asset_dates
  for each row execute function moddatetime(updated_at);
create trigger set_updated_at before update on public.documents
  for each row execute function moddatetime(updated_at);
create trigger set_updated_at before update on public.notification_prefs
  for each row execute function moddatetime(updated_at);

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

alter table public.users              enable row level security;
alter table public.user_devices       enable row level security;
alter table public.families           enable row level security;
alter table public.family_members     enable row level security;
alter table public.family_invites     enable row level security;
alter table public.locations          enable row level security;
alter table public.assets             enable row level security;
alter table public.asset_dates        enable row level security;
alter table public.notification_log   enable row level security;
alter table public.documents          enable row level security;
alter table public.notification_prefs enable row level security;
alter table public.sync_state         enable row level security;

-- Users own their own profile / devices / prefs / cursors.
create policy "self read"  on public.users for select using (id = auth.uid());
create policy "self write" on public.users for update using (id = auth.uid()) with check (id = auth.uid());

create policy "own devices" on public.user_devices for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own prefs" on public.notification_prefs for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own sync state" on public.sync_state for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Families: members read; only the owner can mutate the family row itself.
create policy "members read family" on public.families for select
  using (is_family_member(id));
create policy "owner writes family" on public.families for all
  using (owner_id = auth.uid()) with check (owner_id = auth.uid());

-- Membership rows: any member can read; admin+ can change membership.
create policy "members read membership" on public.family_members for select
  using (is_family_member(family_id));
create policy "admins manage membership" on public.family_members for all
  using (is_family_member(family_id, 'admin'))
  with check (is_family_member(family_id, 'admin'));

create policy "admins manage invites" on public.family_invites for all
  using (is_family_member(family_id, 'admin'))
  with check (is_family_member(family_id, 'admin'));

-- Locations.
create policy "read locations" on public.locations for select
  using (is_family_member(family_id));
create policy "write locations" on public.locations for all
  using (is_family_member(family_id, 'member'))
  with check (is_family_member(family_id, 'member'));

-- Rec #3: assets — split policies so "member can delete only OWN" matches the
-- permission matrix; admins/owners can delete anything in the family.
create policy "read assets" on public.assets for select
  using (is_family_member(family_id));
create policy "insert assets" on public.assets for insert
  with check (is_family_member(family_id, 'member'));
create policy "update assets" on public.assets for update
  using (is_family_member(family_id, 'member'))
  with check (is_family_member(family_id, 'member'));
create policy "delete own assets or admin" on public.assets for delete
  using (
    is_family_member(family_id, 'admin')
    or (is_family_member(family_id, 'member') and created_by = auth.uid())
  );

-- asset_dates / documents inherit their asset's family via a lookup.
create policy "read asset_dates" on public.asset_dates for select
  using (exists (select 1 from public.assets a
                 where a.id = asset_id and is_family_member(a.family_id)));
create policy "write asset_dates" on public.asset_dates for all
  using (exists (select 1 from public.assets a
                 where a.id = asset_id and is_family_member(a.family_id, 'member')))
  with check (exists (select 1 from public.assets a
                 where a.id = asset_id and is_family_member(a.family_id, 'member')));

create policy "read notification_log" on public.notification_log for select
  using (exists (select 1 from public.asset_dates ad
                 join public.assets a on a.id = ad.asset_id
                 where ad.id = asset_date_id and is_family_member(a.family_id)));

create policy "read documents" on public.documents for select
  using (is_family_member(family_id));
create policy "write documents" on public.documents for all
  using (is_family_member(family_id, 'member'))
  with check (is_family_member(family_id, 'member'));

-- ============================================================================
-- Rec (moderate) — storage RLS guarded against non-UUID object keys.
-- Apply in the Storage policy editor (storage.objects):
--
--   create policy "family members read their files" on storage.objects
--     for select using (
--       bucket_id = 'docsbuddy-files'
--       and (storage.foldername(name))[1] ~ '^[0-9a-f-]{36}$'   -- guard cast
--       and is_family_member(((storage.foldername(name))[1])::uuid)
--     );
-- ============================================================================

-- ============================================================================
-- Rec (moderate) — invite acceptance as an atomic, validated RPC.
-- ============================================================================
create or replace function public.accept_invite(p_code text)
returns public.family_members
language plpgsql
security definer
set search_path = public
as $$
declare
  inv public.family_invites;
  mem public.family_members;
begin
  select * into inv from public.family_invites
   where code = p_code for update;

  if not found then            raise exception 'invalid invite'; end if;
  if inv.accepted_at is not null then raise exception 'invite already used'; end if;
  if inv.expires_at < now() then      raise exception 'invite expired'; end if;

  insert into public.family_members (family_id, user_id, role)
  values (inv.family_id, auth.uid(), inv.role)
  on conflict (family_id, user_id) do update set role = excluded.role
  returning * into mem;

  update public.family_invites set accepted_at = now() where id = inv.id;
  return mem;
end;
$$;

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0002_family_rpcs.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- Family creation / invite RPCs.
--
-- These are SECURITY DEFINER because creating a family requires inserting the
-- first owner into family_members, which the "admins manage membership" RLS
-- policy (0001) would otherwise block (the caller isn't a member yet — the
-- classic bootstrap problem). accept_invite already exists in 0001.
-- ============================================================================

-- Create a family and add the caller as its owner, atomically.
create or replace function public.create_family(p_name text)
returns public.families
language plpgsql
security definer
set search_path = public
as $$
declare
  fam public.families;
begin
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Family name is required';
  end if;

  insert into public.families (name, owner_id)
  values (trim(p_name), auth.uid())
  returning * into fam;

  insert into public.family_members (family_id, user_id, role)
  values (fam.id, auth.uid(), 'owner');

  return fam;
end;
$$;

-- Generate an invite for a family the caller administers.
create or replace function public.create_invite(p_family_id uuid, p_role family_role default 'member')
returns public.family_invites
language plpgsql
security definer
set search_path = public
as $$
declare
  inv public.family_invites;
begin
  if not public.is_family_member(p_family_id, 'admin') then
    raise exception 'Only owners/admins can invite members';
  end if;

  insert into public.family_invites (family_id, role, invited_by)
  values (p_family_id, p_role, auth.uid())
  returning * into inv;

  return inv;
end;
$$;

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0003_short_invite_code.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- Short, shareable family invite codes.
--
-- 0001 defaulted family_invites.code to encode(gen_random_bytes(16),'hex') — a
-- 32-char string that's awkward to type/share. Replace it with an 8-char
-- uppercase code (ambiguous chars 0/O/1/I excluded). create_invite (0002) uses
-- the column default, so no RPC change is needed.
-- ============================================================================

create or replace function public.gen_invite_code()
returns text
language sql
volatile
as $$
  select string_agg(
           substr('ABCDEFGHJKLMNPQRSTUVWXYZ23456789',
                  (floor(random() * 31) + 1)::int, 1),
           '')
  from generate_series(1, 8);
$$;

alter table public.family_invites
  alter column code set default public.gen_invite_code();

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0004_storage.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- Document storage bucket + RLS.
--
-- Files live under {family_id}/... so a single policy enforces tenant isolation
-- via the leading path segment. The regex guards the ::uuid cast against
-- non-UUID keys (architecture review).
-- ============================================================================

insert into storage.buckets (id, name, public)
values ('docsbuddy-files', 'docsbuddy-files', false)
on conflict (id) do nothing;

-- Members of the family that owns the leading {family_id} folder can read.
create policy "family members read files"
  on storage.objects for select
  using (
    bucket_id = 'docsbuddy-files'
    and (storage.foldername(name))[1] ~ '^[0-9a-f-]{36}$'
    and public.is_family_member(((storage.foldername(name))[1])::uuid)
  );

-- Member+ can upload into their family's folder.
create policy "family members upload files"
  on storage.objects for insert
  with check (
    bucket_id = 'docsbuddy-files'
    and (storage.foldername(name))[1] ~ '^[0-9a-f-]{36}$'
    and public.is_family_member(((storage.foldername(name))[1])::uuid, 'member')
  );

-- Member+ can delete their family's files.
create policy "family members delete files"
  on storage.objects for delete
  using (
    bucket_id = 'docsbuddy-files'
    and (storage.foldername(name))[1] ~ '^[0-9a-f-]{36}$'
    and public.is_family_member(((storage.foldername(name))[1])::uuid, 'member')
  );

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0005_seed_categories.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0005 — Category catalog seed + explicit reminder kind + category backfill
-- (design-gap A4 + the category half of the metadata debt)
--
-- 1. `asset_dates.kind` — an explicit service kind written at create time so
--    the app stops inferring it from the label (fragile `_kindFromLabel`).
--    Values mirror the app's ReminderKind names; label inference remains the
--    read-time fallback for old rows.
-- 2. Seeds `asset_categories`: five generic groups (slug = the app's old
--    category enum names, used for backfill) plus specific appliance/vehicle
--    types powering the appliance-picker screen. `default_dates` holds the
--    services auto-seeded when an asset of that type is created:
--    [{kind, label, start_months, recurrence}] relative to the purchase date
--    (or creation date).
-- 3. Backfills `assets.metadata->>'category'` into the `category_id` FK and
--    drops the JSONB key — retiring the metadata shortcut entirely
--    (locations were migrated in 0006).
-- ============================================================================

alter table public.asset_dates
  add column if not exists kind text;

insert into public.asset_categories (slug, name, icon, default_dates) values
  -- Generic groups (slugs match the app's category enum for backfill).
  ('vehicle',     'Vehicle',     'car',     '[]'::jsonb),
  ('appliance',   'Appliance',   'plug',    '[]'::jsonb),
  ('electronics', 'Electronics', 'devices', '[]'::jsonb),
  ('document',    'Document',    'folder',  '[]'::jsonb),
  ('other',       'Other',       'box',     '[]'::jsonb),

  -- Vehicles
  ('vehicle-car', 'Car', 'car', '[
    {"kind":"insurance","label":"Insurance","start_months":12,"recurrence":"yearly"},
    {"kind":"pollution","label":"Pollution (PUC)","start_months":6,"recurrence":"half_yearly"},
    {"kind":"service","label":"Service Due","start_months":6,"recurrence":"half_yearly"}
  ]'::jsonb),
  ('vehicle-bike', 'Bike / Scooter', 'bike', '[
    {"kind":"insurance","label":"Insurance","start_months":12,"recurrence":"yearly"},
    {"kind":"pollution","label":"Pollution (PUC)","start_months":6,"recurrence":"half_yearly"},
    {"kind":"service","label":"Service Due","start_months":6,"recurrence":"half_yearly"}
  ]'::jsonb),

  -- Appliances
  ('appliance-ac', 'Air Conditioner', 'ac', '[
    {"kind":"amc","label":"AMC","start_months":12,"recurrence":"yearly"},
    {"kind":"service","label":"Wet Service","start_months":6,"recurrence":"half_yearly"},
    {"kind":"warranty","label":"Warranty","start_months":12,"recurrence":"none"}
  ]'::jsonb),
  ('appliance-fridge', 'Refrigerator', 'fridge', '[
    {"kind":"warranty","label":"Warranty","start_months":12,"recurrence":"none"}
  ]'::jsonb),
  ('appliance-washing-machine', 'Washing Machine', 'washer', '[
    {"kind":"warranty","label":"Warranty","start_months":24,"recurrence":"none"},
    {"kind":"service","label":"Service Due","start_months":12,"recurrence":"yearly"}
  ]'::jsonb),
  ('appliance-water-purifier', 'Water Purifier', 'water', '[
    {"kind":"amc","label":"AMC","start_months":12,"recurrence":"yearly"},
    {"kind":"service","label":"Filter Change","start_months":6,"recurrence":"half_yearly"}
  ]'::jsonb),
  ('appliance-tv', 'Television', 'tv', '[
    {"kind":"warranty","label":"Warranty","start_months":12,"recurrence":"none"}
  ]'::jsonb),
  ('appliance-microwave', 'Microwave', 'microwave', '[
    {"kind":"warranty","label":"Warranty","start_months":12,"recurrence":"none"}
  ]'::jsonb),
  ('appliance-air-purifier', 'Air Purifier', 'air', '[
    {"kind":"service","label":"Filter Change","start_months":6,"recurrence":"half_yearly"}
  ]'::jsonb),
  ('appliance-geyser', 'Water Heater / Geyser', 'heater', '[
    {"kind":"warranty","label":"Warranty","start_months":24,"recurrence":"none"},
    {"kind":"service","label":"Descaling Service","start_months":12,"recurrence":"yearly"}
  ]'::jsonb),
  ('appliance-chimney', 'Kitchen Chimney', 'chimney', '[
    {"kind":"service","label":"Deep Clean Service","start_months":6,"recurrence":"half_yearly"}
  ]'::jsonb),

  -- Electronics
  ('electronics-phone', 'Smartphone', 'phone', '[
    {"kind":"warranty","label":"Warranty","start_months":12,"recurrence":"none"}
  ]'::jsonb),
  ('electronics-laptop', 'Laptop', 'laptop', '[
    {"kind":"warranty","label":"Warranty","start_months":12,"recurrence":"none"}
  ]'::jsonb)
on conflict (slug) do nothing;

-- Backfill: point assets at the generic category row matching the old
-- metadata value, then drop the JSONB key.
update public.assets a
set category_id = c.id,
    metadata    = a.metadata - 'category'
from public.asset_categories c
where a.category_id is null
  and coalesce(a.metadata->>'category', '') <> ''
  and c.slug = a.metadata->>'category';

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0006_service_fields.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0006 — Service fields + location backfill (design-gap A8 / A6 / D)
--
-- 1. Richer service fields on asset_dates: a reminder row IS the service
--    (AMC, insurance, pollution, …) for an asset; give it provider, policy
--    or contract number, cost and notes.
-- 2. Backfill the assets.metadata->>'location' shortcut into real
--    public.locations rows + assets.location_id, and drop the JSONB key.
--    (category_id backfill lands with the category-catalog seed in 0005.)
-- ============================================================================

alter table public.asset_dates
  add column if not exists provider  text,
  add column if not exists policy_no text,
  add column if not exists cost      numeric(12,2),
  add column if not exists notes     text;

-- Create a location row per distinct (family, metadata location name) that
-- doesn't already exist (case-insensitive match on name).
insert into public.locations (family_id, name, kind)
select distinct a.family_id, trim(a.metadata->>'location'), 'room'::location_kind
from public.assets a
where coalesce(trim(a.metadata->>'location'), '') <> ''
  and not exists (
    select 1 from public.locations l
    where l.family_id = a.family_id
      and lower(l.name) = lower(trim(a.metadata->>'location'))
  );

-- Point assets at their location row and drop the metadata shortcut.
update public.assets a
set location_id = l.id,
    metadata    = a.metadata - 'location'
from public.locations l
where a.location_id is null
  and coalesce(trim(a.metadata->>'location'), '') <> ''
  and l.family_id = a.family_id
  and lower(l.name) = lower(trim(a.metadata->>'location'));

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0007_whatsapp_channel.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0007 — WhatsApp reminder channel (design-gap decision, screen 15)
--
-- channels/channel are free-form text so no type change is needed; this
-- migration records 'whatsapp' as a supported value. Delivery is handled by
-- the `send-reminders-whatsapp` Edge Function (cron-driven), which dedups
-- through notification_log's (asset_date_id, offset_days, channel) PK and
-- sends to `users.phone` (E.164) for members whose prefs enable the channel.
-- ============================================================================

comment on column public.notification_prefs.channels is
  'Enabled delivery channels: push | local | email | whatsapp';

comment on column public.notification_log.channel is
  'Delivery channel the reminder went out on: push | local | email | whatsapp';

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0008_family_profile_visibility.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0008 — Family members can see each other's basic profile
--
-- public.users was `self read` only, so the family screen's
-- `users(display_name, …)` join returned NULL for every member except the
-- caller (co-members rendered as "Member"). Family members legitimately need
-- each other's name, phone and avatar for the member list.
--
-- The check runs through a SECURITY DEFINER helper (same pattern as
-- is_family_member in 0001) so evaluating it doesn't recurse into the
-- family_members RLS policies.
-- ============================================================================

create or replace function public.shares_family_with(target uuid)
returns boolean
language sql stable security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.family_members mine
    join public.family_members theirs using (family_id)
    where mine.user_id = auth.uid()
      and theirs.user_id = target
  );
$$;

create policy "family members read profiles" on public.users
  for select using (public.shares_family_with(id));
