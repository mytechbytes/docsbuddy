# Releasing to Google Play (internal testing)

What this repo gives you: a Play-ready **versioned, signable AAB** and a CI job to
build it. What only **you** can do (your Google account): create the Play listing,
upload, and roll out. Steps below cover both.

> **Prerequisite:** merge the network-permission fix (PR #6) first, or the
> released build can't reach Supabase.

## 0. Version

`pubspec.yaml` → `version: 2.0.62+30` → **versionName 2.0.62**, **versionCode 30**
(your previous upload was 29 / 2.0.61; Play requires the code to increase every
upload). Bump the `+NN` build number for each new upload.

## 1. Create an upload keystore (once)

```bash
keytool -genkey -v -keystore ~/docsbuddy-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Keep this file + passwords **safe and private** — losing it means you can't update
the app (unless you use Play App Signing, which is recommended; see step 4).

## 2a. Build the AAB locally

Create `android/key.properties` (already gitignored — never commit it):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/absolute/path/to/docsbuddy-upload.jks
```

Then:

```bash
flutter build appbundle --release \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_KEY
# → build/app/outputs/bundle/release/app-release.aab
```

`android/app/build.gradle.kts` reads `key.properties` and signs `release` with it
(falling back to debug only when the file is absent).

## 2b. …or build it in CI

Workflow **`.github/workflows/release-aab.yml`** (manual: Actions → *Release AAB
(manual)* → Run workflow) builds the signed AAB and uploads it as the
`docsbuddy-release-aab` artifact. Add these repo secrets first
(**Settings → Secrets and variables → Actions**):

| Secret | Value |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 ~/docsbuddy-upload.jks` (the keystore, base64-encoded) |
| `ANDROID_KEYSTORE_PASSWORD` | store password |
| `ANDROID_KEY_ALIAS` | `upload` |
| `ANDROID_KEY_PASSWORD` | key password |
| `SUPABASE_URL` / `SUPABASE_ANON_KEY` | (optional) bake the backend in |

```bash
# produce the base64 secret value:
base64 -w0 ~/docsbuddy-upload.jks   # macOS: base64 -i ~/docsbuddy-upload.jks
```

## 3. Create the app + internal testing track (Play Console)

1. <https://play.google.com/console> → **Create app** (or open the existing
   `in.mytechbytes.docsbuddy` app — the package **must match**).
2. **Testing → Internal testing → Create new release**.
3. Upload `app-release.aab`.
4. Add testers (an email list or a Google Group), save, **Review release →
   Start rollout to Internal testing**.
5. Share the opt-in link with testers; they install via Play.

> Faster ad-hoc option: **Internal app sharing** accepts an AAB/APK and gives a
> direct install link without a full release — good for quick smoke tests.

## 4. Play App Signing (recommended)

When prompted, **let Google manage the app signing key**. You then only hold the
**upload** key (the one above); if you ever lose it, Google can reset it. The
keystore in this guide becomes your *upload* key.

## 5. First-upload extras Play will ask for

Privacy policy URL, data-safety form, content rating, target audience, and a few
store-listing assets (icon, screenshots). These are one-time and live in the
Console, not the repo.

## Push directly from GitHub to Play (auto-deploy)

The `Release AAB + Play deploy (manual)` workflow already includes the upload
step — it runs **only when** the `PLAY_SERVICE_ACCOUNT_JSON` secret is set
(otherwise it just produces the AAB artifact). Set it up once:

1. **Create a service account** (Google Cloud):
   - In the project linked to your Play account: **IAM & Admin → Service
     Accounts → Create**. Name it e.g. `play-publisher`. No GCP roles needed.
   - On the account → **Keys → Add key → JSON** → download the JSON.
2. **Enable the API:** in Google Cloud, enable **Google Play Android Developer
   API** for that project.
3. **Grant Play access:** Play Console → **Users & permissions → Invite new
   user** → paste the service-account email → grant app access with at least
   **Release to testing tracks** (and **Release to production** if you want that
   track). Save.
4. **Add the GitHub secret:** repo → Settings → Secrets and variables → Actions →
   `PLAY_SERVICE_ACCOUNT_JSON` = the **entire JSON file contents**.
5. **Run it:** Actions → *Release AAB + Play deploy (manual)* → **Run workflow**,
   pick the **track** (default `internal`). It builds the signed AAB and uploads
   it to that track.

> **First upload must be manual.** Google requires the very first AAB for a new
> app to be uploaded through the Console (step 3 of the manual flow above). After
> that one manual upload, the API/workflow can publish every subsequent build.

## Lost your upload key?

What you can recover depends on **Play App Signing** (step 4):

- **If Play App Signing is enabled** (recommended, and the default for new apps):
  the key you lost is only the **upload key** — it's resettable.
  1. Generate a **new** keystore (step 1 above).
  2. Export its certificate:
     ```bash
     keytool -export -rfc -keystore ~/docsbuddy-upload.jks \
       -alias upload -file upload_certificate.pem
     ```
  3. Play Console → your app → **Test and release → App integrity → App signing
     → Request upload key reset**, upload `upload_certificate.pem`. Google
     approves it (often within a day or two).
  4. Update the GitHub secrets to the new keystore (below). The **app signing
     key Google holds is unchanged**, so existing installs keep updating.

- **If Play App Signing is NOT enabled** and you lost the **app signing** key:
  that key is unrecoverable and you **cannot update** that listing — you'd have
  to publish a **new app with a new `applicationId`**. (Strongly consider
  enabling Play App Signing on the new app to avoid this.)

### Point GitHub at the new key

After creating the new keystore, just refresh the four signing secrets — no code
change needed:

```bash
base64 -w0 ~/docsbuddy-upload.jks   # → ANDROID_KEYSTORE_BASE64  (macOS: base64 -i ...)
```

Update in **Settings → Secrets and variables → Actions**:
`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`,
`ANDROID_KEY_PASSWORD`. The next workflow run signs with the new key.
