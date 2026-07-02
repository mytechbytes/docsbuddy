-- ============================================================================
-- 0003 — Families & sharing
--
-- Multi-tenancy boundary: families, role-based membership, shareable invite
-- codes, and the RLS helpers every other feature scopes through.
--   - is_family_member() is SECURITY DEFINER with a pinned search_path so its
--     own read of family_members bypasses RLS deterministically and cannot
--     recurse (Rec #2).
--   - create_family / create_invite / accept_invite are SECURITY DEFINER RPCs
--     because the first-owner insert can't satisfy the membership RLS (the
--     classic bootstrap problem).
--   - Invite codes are short (8 chars, no ambiguous 0/O/1/I) but random.
--   - Family members may read each other's basic profile (name, phone,
--     avatar) — without this, co-members render as anonymous in the app.
-- ============================================================================

create type family_role as enum ('owner','admin','member','viewer');

create table public.families (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  owner_id    uuid not null references public.users(id),
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

create table public.family_members (
  family_id   uuid references public.families(id) on delete cascade,
  user_id     uuid references public.users(id) on delete cascade,
  role        family_role not null default 'member',
  joined_at   timestamptz default now(),
  primary key (family_id, user_id)
);
create index on public.family_members (user_id);

-- Short, shareable invite code (ambiguous chars excluded).
create or replace function public.gen_invite_code()
returns text
language sql
volatile
as $$
  select string_agg(
           substr('ABCDEFGHJKLMNPQRSTUVWXYZ23456789',
                  (floor(random() * 31) + 1)::int, 1),
           '')
  from generate_series(1, 8);
$$;

create table public.family_invites (
  id          uuid primary key default gen_random_uuid(),
  family_id   uuid references public.families(id) on delete cascade,
  email       text,
  code        text unique not null default public.gen_invite_code(),
  role        family_role default 'member',
  invited_by  uuid references public.users(id),
  expires_at  timestamptz default now() + interval '7 days',
  accepted_at timestamptz
);

-- RLS helper: is the caller a member of [fid] with at least [min_role]?
create or replace function public.is_family_member(fid uuid, min_role family_role default 'viewer')
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.family_members fm
    where fm.family_id = fid
      and fm.user_id = auth.uid()
      and case min_role
            when 'viewer' then true
            when 'member' then fm.role in ('owner','admin','member')
            when 'admin'  then fm.role in ('owner','admin')
            when 'owner'  then fm.role = 'owner'
          end
  );
$$;

-- RLS helper: does the caller share any family with [target]?
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

-- Redeem an invite code atomically (validates expiry/reuse).
create or replace function public.accept_invite(p_code text)
returns public.family_members
language plpgsql
security definer
set search_path = public
as $$
declare
  inv public.family_invites;
  mem public.family_members;
begin
  select * into inv from public.family_invites
   where code = p_code for update;

  if not found then            raise exception 'invalid invite'; end if;
  if inv.accepted_at is not null then raise exception 'invite already used'; end if;
  if inv.expires_at < now() then      raise exception 'invite expired'; end if;

  insert into public.family_members (family_id, user_id, role)
  values (inv.family_id, auth.uid(), inv.role)
  on conflict (family_id, user_id) do update set role = excluded.role
  returning * into mem;

  update public.family_invites set accepted_at = now() where id = inv.id;
  return mem;
end;
$$;

create trigger set_updated_at before update on public.families
  for each row execute function moddatetime(updated_at);

alter table public.families       enable row level security;
alter table public.family_members enable row level security;
alter table public.family_invites enable row level security;

-- Families: members read; only the owner can mutate the family row itself.
create policy "members read family" on public.families for select
  using (is_family_member(id));
create policy "owner writes family" on public.families for all
  using (owner_id = auth.uid()) with check (owner_id = auth.uid());

-- Membership rows: any member can read; admin+ can change membership.
create policy "members read membership" on public.family_members for select
  using (is_family_member(family_id));
create policy "admins manage membership" on public.family_members for all
  using (is_family_member(family_id, 'admin'))
  with check (is_family_member(family_id, 'admin'));

create policy "admins manage invites" on public.family_invites for all
  using (is_family_member(family_id, 'admin'))
  with check (is_family_member(family_id, 'admin'));

-- Family members can read each other's basic profile (0002's users table).
create policy "family members read profiles" on public.users
  for select using (public.shares_family_with(id));
