-- ============================================================================
-- 0010 — Local-first sync support
--
-- Per-device, per-table cursor so each device pulls only deltas it hasn't
-- seen (Rec #5). The synced tables already carry field_versions (per-field
-- last-write-wins) and deleted_at tombstones in their own migrations.
-- ============================================================================

create table public.sync_state (
  user_id        uuid not null references public.users(id) on delete cascade,
  device_id      text not null,
  table_name     text not null,
  last_synced_at timestamptz not null default 'epoch',
  primary key (user_id, device_id, table_name)
);

alter table public.sync_state enable row level security;

create policy "own sync state" on public.sync_state for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
