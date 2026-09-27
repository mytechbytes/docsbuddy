import 'package:supabase_flutter/supabase_flutter.dart';

enum OAuthProviderKind { google, apple, microsoft }

/// Thin GoTrue wrapper — no validation, no error translation.
abstract interface class AuthRemoteDataSource {
  Stream<bool> sessionChanges();
  bool get hasSession;
  Future<void> signInWithPassword(String email, String password);
  Future<void> signUp({required String email, required String password, required String fullName, String? redirectTo});
  Future<void> signInWithOAuth(OAuthProviderKind provider, String redirectTo);
  Future<void> sendEmailOtp(String email);
  Future<void> verifyEmailOtp(String email, String token);
  Future<void> updatePassword(String password);
  Future<void> signOut();
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  SupabaseAuthRemoteDataSource(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  @override
  Stream<bool> sessionChanges() => _auth.onAuthStateChange.map((s) => s.session != null);

  @override
  bool get hasSession => _auth.currentSession != null;

  @override
  Future<void> signInWithPassword(String email, String password) =>
      _auth.signInWithPassword(email: email, password: password);

  @override
  Future<void> signUp({required String email, required String password, required String fullName, String? redirectTo}) =>
      _auth.signUp(email: email, password: password, data: {'full_name': fullName}, emailRedirectTo: redirectTo);

  @override
  Future<void> signInWithOAuth(OAuthProviderKind provider, String redirectTo) => _auth.signInWithOAuth(
        switch (provider) {
          OAuthProviderKind.google => OAuthProvider.google,
          OAuthProviderKind.apple => OAuthProvider.apple,
          // Supabase's provider for Microsoft Entra ID / personal accounts.
          OAuthProviderKind.microsoft => OAuthProvider.azure,
        },
        redirectTo: redirectTo,
        // Azure only returns the email address when asked for it.
        scopes: provider == OAuthProviderKind.microsoft ? 'email' : null,
      );

  @override
  Future<void> sendEmailOtp(String email) => _auth.signInWithOtp(email: email);

  @override
  Future<void> verifyEmailOtp(String email, String token) =>
      _auth.verifyOTP(email: email, token: token, type: OtpType.email);

  @override
  Future<void> updatePassword(String password) => _auth.updateUser(UserAttributes(password: password));

  @override
  Future<void> signOut() => _auth.signOut();
}
