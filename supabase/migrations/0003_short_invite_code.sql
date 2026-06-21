-- ============================================================================
-- Short, shareable family invite codes.
--
-- 0001 defaulted family_invites.code to encode(gen_random_bytes(16),'hex') — a
-- 32-char string that's awkward to type/share. Replace it with an 8-char
-- uppercase code (ambiguous chars 0/O/1/I excluded). create_invite (0002) uses
-- the column default, so no RPC change is needed.
-- ============================================================================

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

alter table public.family_invites
  alter column code set default public.gen_invite_code();
