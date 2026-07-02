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
