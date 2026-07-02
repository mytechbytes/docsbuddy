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
