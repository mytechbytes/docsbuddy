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
supabase functions deploy notify-family
# URL: https://<project-ref>.functions.supabase.co/notify-family
```

## 3. Trigger it on data changes

**Dashboard → Database → Webhooks → Create:**

- Table: `asset_dates` (repeat for `assets`, `documents`)
- Events: **Insert, Update, Delete**
- Type: **Supabase Edge Function** → `notify-family`

The webhook POSTs `{ type, table, record, old_record }`. The function resolves the
`family_id` (directly, or via the row's `asset_id`), looks up that family's
`user_devices.fcm_token`s, mints an FCM HTTP v1 access token from the service
account, and sends a `data`-only message to each.

## Notes

- **Silent by design:** the message carries only `data` (no `notification`), so
  the app decides what to show after syncing — matching the local-first model.
- It currently notifies **all** family members (including the actor). To exclude
  the actor, add an `updated_by`/`created_by` column to the payload and filter it
  out of `userIds`.
- Test: change a reminder row → check the function logs
  (`supabase functions logs notify-family`) for `{ sent: N }`.
