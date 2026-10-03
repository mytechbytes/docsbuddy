# Social sign-in: Google, Apple and Microsoft

Step-by-step setup for the three social buttons on the Sign in / Sign up
screens. Nothing here requires code changes — the app side is already built;
this is console + Supabase configuration.

> **Current status:** Google is live. The **Apple** and **Microsoft** buttons are
> shown but **disabled** in the app until Parts 4 and 5 are done — then flip the
> provider's `enabled` flag in `SocialProvider`
> (`lib/features/auth/presentation/widgets/auth_widgets.dart`).

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

After Supabase completes the provider authentication in the external browser, it redirects back to the configured redirect URL (`Env.authRedirectUrl`). That deep link must be intercepted by the operating system and passed directly to DocsBuddy.

---

### How deep link handling works in DocsBuddy

```
┌──────────────────────────────────────────────────────────────────────────┐
│ 1. App calls signInWithOAuth() with redirectTo                           │
│    └─► Browser opens Supabase /authorize ──► Provider OAuth login page   │
│                                                                          │
│ 2. Provider authenticates user ──► Supabase /callback                    │
│                                                                          │
│ 3. Supabase issues session ──► Redirects browser to authRedirectUrl      │
│    (e.g., https://docsbuddy.mytechbytes.in/login-callback#access_token=…) │
│                                                                          │
│ 4. OS intercepts URL (App Link / Universal Link / Custom Scheme)        │
│    └─► Opens MainActivity / Runner (launchMode="singleTop")             │
│                                                                          │
│ 5. supabase_flutter (via app_links plugin) intercepts tokens             │
│    └─► Stores session in SecureLocalStorage / SecurePkceStorage         │
│    └─► Triggers onAuthStateChange ──► App opens Dashboard               │
└──────────────────────────────────────────────────────────────────────────┘
```

#### Codebase Configuration (`lib/core/config/env.dart`)

```dart
static const authRedirectAppLink = 'https://docsbuddy.mytechbytes.in/login-callback';
static const authRedirectScheme  = 'in.mytechbytes.docsbuddy://login-callback';

static String get authRedirectUrl =>
    defaultTargetPlatform == TargetPlatform.iOS && !_iosUniversalLinks
        ? authRedirectScheme
        : authRedirectAppLink;
```

- **Android**: Uses the HTTPS App Link (`authRedirectAppLink`). Falls back to `authRedirectScheme` if needed during local development.
- **iOS**: Uses the custom scheme (`authRedirectScheme`) by default. When `--dart-define=IOS_UNIVERSAL_LINKS=true` is passed, it switches to the HTTPS Universal Link (`authRedirectAppLink`).

---

### Platform Summary

| Platform | Redirect URL | Type | Requirement / Status |
|---|---|---|---|
| **Android** | `https://docsbuddy.mytechbytes.in/login-callback` | **App Link** | Requires `assetlinks.json` hosted on your domain. |
| **Android (Fallback)** | `in.mytechbytes.docsbuddy://login-callback` | **Custom Scheme** | Registered in `AndroidManifest.xml`. Works without web hosting. |
| **iOS (Default)** | `in.mytechbytes.docsbuddy://login-callback` | **Custom Scheme** | Registered in `Info.plist`. Works out-of-the-box without web hosting. |
| **iOS (Production)** | `https://docsbuddy.mytechbytes.in/login-callback` | **Universal Link** | Requires `apple-app-site-association` hosted + Xcode entitlement. |

---

### Native Manifest & Plist Registrations

#### 1. Android (`android/app/src/main/AndroidManifest.xml`)

`MainActivity` is configured with `android:launchMode="singleTop"` so deep links deliver directly to the running instance without re-creating the Activity stack.

```xml
<!-- Verified HTTPS App Link -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="https"
          android:host="docsbuddy.mytechbytes.in"
          android:pathPrefix="/login-callback"/>
</intent-filter>

<!-- Custom Scheme Fallback -->
<intent-filter android:autoVerify="false">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="in.mytechbytes.docsbuddy" android:host="login-callback"/>
</intent-filter>
```

#### 2. iOS (`ios/Runner/Info.plist` & `Runner.entitlements`)

In `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>in.mytechbytes.docsbuddy</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>in.mytechbytes.docsbuddy</string>
        </array>
    </dict>
</array>
```

In `ios/Runner/Runner.entitlements`:
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:docsbuddy.mytechbytes.in</string>
</array>
```

#### 3. Keep Flutter from routing the callback

`supabase_flutter` reads the callback link itself (via `app_links`). Flutter
would otherwise *also* push the same URL into `go_router`, which has no such
route and shows **Page Not Found** right after sign-in. Both platforms opt out:

```xml
<!-- ios/Runner/Info.plist -->
<key>FlutterDeepLinkingEnabled</key>
<false/>
```

```xml
<!-- android/app/src/main/AndroidManifest.xml, inside <activity> -->
<meta-data android:name="flutter_deeplinking_enabled" android:value="false" />
```

---

### Android — Step-by-Step App Links Setup

Android App Links allow `https://docsbuddy.mytechbytes.in/login-callback` to open DocsBuddy directly without showing a domain choice dialog.

#### Step 1: Collect SHA-256 Fingerprints

Android requires the SHA-256 certificate fingerprints for every key signing your app builds:

| Build Type | Signed By | Where to Get SHA-256 |
|---|---|---|
| **Google Play Release** (All production users) | Google **App Signing Key** | Play Console → App → **Protected with Play → Play Store protection → App signing** → *App signing key certificate* → **SHA-256 certificate fingerprint**. (**Required**) |
| **GitHub CI Release Builds** (Direct AAB/APK) | **Upload Key** (`ANDROID_KEYSTORE_BASE64`) | Play Console → *Upload key certificate* → **SHA-256**. |
| **Android Studio Local Debug** | **Debug Key** (`debug.keystore`) | Terminal command or Gradle signing report (see below). |

**How to extract the local Debug Key SHA-256:**
Run either of the following commands from your project root:
```bash
# Option A: Via Gradle task
cd android && ./gradlew signingReport

# Option B: Via keytool
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```
Look for `SHA256:` under `Variant: debug`. Format: `AA:BB:CC:...:FF` (uppercase hex bytes separated by colons).

> **Upload Keystore Backup**: Always keep a backup of `docsbuddy-upload.jks` and its passwords in your team password manager. GitHub repository secrets cannot be retrieved after saving.

#### Step 2: Host `assetlinks.json`

Create and host a JSON file at exact URL:
`https://docsbuddy.mytechbytes.in/.well-known/assetlinks.json`

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "in.mytechbytes.docsbuddy",
      "sha256_cert_fingerprints": [
        "4A:8B:...:PlayAppSigningSHA256",
        "12:34:...:UploadKeySHA256",
        "FE:DC:...:DebugKeySHA256"
      ]
    }
  }
]
```

**HTTP Hosting Requirements:**
- URL: `https://docsbuddy.mytechbytes.in/.well-known/assetlinks.json`
- Protocol: **HTTPS** (valid SSL certificate required)
- HTTP Status: **200 OK**
- Content-Type: `application/json`
- **No HTTP redirects** (must not redirect 301/302 to www or another URL)
- Must be publicly accessible without authentication.

#### Step 3: Verify & Test Android App Links

1. **Verify Online Statement**:
   Use Google's Digital Asset Links Statement Generator & Tester:
   <https://developers.google.com/digital-asset-links/tools/generator>
   Enter Domain: `docsbuddy.mytechbytes.in`, Package: `in.mytechbytes.docsbuddy`, Fingerprint: `<SHA256>` → click **Test statement**.

2. **Verify on Device via ADB**:
   Re-install the app on a device or emulator (Android verifies App Links during package installation), then run:
   ```bash
   adb shell pm get-app-links in.mytechbytes.docsbuddy
   ```
   *Expected output:*
   ```text
   in.mytechbytes.docsbuddy:
     ID: ...
     Signatures: [...]
     Domain verification state:
       docsbuddy.mytechbytes.in: verified
   ```

   If status shows `legacy_failure` or `ask`, force a re-verification:
   ```bash
   adb shell pm verify-app-links --re-verify in.mytechbytes.docsbuddy
   ```

3. **Test Deep Link Navigation via ADB**:
   Test HTTPS App Link:
   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "https://docsbuddy.mytechbytes.in/login-callback#access_token=test" in.mytechbytes.docsbuddy
   ```
   Test Custom Scheme Fallback:
   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "in.mytechbytes.docsbuddy://login-callback#access_token=test" in.mytechbytes.docsbuddy
   ```

---

### iOS — Step-by-Step Universal Links Setup (Optional / Production)

The custom scheme (`in.mytechbytes.docsbuddy://login-callback`) works immediately out-of-the-box for iOS. Universal Links (`https://docsbuddy.mytechbytes.in/login-callback`) offer enhanced security and prevent other apps from claiming the scheme.

#### Step 1: Enable Associated Domains in Apple Developer Portal

1. Log into <https://developer.apple.com/account> → **Certificates, Identifiers & Profiles** → **Identifiers**.
2. Select App ID: `in.mytechbytes.docsbuddy`.
3. Under **Capabilities**, enable **Associated Domains**.
4. Click **Save**.

#### Step 2: Configure Xcode Capability

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select target **Runner** → **Signing & Capabilities**.
3. Click **+ Capability** → select **Associated Domains**.
4. Add entry: `applinks:docsbuddy.mytechbytes.in`.
   *(This updates `ios/Runner/Runner.entitlements`).*

#### Step 3: Host `apple-app-site-association` (AASA)

Host the AASA file at:
`https://docsbuddy.mytechbytes.in/.well-known/apple-app-site-association`

```json
{
  "applinks": {
    "details": [
      {
        "appID": "PAB3TLAUZH.in.mytechbytes.docsbuddy",
        "components": [
          {
            "/": "/login-callback*"
          }
        ]
      }
    ]
  }
}
```

**HTTP Hosting Requirements:**
- URL: `https://docsbuddy.mytechbytes.in/.well-known/apple-app-site-association`
- File name: `apple-app-site-association` (**No `.json` extension!**)
- Content-Type: `application/json` or `application/pkcs7-mime`
- Protocol: **HTTPS** (valid SSL certificate required)
- **No HTTP redirects**

> `PAB3TLAUZH` is your **Apple Team ID** (found top-right in Apple Developer Portal).

#### Step 4: Enable Universal Links in App Configuration

In `config/dev.json`:
```json
{
  "IOS_UNIVERSAL_LINKS": "true"
}
```

Or pass via command line:
```bash
flutter run --dart-define-from-file=config/dev.json --dart-define=IOS_UNIVERSAL_LINKS=true
```

#### Step 5: Test iOS Universal Links

1. **iOS Simulator CLI Test**:
   ```bash
   # Test Custom Scheme:
   xcrun simctl openurl booted "in.mytechbytes.docsbuddy://login-callback"

   # Test HTTPS Universal Link:
   xcrun simctl openurl booted "https://docsbuddy.mytechbytes.in/login-callback"
   ```

2. **Physical Device Test**:
   - Open Notes app or Safari on the iOS device.
   - Type or paste: `https://docsbuddy.mytechbytes.in/login-callback`
   - Long-press the link → verified options should show **"Open in DocsBuddy"**. Tapping it opens the app directly without Safari navigation.

> **Apple CDN Caching**: Apple caches AASA files on their CDN (`app-site-association.cdn-apple.com`). Updates can take up to 24 hours to propagate. For instant testing on iOS 14+, you can add `?mode=developer` to the entitlement:
> `<string>applinks:docsbuddy.mytechbytes.in?mode=developer</string>`

---

### Deep Link Troubleshooting Matrix

| Symptom / Issue | Cause | Resolution |
|---|---|---|
| **Android: Redirect lands on website in browser instead of opening app** | `assetlinks.json` not hosted, wrong SHA-256 fingerprint, or redirect present on website. | 1. Check `adb shell pm get-app-links in.mytechbytes.docsbuddy`.<br>2. Ensure `assetlinks.json` returns HTTP 200 without 301/302 redirects.<br>3. Verify SHA-256 fingerprint matches the exact key signing the build. |
| **Android: Works in local debug, fails in Play Store build** | Only debug key SHA-256 was added to `assetlinks.json`. | Play Store re-signs builds with Google Play App Signing key. Copy Play App Signing SHA-256 from Play Console into `assetlinks.json`. |
| **iOS: Custom scheme opens app, HTTPS link opens Safari** | Associated Domains not active, or AASA file cached/missing. | 1. Ensure the Associated Domains capability is active in Xcode **first** (otherwise leave `IOS_UNIVERSAL_LINKS` at `false` — see the next rows).<br>2. Confirm `apple-app-site-association` has no `.json` extension.<br>3. Then set `"IOS_UNIVERSAL_LINKS": "true"` in `config/dev.json`. |
| **App shows “Page Not Found — no routes for location …login-callback…” after sign-in** | Flutter's own deep-link handling forwards the callback URL to `go_router`. | Set `FlutterDeepLinkingEnabled` = `false` (iOS) / `flutter_deeplinking_enabled` = `false` (Android) — see *Native Manifest & Plist Registrations → 3*. Needs a full rebuild, not hot reload. |
| **iOS: stuck on an “Opening DocsBuddy…” sheet, and/or `Code verifier could not be found in local storage`** | `IOS_UNIVERSAL_LINKS` is `true` but the Associated Domains capability isn't enabled, so the https redirect can never open the app directly and falls back to the website's bridge page, which opens the app twice (automatically and on “Open the app”). The first delivery signs in and consumes the one-time verifier; the second finds none. | Keep `"IOS_UNIVERSAL_LINKS": "false"` until the capability is active. (The app also dismisses the sheet on sign-in and ignores the duplicate delivery.) |
| **Android (Play install, esp. a reinstall or a phone restored from a Google backup): “Couldn’t start DocsBuddy”, then after *Try again* the login screen appears but Google sign-in returns to the app and nothing happens** | The device holds secure-storage data it can’t decrypt: Auto Backup restored `FlutterSecureStorage.xml` / `FlutterSecureKeyStorage.xml`, but the Android Keystore key that protects them is never backed up (`InvalidKeyException: Failed to unwrap key`). Before this fix it crashed `Supabase.initialize`, and the retry then skipped starting the deep-link listener. | Fixed in the app: `SecureStore` (`lib/core/data/secure_store.dart`) drops an unreadable entry instead of throwing, a failed init is rolled back, and the secure-storage files are excluded from backup (`res/xml/backup_rules.xml`, `data_extraction_rules.xml`). On an affected build: **Settings → Apps → DocsBuddy → Storage → Clear data**. The failure screen now prints the real cause; Crashlytics records `Secure storage … failed` warnings. |
| **Android: returns to the app after Google sign-in but stays on the login screen** | The SDK could not turn the redirect into a session (missing code verifier, expired code, network lost mid-exchange). | The app now shows “Sign-in didn’t finish. Please try again.” and logs `Sign-in callback failed` with the underlying error to Crashlytics. A duplicate delivery of an already-consumed link is ignored when the user is signed in. |
| **Supabase: User lands on `localhost:3000` after sign-in** | Supabase **Site URL** or **Redirect URLs** misconfigured. | Open Supabase Dashboard → **Authentication → URL Configuration**:<br>- Set **Site URL** = `https://docsbuddy.mytechbytes.in`<br>- Add `https://docsbuddy.mytechbytes.in/login-callback`<br>- Add `in.mytechbytes.docsbuddy://login-callback` |
| **OAuth Error: `redirect_uri_mismatch`** | Provider console (Google/Apple/Microsoft) callback URL mismatch. | The OAuth provider console must be set to `https://<ref>.supabase.co/auth/v1/callback` (**NOT** `docsbuddy.mytechbytes.in`). Supabase handles the provider callback and then redirects to DocsBuddy. |

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
