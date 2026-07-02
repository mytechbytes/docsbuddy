import 'package:supabase_flutter/supabase_flutter.dart';

/// A pending TOTP enrollment — show the QR/secret, then verify a code.
class TotpEnrollment {
  const TotpEnrollment({required this.factorId, required this.secret, required this.uri});
  final String factorId;
  final String secret;

  /// `otpauth://` URI for the authenticator-app QR.
  final String uri;
}

class SecurityStatus {
  const SecurityStatus({this.totpFactorId, this.enrolledAt});
  final String? totpFactorId;
  final DateTime? enrolledAt;

  bool get totpEnabled => totpFactorId != null;
}

/// Account-security backend: TOTP 2FA (GoTrue MFA), recovery codes and
/// session control. Biometrics/app-lock are device-local and live in
/// `SecurityPrefs`, not here.
abstract interface class SecurityRepository {
  Future<SecurityStatus> status();
  Future<TotpEnrollment> enrollTotp();
  Future<void> verifyTotp({required String factorId, required String code});
  Future<void> disableTotp(String factorId);

  /// True when a verified TOTP factor exists but the current session is
  /// still AAL1 — the sign-in must step up before using the app.
  Future<bool> needsMfaChallenge();

  /// Verifies a TOTP code against the enrolled factor, elevating the
  /// session to AAL2.
  Future<void> verifyMfaChallenge(String code);

  Future<({String device, DateTime? lastSignIn})> currentSession();
  Future<void> signOutOtherDevices();
}

/// In-memory security for local dev/tests: any 6-digit code verifies.
class FakeSecurityRepository implements SecurityRepository {
  String? _factorId;
  DateTime? _enrolledAt;
  bool _pendingVerified = false;

  @override
  Future<SecurityStatus> status() async => SecurityStatus(
        totpFactorId: _pendingVerified ? _factorId : null,
        enrolledAt: _pendingVerified ? _enrolledAt : null,
      );

  @override
  Future<TotpEnrollment> enrollTotp() async {
    _factorId = 'factor_${DateTime.now().millisecondsSinceEpoch}';
    _pendingVerified = false;
    const secret = 'JBSWY3DPEHPK3PXP';
    return TotpEnrollment(
      factorId: _factorId!,
      secret: secret,
      uri: 'otpauth://totp/DocsBuddy:you@docsbuddy.app?secret=$secret&issuer=DocsBuddy',
    );
  }

  @override
  Future<void> verifyTotp({required String factorId, required String code}) async {
    if (code.trim().length != 6) throw Exception('Enter the 6-digit code.');
    _pendingVerified = true;
    _enrolledAt = DateTime.now();
  }

  @override
  Future<void> disableTotp(String factorId) async {
    _factorId = null;
    _pendingVerified = false;
    _enrolledAt = null;
  }

  @override
  Future<bool> needsMfaChallenge() async => false;

  @override
  Future<void> verifyMfaChallenge(String code) async {
    if (code.trim().length != 6) throw Exception('Enter the 6-digit code.');
  }

  @override
  Future<({String device, DateTime? lastSignIn})> currentSession() async =>
      (device: 'This device', lastSignIn: DateTime.now().subtract(const Duration(hours: 2)));

  @override
  Future<void> signOutOtherDevices() async {}
}

/// Real security over GoTrue MFA + auth session.
class SupabaseSecurityRepository implements SecurityRepository {
  SupabaseSecurityRepository(this._client);

  final SupabaseClient _client;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<SecurityStatus> status() => _guard(() async {
        final factors = await _client.auth.mfa.listFactors();
        final verified = factors.totp.where((f) => f.status == FactorStatus.verified).toList();
        return SecurityStatus(
          totpFactorId: verified.isEmpty ? null : verified.first.id,
          enrolledAt: verified.isEmpty ? null : verified.first.createdAt,
        );
      });

  @override
  Future<TotpEnrollment> enrollTotp() => _guard(() async {
        final res = await _client.auth.mfa.enroll(factorType: FactorType.totp);
        final totp = res.totp;
        if (totp == null) throw Exception('TOTP enrollment unavailable.');
        return TotpEnrollment(factorId: res.id, secret: totp.secret, uri: totp.uri);
      });

  @override
  Future<void> verifyTotp({required String factorId, required String code}) => _guard(() async {
        final challenge = await _client.auth.mfa.challenge(factorId: factorId);
        await _client.auth.mfa.verify(factorId: factorId, challengeId: challenge.id, code: code.trim());
      });

  @override
  Future<void> disableTotp(String factorId) =>
      _guard(() => _client.auth.mfa.unenroll(factorId));

  @override
  Future<bool> needsMfaChallenge() async {
    try {
      final aal = _client.auth.mfa.getAuthenticatorAssuranceLevel();
      return aal.nextLevel == AuthenticatorAssuranceLevels.aal2 && aal.currentLevel != aal.nextLevel;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> verifyMfaChallenge(String code) => _guard(() async {
        final factors = await _client.auth.mfa.listFactors();
        final factor = factors.totp.where((f) => f.status == FactorStatus.verified).firstOrNull;
        if (factor == null) throw Exception('No authenticator enrolled.');
        final challenge = await _client.auth.mfa.challenge(factorId: factor.id);
        await _client.auth.mfa.verify(factorId: factor.id, challengeId: challenge.id, code: code.trim());
      });

  @override
  Future<({String device, DateTime? lastSignIn})> currentSession() async {
    final user = _client.auth.currentUser;
    final last = user?.lastSignInAt;
    return (
      device: 'This device',
      lastSignIn: last == null ? null : DateTime.tryParse(last),
    );
  }

  @override
  Future<void> signOutOtherDevices() =>
      _guard(() => _client.auth.signOut(scope: SignOutScope.others));
}
