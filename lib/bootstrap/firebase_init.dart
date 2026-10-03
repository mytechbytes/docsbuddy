import 'package:firebase_core/firebase_core.dart';

/// Initialises Firebase once for the whole app (Crashlytics + push). False
/// when this platform has no Firebase config (e.g. iOS without
/// GoogleService-Info.plist, desktop). The logger that uses it lives in
/// `core/logging`.
Future<bool> initFirebase() async {
  if (Firebase.apps.isNotEmpty) return true; // already up (e.g. a startup retry)
  try {
    await Firebase.initializeApp();
    return true;
  } catch (_) {
    return false; // No logger exists yet; callers fall back to the console.
  }
}
