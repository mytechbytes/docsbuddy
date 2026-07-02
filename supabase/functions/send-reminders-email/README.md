# send-reminders-email

Cron-driven email sender for due-date reminders (the `email` channel in
`notification_prefs.channels`), delivered via the **Resend API** to every
opted-in family member's `users.email`. Deduped through `notification_log`'s
`(asset_date_id, offset_days, channel)` primary key.

## Deploy

> Getting the credentials step by step: `docs/service-credentials.md`.

```sh
supabase functions deploy send-reminders-email --use-api
supabase secrets set \
  RESEND_API_KEY=<resend api key> \
  EMAIL_FROM="DocsBuddy <reminders@yourdomain.tld>"   # verified sender/domain
```

## Schedule (daily at 09:00 UTC)

Dashboard → Integrations → Cron, or SQL (pg_cron + pg_net enabled):

```sql
select cron.schedule(
  'email-reminders', '0 9 * * *',
  $$
  select net.http_post(
    url     := 'https://<project-ref>.supabase.co/functions/v1/send-reminders-email',
    headers := jsonb_build_object('Authorization', 'Bearer <anon-or-service-key>')
  );
  $$
);
```

## Response

`{ sent, deduped, scanned }`.
