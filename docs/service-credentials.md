# Service credentials — step-by-step

How to obtain every secret the three Edge Functions need, and set them on
Supabase. Do this once per Supabase project. Where each secret is *used* is in
`supabase/README.md`; this doc is about *getting* the values.

| Secret | Function | From |
|---|---|---|
| `FIREBASE_SERVICE_ACCOUNT` | `notify-family` | Firebase Console |
| `RESEND_API_KEY`, `EMAIL_FROM` | `send-reminders-email` | resend.com |
| `WHATSAPP_ACCESS_TOKEN`, `WHATSAPP_PHONE_NUMBER_ID` (+ optional `WHATSAPP_TEMPLATE`) | `send-reminders-whatsapp` | Meta for Developers |

Set any secret with the Supabase CLI (or Dashboard → Edge Functions →
Secrets):

```sh
supabase login                        # once
supabase link --project-ref <ref>    # once, from the repo root
supabase secrets set NAME=value
supabase secrets list                 # verify (values are hidden)
```

> ⚠️ Never commit any of these values. They are server-side only — the Flutter
> app never sees them.

---

## 1. `FIREBASE_SERVICE_ACCOUNT` (FCM sync push)

You need the **same Firebase project** that produced the app's
`android/app/google-services.json` (Project settings → General shows the
package `in.mytechbytes.docsbuddy`). If you don't have one yet:

1. Go to <https://console.firebase.google.com> → **Add project** (Analytics
   optional) → inside it **Add app → Android**, package
   `in.mytechbytes.docsbuddy`, download `google-services.json` and replace
   `android/app/google-services.json`.

Get the service account JSON:

2. Firebase Console → ⚙️ **Project settings → Service accounts** tab.
3. Under **Firebase Admin SDK**, click **Generate new private key** →
   **Generate key**. A file like `docsbuddy-xxxxx-firebase-adminsdk-….json`
   downloads. This is the `service-account.json` — treat it like a password.
4. Make sure the FCM v1 API is on: the link on that same page ("Manage
   service account permissions") opens Google Cloud — or directly visit
   **APIs & Services → Enabled APIs** for the project and confirm
   **Firebase Cloud Messaging API** is enabled (it is by default on new
   projects; enable it if not).

Set the secret (the whole JSON as one string):

```sh
supabase secrets set FIREBASE_SERVICE_ACCOUNT="$(cat ~/Downloads/docsbuddy-*-firebase-adminsdk-*.json)"
```

Then deploy the function and add the three Database Webhooks — see
`supabase/functions/notify-family/README.md`.

**Verify:** change any reminder in the app →
`supabase functions logs notify-family` should show `{ sent: N }`.

---

## 2. `RESEND_API_KEY` + `EMAIL_FROM` (email reminders)

1. Sign up at <https://resend.com> (free tier is plenty for reminders).
2. **Verify your sending domain** — required to email arbitrary addresses:
   - Dashboard → **Domains → Add Domain** → enter e.g. `mytechbytes.in`.
   - Resend shows 3–4 DNS records (DKIM TXT/CNAME records + an SPF TXT for the
     bounce subdomain). Add them at your DNS provider exactly as shown.
   - Wait for the domain to flip to **Verified** (usually minutes after DNS
     propagates).
   - *Shortcut while testing:* skip domain setup and use
     `EMAIL_FROM="DocsBuddy <onboarding@resend.dev>"` — but that only delivers
     to **your own** Resend account email.
3. **Create the API key:** Dashboard → **API Keys → Create API Key** → name it
   `docsbuddy-reminders`, permission **Sending access** (least privilege),
   optionally restricted to your domain → **Create**. Copy the `re_…` value
   now — it's shown only once.
4. Set both secrets:

```sh
supabase secrets set \
  RESEND_API_KEY=re_xxxxxxxxxxxx \
  EMAIL_FROM="DocsBuddy <reminders@mytechbytes.in>"
```

The from-address must be on the verified domain. Then deploy the function and
schedule the cron (`supabase/schedules.sql`).

**Verify:** enable the Email toggle in the app's Settings, create a reminder
due tomorrow, then invoke manually:

```sh
curl -H "Authorization: Bearer <anon-key>" \
  https://<ref>.supabase.co/functions/v1/send-reminders-email
# → {"sent":1,"deduped":0,"scanned":…}
```

---

## 3. `WHATSAPP_ACCESS_TOKEN` + `WHATSAPP_PHONE_NUMBER_ID` (WhatsApp reminders)

This one has the most moving parts — Meta requires a business app and, for
production messaging, an approved template.

### 3a. Create the app

1. Go to <https://developers.facebook.com> → **My Apps → Create App** → use
   case **Other** → type **Business** → name it (e.g. `DocsBuddy Reminders`)
   and attach/create a **Business portfolio**.
2. On the app dashboard, find **WhatsApp** → **Set up**. This provisions a
   **test phone number** automatically.

### 3b. Get the two values (dev/testing)

3. App → **WhatsApp → API Setup**. On this page:
   - **Phone number ID** — copy it → this is `WHATSAPP_PHONE_NUMBER_ID`.
   - **Temporary access token** — works immediately but **expires in 24 h**;
     fine for a first smoke test only.
   - **To:** add each tester's number under "manage phone number list" —
     in dev mode Meta only delivers to numbers registered here (max 5).

### 3c. Permanent token (production)

Temporary tokens die daily, so create a **System User** token:

4. <https://business.facebook.com> → **Settings (Business settings) → Users →
   System users → Add**: name `docsbuddy-sender`, role **Admin**.
5. Same screen → **Add assets** → **Apps** → select your app → enable
   **Manage app**.
6. **Generate new token** → choose the app → token expiration **Never** →
   check permissions **`whatsapp_business_messaging`** and
   **`whatsapp_business_management`** → **Generate token** → copy it (shown
   once) → this is `WHATSAPP_ACCESS_TOKEN`.
7. For a real (non-test) sender number: **WhatsApp Manager → Phone numbers →
   Add phone number**, verify it by SMS/voice, then use *that* number's
   **Phone number ID**. Complete **business verification** in Business
   settings to lift messaging limits.

### 3d. Message template (recommended)

Plain-text API messages are delivered **only inside a 24-hour customer-service
window** (i.e. after the user messaged you first). Reminders are
business-initiated, so production needs a **template**:

8. **WhatsApp Manager → Message templates → Create template**:
   - Category **Utility**, name `docsbuddy_reminder`, language English.
   - Body: `{{1}}` *(single parameter — the function fills the whole
     reminder sentence)*, e.g.: `🔔 {{1}}`
   - Submit; approval is usually minutes–hours for Utility templates.

### 3e. Set the secrets

```sh
supabase secrets set \
  WHATSAPP_ACCESS_TOKEN=EAAG... \
  WHATSAPP_PHONE_NUMBER_ID=1234567890
# once the template is approved:
supabase secrets set WHATSAPP_TEMPLATE=docsbuddy_reminder WHATSAPP_TEMPLATE_LANG=en
```

Deploy the function and schedule the cron (`supabase/schedules.sql`).

**Recipient requirements:** each family member must (a) enable the WhatsApp
toggle in Settings → Notifications and (b) have their phone saved on the
Profile screen — the app normalizes it to E.164 (`+919812345678`), which is
what the API expects.

**Verify:**

```sh
curl -H "Authorization: Bearer <anon-key>" \
  https://<ref>.supabase.co/functions/v1/send-reminders-whatsapp
# → {"sent":N,"deduped":0,"scanned":…}
```

If `sent` stays 0: check the number is in the dev recipient list (3b), the
token hasn't expired (3c), and — without a template — that the 24-hour window
rule isn't filtering you (3d).

---

## Quick reference — all secrets in one block

```sh
supabase secrets set FIREBASE_SERVICE_ACCOUNT="$(cat service-account.json)"
supabase secrets set RESEND_API_KEY=re_... EMAIL_FROM="DocsBuddy <reminders@yourdomain>"
supabase secrets set WHATSAPP_ACCESS_TOKEN=EAAG... WHATSAPP_PHONE_NUMBER_ID=...
supabase secrets set WHATSAPP_TEMPLATE=docsbuddy_reminder WHATSAPP_TEMPLATE_LANG=en
```
