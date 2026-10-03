import 'package:firebase_core/firebase_core.dart';

/// Initialises Firebase once (Crashlytics + push); false when the platform has no Firebase config
/// (e.g. iOS without GoogleService-Info.plist, desktop).
Future<bool> initFirebase() async {
  if (Firebase.apps.isNotEmpty) return true; // already up (e.g. a startup retry)
  try {
    await Firebase.initializeApp();
    return true;
  } catch (_) {
    return false; // No logger exists yet; callers fall back to the console.
  }
}
