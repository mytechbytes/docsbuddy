# Notifications setup

## What's already done (no setup needed)

**On-device reminder notifications** are implemented and need no backend:
- `core/notifications/notification_service.dart` schedules OS-level local
  notifications at the 30/7/1/0-day thresholds (09:00 local) for upcoming
  reminders, re-arming whenever the reminder set changes.
- Android manifest has `POST_NOTIFICATIONS` + the reboot receiver; gradle has
  core-library desugaring (both required by `flutter_local_notifications`).
- Settings → **Enable reminders** requests permission and fires a test.

This already delivers the "never miss a renewal" promise offline. The only
user-facing step: **tap Settings → Enable reminders** once to grant permission.

> iOS extra (when you build iOS): in `ios/Runner/AppDelegate.swift` add
> `UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate`
> in `didFinishLaunching` so notifications present in the foreground.

## FCM (optional — cross-device + future server push)

Per the local-first design, FCM is only **silent data pushes** that wake the app
to sync when *another family member* changes something. It's optional; reminders
fire locally without it.

### ✅ Now wired (Android)

- `android/app/google-services.json` + the `com.google.gms.google-services`
  Gradle plugin (app + settings).
- `firebase_core` + `firebase_messaging` in `pubspec.yaml`.
- `lib/core/notifications/fcm_service.dart` — initialises Firebase, requests
  permission, **registers the device token into Supabase `user_devices`**, and on
  a foreground message refreshes the catalog. A top-level background handler is
  registered. Started from `HomeShell` after sign-in (all guarded, so platforms
  without config are a no-op).

Nothing else to do for Android to *receive* pushes.

### Still on you

1. **iOS** (when you ship it): add an iOS app in Firebase → download
   **`GoogleService-Info.plist`** into `ios/Runner/` (via Xcode), enable the
   **Push Notifications** + **Background Modes → Remote notifications**
   capabilities, and upload an **APNs key** in Firebase → Cloud Messaging.
2. **Sending the pushes** — scaffolded at **`supabase/functions/notify-family`**
   (service-account walkthrough: `docs/service-credentials.md`).
   Set the `FIREBASE_SERVICE_ACCOUNT` secret, `supabase functions deploy
   notify-family`, then add a **Database Webhook** on `asset_dates`/`assets`/
   `documents` → the function. Full steps in that folder's README.
3. **Test:** Firebase Console → Cloud Messaging → send a test message to the
   device token (printed/registered on first run).
