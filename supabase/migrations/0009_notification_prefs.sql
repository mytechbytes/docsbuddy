-- ============================================================================
-- 0009 — Notification preferences
--
-- Per-user delivery settings backing the Settings screen: enabled channels,
-- the default notify offsets pre-filled on new reminders, and quiet hours
-- (alerts landing inside the window shift to its end). Server-stored so the
-- cron senders (email / whatsapp Edge Functions) can honour them.
-- ============================================================================

create table public.notification_prefs (
  user_id         uuid primary key references public.users(id) on delete cascade,
  channels        text[] default '{push,local}',
  default_offsets int[]  default '{30,7,1}',
  quiet_start     time default '22:00',
  quiet_end       time default '07:00',
  updated_at      timestamptz default now()
);

comment on column public.notification_prefs.channels is
  'Enabled delivery channels: push | local | email | whatsapp';

create trigger set_updated_at before update on public.notification_prefs
  for each row execute function moddatetime(updated_at);

alter table public.notification_prefs enable row level security;

create policy "own prefs" on public.notification_prefs for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
