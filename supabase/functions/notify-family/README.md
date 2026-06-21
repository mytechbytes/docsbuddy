# `notify-family` Edge Function

Sends a **silent FCM data push** to a family's devices when a member changes a
reminder / asset / document — the server half of the local-first sync wake. The
app (already wired) registers each device's token in `user_devices` and refreshes
on receipt.

## 1. Set the secret

You need a Firebase **service account** with the *Firebase Cloud Messaging API*
enabled (Firebase Console → Project settings → Service accounts → Generate new
private key → download the JSON):

```bash
supabase secrets set FIREBASE_SERVICE_ACCOUNT="$(cat path/to/service-account.json)"
```

(`SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` are provided to the function
automatically.)

## 2. Deploy

```bash
# Recommended: deploy via the Management API — no local Docker needed
supabase functions deploy notify-family --use-api

# (default Docker path; fails if it can't pull public.ecr.aws/supabase/edge-runtime)
supabase functions deploy notify-family
```

URL: `https://<project-ref>.functions.supabase.co/notify-family`

> **"failed to pull docker image … public.ecr.aws/supabase/edge-runtime"** — the
> default deploy bundles in Docker. Use **`--use-api`** (above) to skip Docker
> entirely. If `--use-api` isn't recognised, `npm i -g supabase@latest` first;
> or start Docker Desktop and `docker pull public.ecr.aws/supabase/edge-runtime:v1.74.1`
> then retry.

## 3. Trigger it on data changes

**Dashboard → Database → Webhooks** (newer UI: **Integrations → Database
Webhooks**) → **Create a new hook**. Create one per table:

1. **Name:** `notify_family_asset_dates`
2. **Table:** `public.asset_dates`
3. **Events:** ✅ Insert ✅ Update ✅ Delete
4. **Webhook configuration → Type:** **Supabase Edge Functions** → select
   **`notify-family`** (method POST). This auto-fills the URL and an
   `Authorization: Bearer <anon key>` header (passes the function's JWT check).
5. **Create**. Repeat for **`public.assets`** and **`public.documents`**.

Creating the first hook auto-enables the `pg_net` / `supabase_functions`
extension. The webhook POSTs `{ type, table, record, old_record }`; the function
resolves the `family_id` (directly or via `asset_id`), looks up that family's
`user_devices.fcm_token`s, mints an FCM HTTP v1 access token, and sends a
`data`-only message to each.

## Notes

- **Silent by design:** the message carries only `data` (no `notification`), so
  the app decides what to show after syncing — matching the local-first model.
- It currently notifies **all** family members (including the actor). To exclude
  the actor, add an `updated_by`/`created_by` column to the payload and filter it
  out of `userIds`.
- Test: change a reminder row → check the function logs
  (`supabase functions logs notify-family`) for `{ sent: N }`.
