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
fire locally without it. It needs a Firebase project, so it's not wired yet
(adding the google-services plugin without the config file breaks the build).

### Step by step

1. **Create a Firebase project** → <https://console.firebase.google.com>.
2. **Add an Android app**, package name **`in.mytechbytes.docsbuddy`**. Download
   **`google-services.json`** → put it in **`android/app/`**.
3. *(iOS, later)* Add an iOS app, download **`GoogleService-Info.plist`**, add it
   to `ios/Runner/` via Xcode.
4. **Gradle** — apply the Google services plugin:
   - `android/settings.gradle.kts` plugins block:
     `id("com.google.gms.google-services") version "4.4.2" apply false`
   - `android/app/build.gradle.kts` plugins block:
     `id("com.google.gms.google-services")`
5. **pubspec** — add `firebase_core` and `firebase_messaging`, then `flutter pub get`.
   Run `flutterfire configure` (FlutterFire CLI) to generate `firebase_options.dart`.
6. **Init + token** in `main()`:
   ```dart
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   await FirebaseMessaging.instance.requestPermission();
   final token = await FirebaseMessaging.instance.getToken();
   // upsert into Supabase user_devices(user_id, fcm_token, platform)
   ```
7. **Handle messages** — on a `data` message, refresh the catalog / reschedule:
   ```dart
   FirebaseMessaging.onMessage.listen((m) => /* invalidate catalog providers */);
   FirebaseMessaging.onBackgroundMessage(_bgHandler); // top-level fn
   ```
8. **Send a silent push** from a Supabase Edge Function when a row changes
   (Realtime/trigger → FCM `data` message to the family's device tokens).

Until you do the above, leave `firebase_*` out of `pubspec.yaml` so the build
stays green.
