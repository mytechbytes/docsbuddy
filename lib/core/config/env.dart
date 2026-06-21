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

  /// Deep link the auth emails / OAuth redirect back into the app. Must be
  /// registered as a platform deep link (Android intent-filter, iOS URL type)
  /// AND added to Supabase → Authentication → URL Configuration → Redirect URLs.
  static const authRedirectUrl = 'in.mytechbytes.docsbuddy://login-callback';

  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
