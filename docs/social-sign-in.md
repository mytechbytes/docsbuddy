# Social sign-in (Google, Apple, Microsoft)

The app uses Supabase browser OAuth (`signInWithOAuth`): provider → Supabase
callback → app redirect. `<ref>` is your Supabase project ref; every provider
uses the callback `https://<ref>.supabase.co/auth/v1/callback`.

## Supabase (once)
Authentication → URL Configuration
- Site URL: `https://docsbuddy.mytechbytes.in`
- Redirect URLs: `https://docsbuddy.mytechbytes.in/login-callback` and
  `in.mytechbytes.docsbuddy://login-callback`

Redirect used by the app (`Env.authRedirectUrl`):
- Android: the https App Link (host `/.well-known/assetlinks.json`).
- iOS: the custom scheme, until Associated Domains is enabled in Xcode and
  `/.well-known/apple-app-site-association` is hosted — then build with
  `--dart-define=IOS_UNIVERSAL_LINKS=true`.

## Google
Google Cloud Console → OAuth consent screen (External; authorized domains
`supabase.co`, `mytechbytes.in`; scopes openid/email/profile; publish) →
Credentials → OAuth client ID, type **Web application**, redirect URI = the
Supabase callback. Supabase → Providers → Google: client ID + secret.

## Apple (paid developer account; required on iOS if Google is offered)
Certificates, Identifiers & Profiles:
1. App ID `in.mytechbytes.docsbuddy` → enable Sign In with Apple.
2. Services ID (e.g. `in.mytechbytes.docsbuddy.signin`) → Sign In with Apple →
   domain `<ref>.supabase.co`, return URL = the Supabase callback.
3. Key with Sign In with Apple → download `.p8`, note Key ID + Team ID.
4. Generate the client-secret JWT (Supabase docs) — **expires after ≤ 6 months**.

Supabase → Providers → Apple: Client IDs = the Services ID (plus the bundle ID
if native sign-in is added later); Secret = the JWT.

## Microsoft (Supabase provider "Azure")
Entra admin center → App registrations → New registration:
- Accounts in any organizational directory **and personal Microsoft accounts**
- Redirect URI (Web) = the Supabase callback
- Certificates & secrets → client secret (copy the **Value**, note expiry)
- API permissions: openid, email, profile, User.Read (delegated)
- Token configuration → optional claim `email` (ID token)

Supabase → Providers → Azure: Application (client) ID, secret, tenant URL
`https://login.microsoftonline.com/common` (or your tenant to restrict).
The app requests the `email` scope for this provider.

## Verify
Run with `--dart-define=SUPABASE_URL=… --dart-define=SUPABASE_ANON_KEY=…`, tap
each button, confirm you land on the dashboard and the user appears under
Authentication → Users with the right provider. Landing on a web page instead
of the app means a redirect-URL or link-verification problem.
