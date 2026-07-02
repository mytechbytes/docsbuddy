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
