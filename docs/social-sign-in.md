# Social sign-in: Google, Apple and Microsoft

Step-by-step setup for the three social buttons on the Sign in / Sign up
screens. Nothing here requires code changes — the app side is already built;
this is console + Supabase configuration.

> Console menus change names from time to time. The labels below match the
> consoles at the time of writing; if one has moved, search the console for the
> bold term.

**Contents**
- [How it works](#how-it-works)
- [Values you will need](#values-you-will-need)
- [Part 1 — Supabase base setup](#part-1--supabase-base-setup)
- [Part 2 — Returning to the app (deep links)](#part-2--returning-to-the-app-deep-links)
- [Part 3 — Google](#part-3--google)
- [Part 4 — Apple](#part-4--apple)
- [Part 5 — Microsoft](#part-5--microsoft)
- [Part 6 — Test every provider](#part-6--test-every-provider)
- [Troubleshooting](#troubleshooting)
- [Maintenance calendar](#maintenance-calendar)

---

## How it works

The app uses **Supabase browser OAuth** (`signInWithOAuth`). No provider SDKs
run inside the app.

```
App button ──▶ Supabase /authorize ──▶ Provider sign-in page (browser)
                                              │ user signs in
App ◀── redirect link ◀── Supabase /callback ◀┘
```

1. The app asks Supabase to start the flow and passes a **redirect URL**
   (`Env.authRedirectUrl`) saying where to come back to.
2. The provider sends the user back to **Supabase's callback**
   (`https://<ref>.supabase.co/auth/v1/callback`). This is the URL every
   provider console needs.
3. Supabase creates the session and opens the **redirect URL**, which reopens
   the app signed in.

So each provider only ever talks to Supabase; Supabase only ever talks to the
app. Code: `lib/features/auth/data/auth_remote_data_source.dart`.

## Values you will need

| Name | Value |
|---|---|
| Supabase project ref | `<ref>` — the subdomain of your project URL (`https://<ref>.supabase.co`) |
| Supabase callback URL | `https://<ref>.supabase.co/auth/v1/callback` |
| App redirect (App Link / Universal Link) | `https://docsbuddy.mytechbytes.in/login-callback` |
| App redirect (custom scheme) | `in.mytechbytes.docsbuddy://login-callback` |
| iOS bundle ID / Android package | `in.mytechbytes.docsbuddy` |
| Apple Team ID | `PAB3TLAUZH` (Xcode `DEVELOPMENT_TEAM`; confirm under Apple Developer → Membership) |
| Website domain | `docsbuddy.mytechbytes.in` |

Keep every secret you create below in the team password manager, with its
**expiry date** (Apple and Microsoft secrets expire).

---

## Part 1 — Supabase base setup

Do this once, before any provider.

1. Open <https://supabase.com/dashboard> → your project.
2. **Project Settings → API**: note the **Project URL** (gives you `<ref>`) and
   the **anon / publishable key**, and put them in your local config file:
   ```bash
   cp config/dev.example.json config/dev.json
   ```
   Edit `config/dev.json` (gitignored — never committed):
   ```json
   {
     "SUPABASE_URL": "https://<ref>.supabase.co",
     "SUPABASE_ANON_KEY": "<anon or publishable key>",
     "BACKEND": "supabase",
     "IOS_UNIVERSAL_LINKS": "false"
   }
   ```
   Run with it:
   ```bash
   flutter run --dart-define-from-file=config/dev.json
   ```
   VS Code: **Run and Debug → DocsBuddy (Supabase dev)**. Android Studio:
   **Run → Edit Configurations → main.dart → Additional run args** =
   `--dart-define-from-file=config/dev.json`.

   Only these two public client values go in the app. Provider secrets from
   Parts 3–5 (Google/Microsoft client secrets, the Apple `.p8` key and JWT) and
   the Supabase **service_role** key never go in the repo or the app — they are
   entered only in the Supabase dashboard and kept in the team password
   manager. CI reads `SUPABASE_URL` / `SUPABASE_ANON_KEY` from GitHub
   repository secrets (see `config/README.md`).
3. **Authentication → URL Configuration**:
   - **Site URL**: `https://docsbuddy.mytechbytes.in`
     (the default `http://localhost:3000` is where users land if a redirect is
     rejected — a tell-tale sign of a misconfiguration).
   - **Redirect URLs** → **Add URL**, add **both**:
     - `https://docsbuddy.mytechbytes.in/login-callback`
     - `in.mytechbytes.docsbuddy://login-callback`

     Supabase only redirects to URLs on this list.
   - **Save**.
4. **Authentication → Sign In / Providers → Email**: keep enabled. Accounts
   with the same **verified** email are linked automatically, so a person who
   signed up with email and later taps “Continue with Google” (same address)
   gets one account, not two.

---

## Part 2 — Returning to the app (deep links)

After Supabase finishes, it opens the redirect URL. That URL must open the app.

### What the app uses today (`Env.authRedirectUrl`)

| Platform | Redirect | Status |
|---|---|---|
| Android | `https://docsbuddy.mytechbytes.in/login-callback` (App Link) | needs `assetlinks.json` hosted (below) |
| iOS | `in.mytechbytes.docsbuddy://login-callback` (custom scheme) | works now, no hosting needed |

The custom scheme is registered in `ios/Runner/Info.plist` and
`AndroidManifest.xml`; the https App Link intent-filter is in
`AndroidManifest.xml`.

### Android — make the https link open the app

1. Collect the **SHA-256 certificate fingerprints** of the keys that sign the
   builds you want sign-in to return to. In this project release builds are
   made on GitHub, so no keystore file is needed locally:

   | Build | Signed by | Where to get the SHA-256 |
   |---|---|---|
   | Installed from **Google Play** (all users) | Google's **app signing key** | Play Console → your app → **Protected with Play → Play Store protection → Protect app signing key** (or **Manage Play app signing**) → *App signing key certificate* → **SHA-256 certificate fingerprint**. **Required.** |
   | GitHub-built AAB/APK installed directly (not via Play) | your **upload key** (repo secret `ANDROID_KEYSTORE_BASE64`) | Same Play Console page → *Upload key certificate* → **SHA-256**. Optional. |
   | **Android Studio** debug runs | the **debug key** on your Mac | see below. Optional (local testing only). |

   *(Older Play Console: Test and release → App integrity → App signing.)*

   **Debug key.** `~/.android/debug.keystore` does not exist until you first
   run the app on an Android emulator/device from Android Studio — do that
   once, then either:
   - Android Studio → **Gradle** panel → `app` → **Tasks → android →
     signingReport** (the *debug* variant's `SHA-256`), or
   - from a terminal:
     ```bash
     cd android && ./gradlew signingReport
     ```
     or
     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android
     ```
   Each developer's Mac has its own debug key — add every one you need.

   > **Keep a backup of the upload keystore.** GitHub never reveals a secret's
   > value again, so the `.jks` and its passwords should also live in the team
   > password manager. If they are lost, Play App Signing lets you replace the
   > upload key — see `docs/play-store-release.md` → *upload key reset*.
2. Host this file at `https://docsbuddy.mytechbytes.in/.well-known/assetlinks.json`
   (one entry per fingerprint from step 1 — app signing key first):
   ```json
   [{
     "relation": ["delegate_permission/common.handle_all_urls"],
     "target": {
       "namespace": "android_app",
       "package_name": "in.mytechbytes.docsbuddy",
       "sha256_cert_fingerprints": ["AA:BB:…:FF"]
     }
   }]
   ```
   Served over **HTTPS**, `Content-Type: application/json`, **no redirects**.
3. Check it: <https://developers.google.com/digital-asset-links/tools/generator>
   (enter domain, package, fingerprint → **Test statement**), and on a device:
   ```bash
   adb shell pm get-app-links in.mytechbytes.docsbuddy
   ```
   The domain should show `verified`. (Re-install the app after hosting the
   file; Android verifies at install time.)

Until this is hosted, Android sign-in returns to the **website**. As a stop-gap
you can build Android with the custom scheme by changing
`Env.authRedirectUrl` to return `authRedirectScheme` for Android too.

### iOS — optional: switch to Universal Links

The custom scheme already works. Universal links are nicer (they can't be
claimed by another app) and are required if you want the email-confirmation
link to open the app from the https domain.

1. **Apple Developer → Certificates, Identifiers & Profiles → Identifiers** →
   `in.mytechbytes.docsbuddy` → enable **Associated Domains** → **Save**.
2. **Xcode** → `ios/Runner.xcworkspace` → target **Runner** → **Signing &
   Capabilities** → **+ Capability** → **Associated Domains**. Xcode picks up
   `Runner/Runner.entitlements`, which already contains
   `applinks:docsbuddy.mytechbytes.in`.
3. Host `https://docsbuddy.mytechbytes.in/.well-known/apple-app-site-association`
   (no file extension, `Content-Type: application/json`, no redirects):
   ```json
   {
     "applinks": {
       "details": [{
         "appIDs": ["PAB3TLAUZH.in.mytechbytes.docsbuddy"],
         "components": [{ "/": "/login-callback*" }]
       }]
     }
   }
   ```
4. Set `"IOS_UNIVERSAL_LINKS": "true"` in `config/dev.json` (and pass
   `--dart-define=IOS_UNIVERSAL_LINKS=true` in the release workflow) so the app
   uses the https redirect, then run as usual:
   ```bash
   flutter run --dart-define-from-file=config/dev.json
   ```
5. Check: install the build, then paste
   `https://docsbuddy.mytechbytes.in/login-callback` into Notes on the device
   and long-press it — **Open in DocsBuddy** should be offered. (Apple's CDN
   caches the file; changes can take up to 24 h.)

---

## Part 3 — Google

### 3.1 Google Cloud Console

1. Open <https://console.cloud.google.com>. In the project picker, select the
   project used for Firebase (the one behind `google-services.json`) or
   **New project** → name `DocsBuddy` → **Create**.
2. Open **Google Auth Platform** (older UI: **APIs & Services → OAuth consent
   screen**). If prompted, click **Get started**.
3. **Branding** (App information):
   - **App name**: `DocsBuddy`
   - **User support email**: your support address
   - **App logo**: optional (a logo triggers Google's brand verification)
   - **App domain** → Home page `https://docsbuddy.mytechbytes.in`, Privacy
     policy and Terms links (required before publishing)
   - **Authorized domains**: add `mytechbytes.in` and `supabase.co`
   - **Developer contact email** → **Save**.
4. **Audience**:
   - **User type**: **External** (anyone with a Google account).
   - While the app is in **Testing**, only the **Test users** you add here can
     sign in (max 100) — add your own account now.
   - When ready for everyone: **Publish app** → status **In production**.
     With only the basic scopes below, no Google review is needed.
5. **Data Access** → **Add or remove scopes** → select
   `.../auth/userinfo.email`, `.../auth/userinfo.profile`, `openid` →
   **Update** → **Save**. Do not add other scopes.
6. **Clients** (older UI: **APIs & Services → Credentials → Create credentials →
   OAuth client ID**):
   - **Application type**: **Web application** — *not* Android/iOS; Supabase
     runs the exchange server-side.
   - **Name**: `docsbuddy-supabase`
   - **Authorized JavaScript origins**: leave empty.
   - **Authorized redirect URIs** → **Add URI** →
     `https://<ref>.supabase.co/auth/v1/callback`
   - **Create** → copy the **Client ID** and **Client secret**
     (download the JSON as a backup).

### 3.2 Supabase

1. **Authentication → Sign In / Providers → Google** → toggle **Enable Sign in
   with Google**.
2. **Client IDs**: paste the Client ID (comma-separate if you later add native
   Android/iOS client IDs).
3. **Client Secret (for OAuth)**: paste the secret.
4. Leave **Skip nonce checks** off.
5. **Save**.

### 3.3 Check

App → **Continue with Google** → Google account chooser → consent screen shows
*DocsBuddy* → back in the app on the dashboard. Supabase → **Authentication →
Users** shows the account with provider **google**.

---

## Part 4 — Apple

Requires a **paid Apple Developer Program** membership. App Store Review
Guideline 4.8: an iOS app that offers Google (or Microsoft) sign-in must also
offer Sign in with Apple.

### 4.1 Apple Developer — App ID

1. <https://developer.apple.com/account> → **Certificates, Identifiers &
   Profiles → Identifiers**.
2. Select the App ID **`in.mytechbytes.docsbuddy`** (create it if missing:
   **+** → **App IDs** → **App** → Bundle ID *Explicit*
   `in.mytechbytes.docsbuddy`).
3. **Capabilities** → tick **Sign In with Apple** → **Edit** → *Enable as a
   primary App ID* → **Save** → **Save**.

### 4.2 Apple Developer — Services ID (the web client)

1. **Identifiers** → **+** → **Services IDs** → **Continue**.
2. **Description**: `DocsBuddy Sign in`; **Identifier**:
   `in.mytechbytes.docsbuddy.signin` → **Continue** → **Register**.
   *(Must differ from the bundle ID. This is the **Client ID** Supabase uses.)*
3. Open the new Services ID → tick **Sign In with Apple** → **Configure**:
   - **Primary App ID**: `in.mytechbytes.docsbuddy`
   - **Domains and Subdomains**: `<ref>.supabase.co` (no `https://`)
   - **Return URLs**: `https://<ref>.supabase.co/auth/v1/callback`
   - **Next** → **Done** → **Continue** → **Save**.

### 4.3 Apple Developer — Signing key

1. **Keys** → **+**.
2. **Key Name**: `DocsBuddy Sign in with Apple`; tick **Sign in with Apple** →
   **Configure** → Primary App ID `in.mytechbytes.docsbuddy` → **Save** →
   **Continue** → **Register**.
3. **Download** the `AuthKey_<KEYID>.p8` file — **it can be downloaded only
   once**. Note the **Key ID**. Your **Team ID** is top-right in the account
   (`PAB3TLAUZH`).

### 4.4 Generate the client secret (JWT)

Apple doesn't issue a static secret: you sign a JWT with the `.p8` key. It is
valid for **at most 6 months**.

Option A — the generator in Supabase's *Login with Apple* docs (enter Team ID,
Services ID, Key ID and the `.p8` contents).

Option B — locally with Node (keeps the key on your machine):
```bash
mkdir apple-secret && cd apple-secret && npm init -y && npm i jsonwebtoken
```
Create `gen.js`:
```js
const fs = require('fs');
const jwt = require('jsonwebtoken');

const teamId = 'PAB3TLAUZH';
const keyId = 'XXXXXXXXXX';                        // from step 4.3
const servicesId = 'in.mytechbytes.docsbuddy.signin';
const privateKey = fs.readFileSync('AuthKey_XXXXXXXXXX.p8');

const now = Math.floor(Date.now() / 1000);
console.log(jwt.sign(
  { iss: teamId, iat: now, exp: now + 15777000, aud: 'https://appleid.apple.com', sub: servicesId },
  privateKey,
  { algorithm: 'ES256', keyid: keyId },
));
```
```bash
node gen.js
```
Copy the printed token. Record today's date + 6 months as the expiry.

### 4.5 Supabase

1. **Authentication → Sign In / Providers → Apple** → **Enable Sign in with
   Apple**.
2. **Client IDs**: `in.mytechbytes.docsbuddy.signin` (add
   `in.mytechbytes.docsbuddy` too if native iOS sign-in is added later).
3. **Secret Key (for OAuth)**: paste the JWT from 4.4.
4. **Save**.

### 4.6 Things to know

- Apple sends the user's **name only on the very first sign-in**; later
  sign-ins return just the email.
- Users may choose **Hide My Email** → a `@privaterelay.appleid.com` address.
  To send them email (e.g. reminders), register your sending domain/address
  under **Certificates, Identifiers & Profiles → Services → Sign in with Apple
  for Email Communication**.
- Deleting an account in-app should also revoke the Apple token (App Store
  requirement for apps with account deletion).

### 4.7 Check

App → **Continue with Apple** → Apple ID page → back in the app. Supabase →
**Users** shows provider **apple**.

---

## Part 5 — Microsoft

Supabase calls this provider **Azure**; it covers personal Microsoft accounts
(Outlook, Hotmail, Xbox) and work/school accounts (Microsoft Entra ID).

### 5.1 Microsoft Entra — register the app

1. <https://entra.microsoft.com> (or Azure portal → **Microsoft Entra ID**) →
   **Identity → Applications → App registrations** → **New registration**.
2. **Name**: `DocsBuddy`.
3. **Supported account types**: **Accounts in any organizational directory
   (Any Microsoft Entra ID tenant — Multitenant) and personal Microsoft
   accounts (e.g. Skype, Xbox)**.
4. **Redirect URI**: platform **Web** →
   `https://<ref>.supabase.co/auth/v1/callback`.
5. **Register**. On **Overview**, copy the **Application (client) ID**.

### 5.2 Client secret

1. **Certificates & secrets → Client secrets → New client secret**.
2. **Description**: `supabase`; **Expires**: 24 months (the maximum offered;
   put the date in the calendar).
3. **Add** → copy the **Value** column immediately (it is hidden after you
   leave the page). Do **not** use the *Secret ID*.

### 5.3 Permissions and claims

1. **API permissions** → confirm **Microsoft Graph → User.Read (Delegated)**
   exists → **Add a permission → Microsoft Graph → Delegated permissions** →
   tick `openid`, `email`, `profile` → **Add permissions**. No admin consent
   is needed for these.
2. **Token configuration → Add optional claim** → token type **ID** → tick
   `email` and `xms_edov` → **Add**. If asked, tick *Turn on the Microsoft
   Graph email permission* → **Add**.
   - `email` makes sure Supabase receives the address (the app also requests
     the `email` scope).
   - `xms_edov` tells Supabase whether the domain owner verified that email,
     so accounts are only auto-linked when it is safe.
3. Optional but recommended for public apps: **Branding & properties** → set
   the logo, home page, terms and privacy URLs, and complete **Publisher
   verification** (links a Microsoft Partner Network ID) so users don't see an
   *unverified* warning on the consent screen.

### 5.4 Supabase

1. **Authentication → Sign In / Providers → Azure** → **Enable Sign in with
   Azure**.
2. **Application (client) ID**: from 5.1.
3. **Secret Value**: the **Value** from 5.2.
4. **Azure Tenant URL**:
   - everyone (personal + any organisation):
     `https://login.microsoftonline.com/common`
   - only one organisation: `https://login.microsoftonline.com/<tenant-id>`
     (and pick *single tenant* in 5.1).
5. **Save**.

### 5.5 Check

App → **Continue with Microsoft** → Microsoft sign-in → consent screen lists
*DocsBuddy* → back in the app. Supabase → **Users** shows provider **azure**.

---

## Part 6 — Test every provider

Run a Supabase build (values from Part 1, step 2):
```bash
flutter run --dart-define-from-file=config/dev.json
```

For **each** of Google, Apple and Microsoft, on **both** Android and iOS:

| Step | Expected |
|---|---|
| Tap the button on **Sign in** | Browser opens the provider's page |
| Sign in / consent | Browser closes, app opens on the **Dashboard** |
| Supabase → Authentication → **Users** | New user with the matching provider |
| Table **public.users** | A row for the user (created by `handle_new_user`) |
| Sign out, sign in again | Straight back in, same user |
| Same email as an existing email/password account | Same user, second identity listed |

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Lands on `localhost:3000` or the website instead of the app | Redirect URL not allowed, or link not verified | Part 1 step 3; Android `assetlinks.json` / iOS setup in Part 2 |
| Google: `Error 400: redirect_uri_mismatch` | Redirect URI in the Google client ≠ Supabase callback | Copy the exact `https://<ref>.supabase.co/auth/v1/callback` (no trailing slash) |
| Google: “Access blocked: app has not completed verification” / only some users can sign in | Consent screen in **Testing** | Add test users or **Publish app** |
| Apple: `invalid_client` | Wrong Services ID, domain/return URL mismatch, or **expired JWT** | Re-check 4.2; regenerate the secret (4.4) |
| Apple: page says “Sign Up Not Completed” | Services ID not linked to the primary App ID, or key not enabled for it | Re-check 4.1–4.3 |
| Microsoft: `AADSTS50011` (reply URL mismatch) | Redirect URI missing or not type **Web** | 5.1 step 4 |
| Microsoft: `AADSTS7000215` (invalid client secret) | Used the Secret **ID**, or the secret expired | 5.2 — paste the **Value**, create a new one |
| Microsoft: personal accounts rejected | Account type set to single/multi-tenant only | 5.1 step 3; tenant URL `common` |
| Supabase: “Error getting user email from external provider” | Provider didn't return an email | Google: email scope (3.1.5); Apple: normal after first sign-in only if email was hidden; Microsoft: optional `email` claim (5.3) |
| Button does nothing / error snackbar | Provider not enabled in Supabase, or app run without `config/dev.json` (fake backend — Settings → App → Backend shows *Local (fake)*) | Part 1 step 2; enable the provider |

Supabase → **Logs → Auth** shows the exact error for a failed attempt.

---

## Maintenance calendar

| What | When | Action |
|---|---|---|
| Apple client-secret JWT | every **6 months** | Re-run 4.4, paste into Supabase 4.5 |
| Microsoft client secret | at its expiry (≤ 24 months) | Create a new secret (5.2), paste into Supabase, delete the old one |
| Google OAuth client | no expiry | Keep the consent-screen links (privacy, terms) valid |
| `assetlinks.json` | when the signing key changes | Add the new SHA-256 |
