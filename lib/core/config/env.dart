import 'package:flutter/foundation.dart';

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

  /// App Link / Universal Link served from the marketing site.
  static const authRedirectAppLink = 'https://docsbuddy.mytechbytes.in/login-callback';

  /// Custom-scheme fallback registered in Info.plist / AndroidManifest.
  static const authRedirectScheme = 'in.mytechbytes.docsbuddy://login-callback';

  /// Where auth emails / OAuth redirect back into the app. Both URLs must be
  /// listed in the backend's allowed redirect URLs.
  ///
  /// iOS uses the custom scheme until Associated Domains + the hosted
  /// apple-app-site-association file are in place (the https link would
  /// otherwise open the website instead of the app). Set
  /// `--dart-define=IOS_UNIVERSAL_LINKS=true` once they are.
  static String get authRedirectUrl =>
      defaultTargetPlatform == TargetPlatform.iOS && !_iosUniversalLinks ? authRedirectScheme : authRedirectAppLink;

  static const _iosUniversalLinks = bool.fromEnvironment('IOS_UNIVERSAL_LINKS');

  static bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static BackendKind get backend =>
      BackendKind.values.asNameMap()[_backend] ?? (hasSupabase ? BackendKind.supabase : BackendKind.fake);
}
