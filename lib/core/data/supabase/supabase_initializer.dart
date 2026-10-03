import 'package:supabase_flutter/supabase_flutter.dart';

/// `Supabase.initialize`, but a failure leaves nothing behind.
///
/// The SDK marks itself initialised *before* it restores the saved session and
/// starts listening for OAuth deep links. If one of those later steps throws,
/// the next `Supabase.initialize` (the start-up screen's "Try again") is told
/// "already initialised" and returns at once — an app that looks fine but never
/// hears the sign-in redirect. Disposing on failure makes a retry start over.
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
