/// Compile-time configuration, supplied via `--dart-define`.
///
/// Example:
///   flutter run --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///               --dart-define=SUPABASE_ANON_KEY=eyJ...
///
/// When these are absent (the default for local dev), the app falls back to a
/// fake in-memory auth repository so every screen still runs without a backend.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Where auth emails / OAuth redirect back into the app. An Android App Link /
  /// iOS Universal Link served from the marketing site, with the custom scheme
  /// (in.mytechbytes.docsbuddy://login-callback) still registered as a fallback.
  /// Must also be listed in Supabase → Authentication → URL Configuration →
  /// Redirect URLs.
  static const authRedirectUrl = 'https://docsbuddy.mytechbytes.in/login-callback';

  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
