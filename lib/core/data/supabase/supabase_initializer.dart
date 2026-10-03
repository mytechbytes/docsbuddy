import 'package:supabase_flutter/supabase_flutter.dart';

/// `Supabase.initialize` that rolls back on failure.
/// The SDK flags itself initialised before restoring the session and starting the deep-link listener; if a later
/// step throws, a retry returns early and the app never hears the sign-in redirect. Disposing makes it start over.
Future<Supabase> initializeSupabase({
  required String url,
  required String publishableKey,
  required FlutterAuthClientOptions authOptions,
}) async {
  try {
    return await Supabase.initialize(url: url, publishableKey: publishableKey, authOptions: authOptions);
  } catch (_) {
    try {
      await Supabase.instance.dispose();
    } catch (_) {
      // Nothing usable to clean up; surface the original failure.
    }
    rethrow;
  }
}
