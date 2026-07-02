-- ============================================================================
-- Cron schedules for the reminder senders (NOT a migration — run manually).
--
-- Prerequisites: enable the pg_cron and pg_net extensions
-- (Dashboard → Database → Extensions), deploy the functions, set their
-- secrets (see README.md), then replace the two placeholders below and run
-- this file in the SQL editor.
--
--   <project-ref> — your project ref (the subdomain of your project URL)
--   <anon-key>    — the anon/publishable key (passes the functions' JWT check)
--
-- Both senders are idempotent via notification_log's
-- (asset_date_id, offset_days, channel) primary key, so re-runs and
-- overlapping schedules never double-send.
-- ============================================================================

select cron.schedule(
  'email-reminders', '0 9 * * *',   -- daily 09:00 UTC
  $$
  select net.http_post(
    url     := 'https://<project-ref>.supabase.co/functions/v1/send-reminders-email',
    headers := jsonb_build_object('Authorization', 'Bearer <anon-key>')
  );
  $$
);

select cron.schedule(
  'whatsapp-reminders', '0 9 * * *',   -- daily 09:00 UTC
  $$
  select net.http_post(
    url     := 'https://<project-ref>.supabase.co/functions/v1/send-reminders-whatsapp',
    headers := jsonb_build_object('Authorization', 'Bearer <anon-key>')
  );
  $$
);

-- Inspect / remove:
--   select jobid, jobname, schedule from cron.job;
--   select cron.unschedule('email-reminders');
