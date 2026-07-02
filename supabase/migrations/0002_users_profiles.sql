-- ============================================================================
-- 0002 — Users & profiles
--
-- App-side mirror of auth.users (display name, avatar, phone for WhatsApp
-- reminders, timezone for server-side scheduling) plus per-device FCM tokens.
-- A user owns their profile and devices; family-wide profile visibility is
-- added by the families feature (0003), which introduces the membership
-- tables that policy depends on.
-- ============================================================================

create table public.users (
  id            uuid primary key references auth.users(id) on delete cascade,
  email         text not null unique,
  display_name  text,
  avatar_url    text,
  phone         text,                         -- E.164; WhatsApp reminder destination
  locale        text default 'en',
  timezone      text default 'UTC',           -- used for server-side notification scheduling
  onboarded_at  timestamptz,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- Auto-provision a public.users row whenever an auth user is created (Rec #10).
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, email, display_name, avatar_url)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

create table public.user_devices (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.users(id) on delete cascade,
  fcm_token     text not null,
  platform      text check (platform in ('ios','android')),
  app_version   text,
  last_seen_at  timestamptz default now(),
  unique (user_id, fcm_token)
);

create trigger set_updated_at before update on public.users
  for each row execute function moddatetime(updated_at);

alter table public.users        enable row level security;
alter table public.user_devices enable row level security;

create policy "self read"  on public.users for select using (id = auth.uid());
create policy "self write" on public.users for update using (id = auth.uid()) with check (id = auth.uid());

create policy "own devices" on public.user_devices for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
