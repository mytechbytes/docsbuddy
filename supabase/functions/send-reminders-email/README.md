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

## Schedule (daily at 09:00 IST)

**Cron UI (easiest):** Dashboard → **Integrations → Cron** (Enable once) →
**Jobs → Create job** → Name `email-reminders` · Schedule `30 3 * * *` (= 09:00 IST; pg_cron runs in GMT) ·
Type **Supabase Edge Function** → `send-reminders-email`, method POST, max timeout →
Create. The auth header is added automatically.

**Or via SQL** — run `supabase/schedules.sql` once in the **SQL Editor**
(fill in the placeholders). Never paste it into a cron job's SQL Snippet —
a snippet body must be only the inner `net.http_post(...)` call.


## Response

`{ sent, deduped, scanned }`.
