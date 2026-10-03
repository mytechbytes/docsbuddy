# Features that aren't connected yet

Some controls are built in the app but need something **outside** the app before
they do anything — a deployed Edge Function, a provider account. Offering a
switch that silently does nothing is worse than not offering it, so each one is
**off** until its backend is ready, and the UI shows it disabled with
"Coming soon".

`lib/core/features/app_feature.dart` is the one place that lists them:

| Feature | Where it shows | Needs before it is on | Build flag |
|---|---|---|---|
| `pushReminders` | Settings → Push notifications | Nothing reads this preference yet: reminders are scheduled on the device regardless, and `notify-family` (a silent sync wake) ignores it. Decide what it should control, then wire it | `FEATURE_PUSH_REMINDERS` |
| `emailReminders` | Settings → Email reminders | Deploy `send-reminders-email` + Resend secrets + the daily cron (`supabase/schedules.sql`) | `FEATURE_EMAIL_REMINDERS` |
| `whatsappReminders` | Settings → WhatsApp reminders | Deploy `send-reminders-whatsapp` + Meta API secrets + the daily cron | `FEATURE_WHATSAPP_REMINDERS` |
| `appleSignIn` | Sign in / Sign up | Apple Services ID + Supabase setup ([social-sign-in.md](social-sign-in.md) Part 4) | `FEATURE_APPLE_SIGN_IN` |
| `microsoftSignIn` | Sign in / Sign up | Entra app + Supabase setup ([social-sign-in.md](social-sign-in.md) Part 5) | `FEATURE_MICROSOFT_SIGN_IN` |

While a feature is off its switch is dimmed, shown **off** (even if an earlier
choice was saved — nothing would be sent), and can't change the saved preference.
Turning it on later restores whatever the person had chosen.

## Turning one on

When the backend is deployed and tested, enable it **without a code change**:

- **CI / Play release:** add a repository *variable* (GitHub → Settings → Secrets
  and variables → Actions → **Variables**) named as in the table, value `true`.
  `release-aab.yml` and `build.yml` pass it to the build. Unset = off.
- **Local:** `flutter run --dart-define=FEATURE_EMAIL_REMINDERS=true …`
- **For everyone:** change the feature's default in `app_feature.dart` and delete
  its flag.

## Adding a feature to this list

Add a value to `AppFeature` with its own `FEATURE_*` flag, render its control with
`FeatureToggleRow(live: AppFeature.x.live, …)` (or gate a button on `.live`), and
add the flag to the two workflow files. `app_feature_test.dart` fails if anything
here is on by default.
