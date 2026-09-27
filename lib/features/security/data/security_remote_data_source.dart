import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin GoTrue MFA/session wrapper returning plain records.
abstract interface class SecurityRemoteDataSource {
  Future<List<({String id, DateTime createdAt})>> verifiedTotpFactors();
  Future<({String id, String secret, String uri})?> enrollTotp();
  Future<void> challengeAndVerify(String factorId, String code);
  Future<void> unenroll(String factorId);
  ({String? current, String? next}) assuranceLevels();
  String? get lastSignInAt;
  Future<void> signOutOthers();
}

class SupabaseSecurityRemoteDataSource implements SecurityRemoteDataSource {
  SupabaseSecurityRemoteDataSource(this._client);

  final SupabaseClient _client;

  GoTrueMFAApi get _mfa => _client.auth.mfa;

  @override
  Future<List<({String id, DateTime createdAt})>> verifiedTotpFactors() async {
    final factors = await _mfa.listFactors();
    return [
      for (final f in factors.totp.where((f) => f.status == FactorStatus.verified)) (id: f.id, createdAt: f.createdAt),
    ];
  }

  @override
  Future<({String id, String secret, String uri})?> enrollTotp() async {
    final res = await _mfa.enroll(factorType: FactorType.totp);
    final totp = res.totp;
    return totp == null ? null : (id: res.id, secret: totp.secret, uri: totp.uri);
  }

  @override
  Future<void> challengeAndVerify(String factorId, String code) async {
    final challenge = await _mfa.challenge(factorId: factorId);
    await _mfa.verify(factorId: factorId, challengeId: challenge.id, code: code);
  }

  @override
  Future<void> unenroll(String factorId) => _mfa.unenroll(factorId);

  @override
  ({String? current, String? next}) assuranceLevels() {
    final aal = _mfa.getAuthenticatorAssuranceLevel();
    return (current: aal.currentLevel?.name, next: aal.nextLevel?.name);
  }

  @override
  String? get lastSignInAt => _client.auth.currentUser?.lastSignInAt;

  @override
  Future<void> signOutOthers() => _client.auth.signOut(scope: SignOutScope.others);
}
