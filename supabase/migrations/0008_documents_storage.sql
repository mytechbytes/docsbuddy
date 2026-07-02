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
