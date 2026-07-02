# send-reminders-whatsapp

Cron-driven WhatsApp sender for due-date reminders (the `whatsapp` channel in
`notification_prefs.channels`, documented in migration `0007`). Sends via the
**Meta WhatsApp Cloud API** to `users.phone` (must be E.164, e.g. `+9198…`)
for every family member who opted in.

Deduped through `notification_log`'s `(asset_date_id, offset_days, channel)`
primary key — the log row is claimed before sending, so the cron can run
hourly without double-sending.

## Deploy

```sh
supabase functions deploy send-reminders-whatsapp --use-api
supabase secrets set \
  WHATSAPP_ACCESS_TOKEN=<meta cloud api token> \
  WHATSAPP_PHONE_NUMBER_ID=<sending phone number id>
# Optional — a pre-approved template with one {{1}} body parameter.
# Without it a plain text message is sent, which Meta only delivers inside
# an open 24h customer-service session:
supabase secrets set WHATSAPP_TEMPLATE=docsbuddy_reminder WHATSAPP_TEMPLATE_LANG=en
```

## Schedule (daily at 09:00 UTC)

Dashboard → Integrations → Cron, or SQL (pg_cron + pg_net enabled):

```sql
select cron.schedule(
  'whatsapp-reminders', '0 9 * * *',
  $$
  select net.http_post(
    url     := 'https://<project-ref>.supabase.co/functions/v1/send-reminders-whatsapp',
    headers := jsonb_build_object('Authorization', 'Bearer <anon-or-service-key>')
  );
  $$
);
```

## Response

`{ sent, deduped, scanned }` — messages delivered, offsets already claimed by
an earlier run, and candidate services scanned.
