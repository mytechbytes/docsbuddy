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
