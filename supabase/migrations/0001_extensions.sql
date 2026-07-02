-- ============================================================================
-- 0001 — Extensions
--
-- Shared building blocks every later feature relies on:
--   pgcrypto    → gen_random_uuid() primary keys
--   moddatetime → set_updated_at triggers (architecture review Rec #1)
-- ============================================================================

create extension if not exists "pgcrypto";
create extension if not exists moddatetime;
