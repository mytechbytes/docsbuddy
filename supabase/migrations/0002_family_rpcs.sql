-- ============================================================================
-- Family creation / invite RPCs.
--
-- These are SECURITY DEFINER because creating a family requires inserting the
-- first owner into family_members, which the "admins manage membership" RLS
-- policy (0001) would otherwise block (the caller isn't a member yet — the
-- classic bootstrap problem). accept_invite already exists in 0001.
-- ============================================================================

-- Create a family and add the caller as its owner, atomically.
create or replace function public.create_family(p_name text)
returns public.families
language plpgsql
security definer
set search_path = public
as $$
declare
  fam public.families;
begin
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Family name is required';
  end if;

  insert into public.families (name, owner_id)
  values (trim(p_name), auth.uid())
  returning * into fam;

  insert into public.family_members (family_id, user_id, role)
  values (fam.id, auth.uid(), 'owner');

  return fam;
end;
$$;

-- Generate an invite for a family the caller administers.
create or replace function public.create_invite(p_family_id uuid, p_role family_role default 'member')
returns public.family_invites
language plpgsql
security definer
set search_path = public
as $$
declare
  inv public.family_invites;
begin
  if not public.is_family_member(p_family_id, 'admin') then
    raise exception 'Only owners/admins can invite members';
  end if;

  insert into public.family_invites (family_id, role, invited_by)
  values (p_family_id, p_role, auth.uid())
  returning * into inv;

  return inv;
end;
$$;
