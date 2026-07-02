# send-reminders-whatsapp

Cron-driven WhatsApp sender for due-date reminders (the `whatsapp` channel in
`notification_prefs.channels`, documented in migration `0007`). Sends via the
**Meta WhatsApp Cloud API** to `users.phone` (must be E.164, e.g. `+9198…`)
for every family member who opted in.

Deduped through `notification_log`'s `(asset_date_id, offset_days, channel)`
primary key — the log row is claimed before sending, so the cron can run
hourly without double-sending.

## Deploy

> Getting the credentials step by step: `docs/service-credentials.md`.

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

## Schedule (daily at 09:00 GMT)

**Cron UI (easiest):** Dashboard → **Integrations → Cron** (Enable once) →
**Jobs → Create job** → Name `whatsapp-reminders` · Schedule `0 9 * * *` ·
Type **Supabase Edge Function** → `send-reminders-whatsapp`, method POST, max timeout →
Create. The auth header is added automatically.

**Or via SQL** — run `supabase/schedules.sql` once in the **SQL Editor**
(fill in the placeholders). Never paste it into a cron job's SQL Snippet —
a snippet body must be only the inner `net.http_post(...)` call.


## Response

`{ sent, deduped, scanned }` — messages delivered, offsets already claimed by
an earlier run, and candidate services scanned.
