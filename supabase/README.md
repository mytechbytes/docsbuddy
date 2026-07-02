# DocsBuddy — Supabase setup (all services)

Everything the backend needs, in the order to set it up. App-side
configuration (dart-defines, deep links) lives in `docs/supabase-setup.md`.

| # | Component | Where | Manual steps? |
|---|-----------|-------|---------------|
| 1 | Database schema + RLS + seed | `migrations/` (or `all_migrations.sql`) | run once |
| 2 | Auth providers & redirect URLs | Dashboard → Authentication | yes |
| 3 | Storage bucket + policies | created by migration `0008` | none |
| 4 | `notify-family` (sync push) | `functions/notify-family` | deploy + secret + webhooks |
| 5 | `send-reminders-email` | `functions/send-reminders-email` | deploy + secrets + cron |
| 6 | `send-reminders-whatsapp` | `functions/send-reminders-whatsapp` | deploy + secrets + cron |

## 1. Database

Paste **`all_migrations.sql`** into the SQL Editor and Run. It **drops every
existing DocsBuddy object first** (the `reset.sql` section — ⚠️ destructive:
wipes DocsBuddy data) and then re-creates the full schema, so it works on an
empty project, a partial install, or an old-numbering install alike.

> Storage note: newer projects forbid direct DML on the storage tables, so
> the file/bucket cleanup is best-effort (a NOTICE is raised when skipped —
> the bucket is reused and old files become orphans). For a full wipe, empty
> the `docsbuddy-files` bucket from Dashboard → Storage.

Alternatives: run `reset.sql` alone to just tear down, or apply
`migrations/0*.sql` in order on a clean database (see `migrations/README.md`
for the feature layout).

## 2. Auth

Dashboard → Authentication:

- **Providers → Email**: enable (+ **Email OTP**, length 6 — the reset flow).
- **URL Configuration**: Site URL `https://docsbuddy.mytechbytes.in`;
  Redirect URLs += `https://docsbuddy.mytechbytes.in/login-callback` and
  `in.mytechbytes.docsbuddy://login-callback`.
- Optional: Google / Apple OAuth (details in `docs/supabase-setup.md`).
- 2FA/TOTP needs no dashboard setup — GoTrue MFA is available by default.

## 3. Storage

Nothing to do: migration `0008` creates the private **`docsbuddy-files`**
bucket and its family-scoped policies. Asset photos, room photos, avatars
and documents all live under `{family_id}/…` in this one bucket.

## 4–6. Edge Functions

Deploy all three (Management-API path — no local Docker needed):

```sh
supabase functions deploy notify-family            --use-api
supabase functions deploy send-reminders-email     --use-api
supabase functions deploy send-reminders-whatsapp  --use-api
```

Set the secrets (`SUPABASE_URL` / `SUPABASE_SERVICE_ROLE_KEY` are injected
automatically):

```sh
# notify-family — FCM sync push
supabase secrets set FIREBASE_SERVICE_ACCOUNT="$(cat service-account.json)"

# send-reminders-email — Resend
supabase secrets set RESEND_API_KEY=<key> \
  EMAIL_FROM="DocsBuddy <reminders@yourdomain.tld>"

# send-reminders-whatsapp — Meta WhatsApp Cloud API
supabase secrets set WHATSAPP_ACCESS_TOKEN=<token> \
  WHATSAPP_PHONE_NUMBER_ID=<id>
# optional pre-approved template (else plain text, 24h-session only):
supabase secrets set WHATSAPP_TEMPLATE=docsbuddy_reminder WHATSAPP_TEMPLATE_LANG=en
```

**Triggers:**

- `notify-family` fires from **Database Webhooks** on
  `asset_dates` / `assets` / `documents` (Insert+Update+Delete) — step-by-step
  in its README. Creating the first webhook auto-enables `pg_net`.
- The two reminder senders fire from **daily crons** — fill in the
  placeholders in **`schedules.sql`** and run it (needs `pg_cron` + `pg_net`,
  Dashboard → Database → Extensions). Both senders are idempotent via
  `notification_log`, so overlapping/extra runs never double-send.

## Verify

- App shows **"Backend: Supabase"** on Settings once the dart-defines are set.
- Change a reminder → `supabase functions logs notify-family` shows `{ sent: N }`.
- `select cron.schedule, jobname from cron.job;` lists both reminder crons.
- Manually invoke a sender:
  `curl -H "Authorization: Bearer <anon-key>" https://<ref>.supabase.co/functions/v1/send-reminders-email`
  → `{ sent, deduped, scanned }`.
