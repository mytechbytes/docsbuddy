-- ============================================================================
-- 0007 — Services & reminders
--
-- An asset_dates row IS a service on an asset (insurance, AMC, pollution…):
-- it carries its own reminder schedule (notify_offsets), record fields
-- (provider, policy no., cost, notes), and rolls forward on completion via
-- complete_asset_date() (Rec #8). notification_log's composite PK makes every
-- sender idempotent per (reminder, offset, channel) and survives due-date
-- edits (Rec #7). field_versions/deleted_at support local-first sync
-- (Rec #4/#5).
-- ============================================================================

create type recurrence as enum ('none','monthly','quarterly','half_yearly','yearly');

create table public.asset_dates (
  id              uuid primary key default gen_random_uuid(),
  asset_id        uuid not null references public.assets(id) on delete cascade,
  label           text not null,
  kind            text,                            -- app ReminderKind name (insurance, amc, …)
  due_date        date not null,
  recurrence      recurrence default 'none',
  notify_offsets  int[] default '{30,7,1}',        -- days-before-due to notify
  provider        text,                            -- e.g. the insurer / AMC vendor
  policy_no       text,                            -- policy / contract number
  cost            numeric(12,2),
  notes           text,
  completed_at    timestamptz,
  field_versions  jsonb default '{}',              -- per-field LWW sync versions
  created_at      timestamptz default now(),
  updated_at      timestamptz default now(),
  deleted_at      timestamptz                      -- tombstone for sync
);
create index on public.asset_dates (due_date);
create index on public.asset_dates (asset_id);

comment on column public.asset_dates.notify_offsets is
  'Days before due_date to notify on each enabled channel';

-- One row per (reminder, offset, channel): senders claim it before sending.
create table public.notification_log (
  asset_date_id  uuid not null references public.asset_dates(id) on delete cascade,
  offset_days    int not null,
  channel        text not null default 'push',
  sent_at        timestamptz default now(),
  primary key (asset_date_id, offset_days, channel)
);

comment on column public.notification_log.channel is
  'Delivery channel the reminder went out on: push | local | email | whatsapp';

-- Recurrence engine: completing a recurring service advances due_date to the
-- next occurrence and resets its notification history; one-offs just complete.
create or replace function public.complete_asset_date(p_id uuid)
returns public.asset_dates
language plpgsql
security definer
set search_path = public
as $$
declare
  rec public.asset_dates;
  step interval;
begin
  select * into rec from public.asset_dates where id = p_id for update;
  if not found then
    raise exception 'asset_date % not found', p_id;
  end if;

  step := case rec.recurrence
            when 'monthly'     then interval '1 month'
            when 'quarterly'   then interval '3 months'
            when 'half_yearly' then interval '6 months'
            when 'yearly'      then interval '1 year'
            else null
          end;

  if step is null then
    update public.asset_dates
       set completed_at = now()
     where id = p_id
     returning * into rec;
  else
    delete from public.notification_log where asset_date_id = p_id;
    update public.asset_dates
       set due_date     = (rec.due_date + step)::date,
           completed_at = null
     where id = p_id
     returning * into rec;
  end if;

  return rec;
end;
$$;

create trigger set_updated_at before update on public.asset_dates
  for each row execute function moddatetime(updated_at);

alter table public.asset_dates      enable row level security;
alter table public.notification_log enable row level security;

-- Services inherit their asset's family via a lookup.
create policy "read asset_dates" on public.asset_dates for select
  using (exists (select 1 from public.assets a
                 where a.id = asset_id and is_family_member(a.family_id)));
create policy "write asset_dates" on public.asset_dates for all
  using (exists (select 1 from public.assets a
                 where a.id = asset_id and is_family_member(a.family_id, 'member')))
  with check (exists (select 1 from public.assets a
                 where a.id = asset_id and is_family_member(a.family_id, 'member')));

create policy "read notification_log" on public.notification_log for select
  using (exists (select 1 from public.asset_dates ad
                 join public.assets a on a.id = ad.asset_id
                 where ad.id = asset_date_id and is_family_member(a.family_id)));
