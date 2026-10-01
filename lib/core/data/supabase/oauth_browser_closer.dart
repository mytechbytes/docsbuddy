import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Dismisses the in-app browser sheet that hosted an OAuth flow once the
/// session is established.
///
/// When the redirect lands on the hosted `/login-callback` page (instead of
/// opening the app directly) the sheet hands off to the app but stays on top of
/// it, so a signed-in user is left looking at "Opening DocsBuddy…". Returns the
/// subscription so the caller can cancel it.
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
