/// Which backend implementation the app talks to. Adding a backend means
/// adding a value here and a `BackendModule` for it (see
/// `bootstrap/backend_module.dart`).
enum BackendKind { fake, supabase }

/// Compile-time configuration, supplied via `--dart-define`.
///
/// Example:
///   flutter run --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///               --dart-define=SUPABASE_ANON_KEY=eyJ...
///
/// `BACKEND` picks the implementation explicitly (`fake`, `supabase`); when
/// absent, Supabase is used if its credentials are present, else the fake
/// in-memory backend so every screen still runs without a server.
abstract final class Env {
  static const _backend = String.fromEnvironment('BACKEND');

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Where auth emails / OAuth redirect back into the app. An Android App Link /
  /// iOS Universal Link served from the marketing site, with the custom scheme
  /// (in.mytechbytes.docsbuddy://login-callback) still registered as a fallback.
  /// Must also be listed in the backend's allowed redirect URLs.
  static const authRedirectUrl = 'https://docsbuddy.mytechbytes.in/login-callback';

  static bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static BackendKind get backend =>
      BackendKind.values.asNameMap()[_backend] ?? (hasSupabase ? BackendKind.supabase : BackendKind.fake);
}
