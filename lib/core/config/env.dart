import 'package:flutter/foundation.dart';

/// Which backend the app talks to. A new one needs a value here and a `BackendModule`.
enum BackendKind { fake, supabase }

/// Compile-time configuration from `--dart-define`.
///
/// `BACKEND` selects the implementation (`fake`, `supabase`); when absent, Supabase is used if its
/// credentials are present, otherwise the in-memory fake so every screen runs without a server.
abstract final class Env {
  static const _backend = String.fromEnvironment('BACKEND');

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// App Link / Universal Link served from the marketing site.
  static const authRedirectAppLink = 'https://docsbuddy.mytechbytes.in/login-callback';

  /// Custom-scheme fallback registered in Info.plist / AndroidManifest.
  static const authRedirectScheme = 'in.mytechbytes.docsbuddy://login-callback';

  /// Where auth emails / OAuth redirect back into the app; both URLs must be allowed in the backend.
  /// iOS uses the custom scheme until Associated Domains are set up (`--dart-define=IOS_UNIVERSAL_LINKS=true` after).
  static String get authRedirectUrl =>
      defaultTargetPlatform == TargetPlatform.iOS && !_iosUniversalLinks ? authRedirectScheme : authRedirectAppLink;

  static const _iosUniversalLinks = bool.fromEnvironment('IOS_UNIVERSAL_LINKS');

  static bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static BackendKind get backend =>
      BackendKind.values.asNameMap()[_backend] ?? (hasSupabase ? BackendKind.supabase : BackendKind.fake);
}
