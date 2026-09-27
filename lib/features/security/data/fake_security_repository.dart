import '../../../core/error/app_failure.dart';
import '../domain/security_models.dart';
import '../domain/security_repository.dart';

/// In-memory security for local dev/tests: any 6-digit code verifies.
class FakeSecurityRepository implements SecurityRepository {
  String? _factorId;
  DateTime? _enrolledAt;
  bool _verified = false;

  void _requireCode(String code) {
    if (code.trim().length != 6) throw const ValidationFailure('Enter the 6-digit code.');
  }

  @override
  Future<SecurityStatus> status() async =>
      _verified ? SecurityStatus(totpFactorId: _factorId, enrolledAt: _enrolledAt) : const SecurityStatus();

  @override
  Future<TotpEnrollment> enrollTotp() async {
    _factorId = 'factor_${DateTime.now().millisecondsSinceEpoch}';
    _verified = false;
    const secret = 'JBSWY3DPEHPK3PXP';
    return TotpEnrollment(
      factorId: _factorId!,
      secret: secret,
      uri: 'otpauth://totp/DocsBuddy:you@docsbuddy.app?secret=$secret&issuer=DocsBuddy',
    );
  }

  @override
  Future<void> verifyTotp({required String factorId, required String code}) async {
    _requireCode(code);
    _verified = true;
    _enrolledAt = DateTime.now();
  }

  @override
  Future<void> disableTotp(String factorId) async {
    _factorId = null;
    _verified = false;
    _enrolledAt = null;
  }

  @override
  Future<bool> needsMfaChallenge() async => false;

  @override
  Future<void> verifyMfaChallenge(String code) async => _requireCode(code);

  @override
  Future<SessionInfo> currentSession() async =>
      SessionInfo(device: 'This device', lastSignIn: DateTime.now().subtract(const Duration(hours: 2)));

  @override
  Future<void> signOutOtherDevices() async {}
}
