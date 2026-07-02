-- ============================================================================
-- DocsBuddy — ALL migrations combined (0001 → 0010, feature-based)
--
-- One-shot setup script for the Supabase SQL editor: paste and run once on a
-- fresh project instead of applying migrations/ one by one.
--
-- GENERATED from supabase/migrations/*.sql — do not edit here; change the
-- individual migration and regenerate (cat the files in order + this header).
--
-- Run once on a clean database: seeds are idempotent (ON CONFLICT) but
-- CREATE TABLE/POLICY statements are not re-runnable.
-- ============================================================================


-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0001_extensions.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0001 — Extensions
--
-- Shared building blocks every later feature relies on:
--   pgcrypto    → gen_random_uuid() primary keys
--   moddatetime → set_updated_at triggers (architecture review Rec #1)
-- ============================================================================

create extension if not exists "pgcrypto";
create extension if not exists moddatetime;

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0002_users_profiles.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0002 — Users & profiles
--
-- App-side mirror of auth.users (display name, avatar, phone for WhatsApp
-- reminders, timezone for server-side scheduling) plus per-device FCM tokens.
-- A user owns their profile and devices; family-wide profile visibility is
-- added by the families feature (0003), which introduces the membership
-- tables that policy depends on.
-- ============================================================================

create table public.users (
  id            uuid primary key references auth.users(id) on delete cascade,
  email         text not null unique,
  display_name  text,
  avatar_url    text,
  phone         text,                         -- E.164; WhatsApp reminder destination
  locale        text default 'en',
  timezone      text default 'UTC',           -- used for server-side notification scheduling
  onboarded_at  timestamptz,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- Auto-provision a public.users row whenever an auth user is created (Rec #10).
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

create trigger set_updated_at before update on public.users
  for each row execute function moddatetime(updated_at);

alter table public.users        enable row level security;
alter table public.user_devices enable row level security;

create policy "self read"  on public.users for select using (id = auth.uid());
create policy "self write" on public.users for update using (id = auth.uid()) with check (id = auth.uid());

create policy "own devices" on public.user_devices for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0003_families_sharing.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0003 — Families & sharing
--
-- Multi-tenancy boundary: families, role-based membership, shareable invite
-- codes, and the RLS helpers every other feature scopes through.
--   - is_family_member() is SECURITY DEFINER with a pinned search_path so its
--     own read of family_members bypasses RLS deterministically and cannot
--     recurse (Rec #2).
--   - create_family / create_invite / accept_invite are SECURITY DEFINER RPCs
--     because the first-owner insert can't satisfy the membership RLS (the
--     classic bootstrap problem).
--   - Invite codes are short (8 chars, no ambiguous 0/O/1/I) but random.
--   - Family members may read each other's basic profile (name, phone,
--     avatar) — without this, co-members render as anonymous in the app.
-- ============================================================================

create type family_role as enum ('owner','admin','member','viewer');

create table public.families (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  owner_id    uuid not null references public.users(id),
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

create table public.family_members (
  family_id   uuid references public.families(id) on delete cascade,
  user_id     uuid references public.users(id) on delete cascade,
  role        family_role not null default 'member',
  joined_at   timestamptz default now(),
  primary key (family_id, user_id)
);
create index on public.family_members (user_id);

-- Short, shareable invite code (ambiguous chars excluded).
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

create table public.family_invites (
  id          uuid primary key default gen_random_uuid(),
  family_id   uuid references public.families(id) on delete cascade,
  email       text,
  code        text unique not null default public.gen_invite_code(),
  role        family_role default 'member',
  invited_by  uuid references public.users(id),
  expires_at  timestamptz default now() + interval '7 days',
  accepted_at timestamptz
);

-- RLS helper: is the caller a member of [fid] with at least [min_role]?
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

-- RLS helper: does the caller share any family with [target]?
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

-- Redeem an invite code atomically (validates expiry/reuse).
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

create trigger set_updated_at before update on public.families
  for each row execute function moddatetime(updated_at);

alter table public.families       enable row level security;
alter table public.family_members enable row level security;
alter table public.family_invites enable row level security;

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

-- Family members can read each other's basic profile (0002's users table).
create policy "family members read profiles" on public.users
  for select using (public.shares_family_with(id));

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0004_locations_rooms.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0004 — Locations / rooms
--
-- Family-scoped places (rooms, shelves, vehicles…) with an optional
-- parent_id hierarchy, a photo, and drag-to-reorder via sort_order.
-- ============================================================================

create type location_kind as enum ('home','office','vehicle','room','shelf','custom');

create table public.locations (
  id          uuid primary key default gen_random_uuid(),
  family_id   uuid not null references public.families(id) on delete cascade,
  parent_id   uuid references public.locations(id) on delete cascade,
  name        text not null,
  kind        location_kind not null default 'custom',
  image_url   text,                            -- bucket path; signed at render
  sort_order  int default 0,
  created_by  uuid references public.users(id),
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);
create index on public.locations (family_id, parent_id);

create trigger set_updated_at before update on public.locations
  for each row execute function moddatetime(updated_at);

alter table public.locations enable row level security;

create policy "read locations" on public.locations for select
  using (is_family_member(family_id));
create policy "write locations" on public.locations for all
  using (is_family_member(family_id, 'member'))
  with check (is_family_member(family_id, 'member'));

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0005_asset_categories.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0005 — Asset-category catalog (+ seed)
--
-- The appliance-picker catalog: specific vehicle/appliance/electronics types
-- plus five generic group rows (slugs match the app's category enum).
-- `default_dates` holds the services auto-seeded when an asset of that type
-- is created: [{kind, label, start_months, recurrence}] relative to the
-- purchase date (or creation date). Global read-only reference data — no
-- family scoping, no RLS (reads go through the anon/authenticated roles).
-- ============================================================================

create table public.asset_categories (
  id             uuid primary key default gen_random_uuid(),
  slug           text unique,
  name           text,
  icon           text,
  default_dates  jsonb,
  schema         jsonb
);

insert into public.asset_categories (slug, name, icon, default_dates) values
  -- Generic groups (slugs match the app's category enum).
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

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0006_assets.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0006 — Assets
--
-- The family's appliances/vehicles/electronics. Deletes cascade to services
-- and document rows. Delete policy matches the permission matrix (Rec #3):
-- members delete only what they created; admins/owners delete anything.
-- ============================================================================

create table public.assets (
  id             uuid primary key default gen_random_uuid(),
  family_id      uuid not null references public.families(id) on delete cascade,
  location_id    uuid references public.locations(id) on delete set null,
  category_id    uuid references public.asset_categories(id),
  name           text not null,
  brand          text,
  model          text,
  serial_no      text,                        -- serial / registration number
  purchase_date  date,
  purchase_price numeric(12,2),
  store          text,
  image_url      text,                        -- bucket path; signed at render
  metadata       jsonb default '{}',          -- category fallback when the catalog isn't seeded
  created_by     uuid references public.users(id),
  created_at     timestamptz default now(),
  updated_at     timestamptz default now()
);
create index on public.assets (family_id);
create index on public.assets (location_id);

create trigger set_updated_at before update on public.assets
  for each row execute function moddatetime(updated_at);

alter table public.assets enable row level security;

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

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0007_services_reminders.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0007 — Services & reminders
--
-- An asset_dates row IS a service on an asset (insurance, AMC, pollution…):
-- it carries its own reminder schedule (notify_offsets), record fields
-- (provider, policy no., cost, notes), and rolls forward on completion via
-- complete_asset_date() (Rec #8). notification_log's composite PK makes every
-- sender idempotent per (reminder, offset, channel) and survives due-date
-- edits (Rec #7). field_versions/deleted_at support local-first sync
-- (Rec #4/#5).
-- ============================================================================

create type recurrence as enum ('none','monthly','quarterly','half_yearly','yearly');

create table public.asset_dates (
  id              uuid primary key default gen_random_uuid(),
  asset_id        uuid not null references public.assets(id) on delete cascade,
  label           text not null,
  kind            text,                            -- app ReminderKind name (insurance, amc, …)
  due_date        date not null,
  recurrence      recurrence default 'none',
  notify_offsets  int[] default '{30,7,1}',        -- days-before-due to notify
  provider        text,                            -- e.g. the insurer / AMC vendor
  policy_no       text,                            -- policy / contract number
  cost            numeric(12,2),
  notes           text,
  completed_at    timestamptz,
  field_versions  jsonb default '{}',              -- per-field LWW sync versions
  created_at      timestamptz default now(),
  updated_at      timestamptz default now(),
  deleted_at      timestamptz                      -- tombstone for sync
);
create index on public.asset_dates (due_date);
create index on public.asset_dates (asset_id);

comment on column public.asset_dates.notify_offsets is
  'Days before due_date to notify on each enabled channel';

-- One row per (reminder, offset, channel): senders claim it before sending.
create table public.notification_log (
  asset_date_id  uuid not null references public.asset_dates(id) on delete cascade,
  offset_days    int not null,
  channel        text not null default 'push',
  sent_at        timestamptz default now(),
  primary key (asset_date_id, offset_days, channel)
);

comment on column public.notification_log.channel is
  'Delivery channel the reminder went out on: push | local | email | whatsapp';

-- Recurrence engine: completing a recurring service advances due_date to the
-- next occurrence and resets its notification history; one-offs just complete.
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
    update public.asset_dates
       set completed_at = now()
     where id = p_id
     returning * into rec;
  else
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

create trigger set_updated_at before update on public.asset_dates
  for each row execute function moddatetime(updated_at);

alter table public.asset_dates      enable row level security;
alter table public.notification_log enable row level security;

-- Services inherit their asset's family via a lookup.
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

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0008_documents_storage.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0008 — Documents & storage
--
-- Document metadata rows plus the private storage bucket the bytes live in.
-- A document belongs to an asset and optionally to a specific service on it
-- (asset_date_id — e.g. the insurance policy PDF on the Insurance service).
-- Files live under {family_id}/… so a single storage policy enforces tenant
-- isolation via the leading path segment; the regex guards the ::uuid cast
-- against non-UUID keys (architecture review).
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
  sha256        text,                              -- dedup support
  thumb_path    text,
  uploaded_by   uuid references public.users(id),
  created_at    timestamptz default now(),
  updated_at    timestamptz default now(),
  deleted_at    timestamptz                        -- tombstone for sync
);
create index on public.documents (family_id);
create index on public.documents (asset_id);

create trigger set_updated_at before update on public.documents
  for each row execute function moddatetime(updated_at);

alter table public.documents enable row level security;

create policy "read documents" on public.documents for select
  using (is_family_member(family_id));
create policy "write documents" on public.documents for all
  using (is_family_member(family_id, 'member'))
  with check (is_family_member(family_id, 'member'));

-- ── Storage bucket + RLS ────────────────────────────────────────────────────

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
-- >>> migrations/0009_notification_prefs.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0009 — Notification preferences
--
-- Per-user delivery settings backing the Settings screen: enabled channels,
-- the default notify offsets pre-filled on new reminders, and quiet hours
-- (alerts landing inside the window shift to its end). Server-stored so the
-- cron senders (email / whatsapp Edge Functions) can honour them.
-- ============================================================================

create table public.notification_prefs (
  user_id         uuid primary key references public.users(id) on delete cascade,
  channels        text[] default '{push,local}',
  default_offsets int[]  default '{30,7,1}',
  quiet_start     time default '22:00',
  quiet_end       time default '07:00',
  updated_at      timestamptz default now()
);

comment on column public.notification_prefs.channels is
  'Enabled delivery channels: push | local | email | whatsapp';

create trigger set_updated_at before update on public.notification_prefs
  for each row execute function moddatetime(updated_at);

alter table public.notification_prefs enable row level security;

create policy "own prefs" on public.notification_prefs for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ════════════════════════════════════════════════════════════════════════
-- >>> migrations/0010_sync_support.sql
-- ════════════════════════════════════════════════════════════════════════

-- ============================================================================
-- 0010 — Local-first sync support
--
-- Per-device, per-table cursor so each device pulls only deltas it hasn't
-- seen (Rec #5). The synced tables already carry field_versions (per-field
-- last-write-wins) and deleted_at tombstones in their own migrations.
-- ============================================================================

create table public.sync_state (
  user_id        uuid not null references public.users(id) on delete cascade,
  device_id      text not null,
  table_name     text not null,
  last_synced_at timestamptz not null default 'epoch',
  primary key (user_id, device_id, table_name)
);

alter table public.sync_state enable row level security;

create policy "own sync state" on public.sync_state for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
