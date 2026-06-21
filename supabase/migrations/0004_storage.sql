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
