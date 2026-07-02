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
