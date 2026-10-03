import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Closes the in-app browser sheet that hosted an OAuth flow once the session is established.
/// When the redirect lands on the hosted `/login-callback` page the sheet stays on top of the app, leaving a
/// signed-in user on "Opening DocsBuddy…". Returns the subscription so the caller can cancel it.
StreamSubscription<AuthState> closeBrowserOnSignIn(
  Stream<AuthState> events, {
  Future<void> Function() close = closeInAppWebView,
}) {
  return events.listen(
    (state) async {
      if (state.event != AuthChangeEvent.signedIn) return;
      try {
        await close();
      } catch (_) {
        // Nothing to close, or the platform can't (e.g. Android Custom Tabs).
      }
    },
    // Callback failures are reported by the SDK; this listener only closes.
    onError: (Object _) {},
  );
}
