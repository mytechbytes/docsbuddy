import 'package:supabase_flutter/supabase_flutter.dart';

import '../application/recovery_codes.dart' as rc;

/// A pending TOTP enrollment — show the QR/secret, then verify a code.
class TotpEnrollment {
  const TotpEnrollment({required this.factorId, required this.secret, required this.uri});
  final String factorId;
  final String secret;

  /// `otpauth://` URI for the authenticator-app QR.
  final String uri;
}

class SecurityStatus {
  const SecurityStatus({this.totpFactorId, this.enrolledAt, this.unusedRecoveryCodes = 0});
  final String? totpFactorId;
  final DateTime? enrolledAt;
  final int unusedRecoveryCodes;

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

  /// Generates fresh codes, persists their hashes, returns the plain codes
  /// (shown exactly once).
  Future<List<String>> generateRecoveryCodes();

  Future<({String device, DateTime? lastSignIn})> currentSession();
  Future<void> signOutOtherDevices();
}

/// In-memory security for local dev/tests: any 6-digit code verifies.
class FakeSecurityRepository implements SecurityRepository {
  String? _factorId;
  DateTime? _enrolledAt;
  bool _pendingVerified = false;
  List<String> _hashes = const [];

  @override
  Future<SecurityStatus> status() async => SecurityStatus(
        totpFactorId: _pendingVerified ? _factorId : null,
        enrolledAt: _pendingVerified ? _enrolledAt : null,
        unusedRecoveryCodes: _hashes.length,
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
  Future<List<String>> generateRecoveryCodes() async {
    final codes = rc.generateRecoveryCodes();
    _hashes = codes.map(rc.hashRecoveryCode).toList();
    return codes;
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
        final hashes =
            (_client.auth.currentUser?.userMetadata?['recovery_code_hashes'] as List?)?.length ?? 0;
        return SecurityStatus(
          totpFactorId: verified.isEmpty ? null : verified.first.id,
          enrolledAt: verified.isEmpty ? null : verified.first.createdAt,
          unusedRecoveryCodes: hashes,
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
  Future<List<String>> generateRecoveryCodes() => _guard(() async {
        final codes = rc.generateRecoveryCodes();
        await _client.auth.updateUser(UserAttributes(data: {
          'recovery_code_hashes': codes.map(rc.hashRecoveryCode).toList(),
        }));
        return codes;
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
