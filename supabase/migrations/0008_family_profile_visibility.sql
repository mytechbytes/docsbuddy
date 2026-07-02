-- ============================================================================
-- 0008 — Family members can see each other's basic profile
--
-- public.users was `self read` only, so the family screen's
-- `users(display_name, …)` join returned NULL for every member except the
-- caller (co-members rendered as "Member"). Family members legitimately need
-- each other's name, phone and avatar for the member list.
--
-- The check runs through a SECURITY DEFINER helper (same pattern as
-- is_family_member in 0001) so evaluating it doesn't recurse into the
-- family_members RLS policies.
-- ============================================================================

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

create policy "family members read profiles" on public.users
  for select using (public.shares_family_with(id));
