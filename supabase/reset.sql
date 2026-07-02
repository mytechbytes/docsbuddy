-- ============================================================================
-- DocsBuddy — RESET (drop everything before re-creating)
--
-- ⚠️ DESTRUCTIVE: removes every DocsBuddy table, type, function and policy
-- (and, where the project allows it, stored files — see the storage note at
-- the bottom). Run it only when you want to rebuild the schema from scratch
-- (e.g. a project that already has a partial/older install). It is baked into
-- the top of all_migrations.sql, so pasting that one file both wipes and
-- re-creates. Every statement is IF-EXISTS-guarded, so it also runs cleanly
-- on an empty project.
--
-- Order matters: trigger on auth.users first, then tables (CASCADE takes the
-- policies, per-table triggers and row-type-returning functions with them),
-- then enums (CASCADE takes functions whose signatures reference them), then
-- the remaining standalone functions, then storage.
-- ============================================================================

-- Auth hook.
drop trigger if exists on_auth_user_created on auth.users;

-- Tables, reverse dependency order (CASCADE clears policies/triggers/FKs and
-- any functions returning these row types: accept_invite, create_family,
-- create_invite, complete_asset_date).
drop table if exists public.sync_state         cascade;
drop table if exists public.notification_prefs cascade;
drop table if exists public.documents          cascade;
drop table if exists public.notification_log   cascade;
drop table if exists public.asset_dates        cascade;
drop table if exists public.assets             cascade;
drop table if exists public.asset_categories   cascade;
drop table if exists public.locations          cascade;
drop table if exists public.family_invites     cascade;
drop table if exists public.family_members     cascade;
drop table if exists public.families           cascade;
drop table if exists public.user_devices       cascade;
drop table if exists public.users              cascade;

-- Enums (CASCADE clears any surviving function whose signature uses them,
-- e.g. is_family_member(uuid, family_role)).
drop type if exists family_role   cascade;
drop type if exists location_kind cascade;
drop type if exists recurrence    cascade;
drop type if exists doc_kind      cascade;

-- Standalone functions (builtin-type signatures; safe even after the above).
drop function if exists public.handle_new_user()          cascade;
drop function if exists public.gen_invite_code()          cascade;
drop function if exists public.shares_family_with(uuid)   cascade;
drop function if exists public.accept_invite(text)        cascade;
drop function if exists public.create_family(text)        cascade;
drop function if exists public.complete_asset_date(uuid)  cascade;

-- Storage policies (DDL — allowed from the SQL editor).
drop policy if exists "family members read files"   on storage.objects;
drop policy if exists "family members upload files" on storage.objects;
drop policy if exists "family members delete files" on storage.objects;

-- Storage rows: newer Supabase projects FORBID direct DML on storage tables
-- ("direct deletion from storage table is not allowed"), so this is
-- best-effort — when blocked we keep the bucket (0008 re-creates it with
-- ON CONFLICT DO NOTHING) and any old files become harmless orphans. For a
-- full wipe, empty/delete the `docsbuddy-files` bucket from
-- Dashboard → Storage instead.
do $$
begin
  delete from storage.objects where bucket_id = 'docsbuddy-files';
  delete from storage.buckets where id = 'docsbuddy-files';
exception when others then
  raise notice 'Skipping storage row cleanup (%): empty the docsbuddy-files bucket from the dashboard if you want a full wipe.', sqlerrm;
end $$;

-- Extensions (pgcrypto, moddatetime) are left installed — the migrations use
-- CREATE EXTENSION IF NOT EXISTS.
