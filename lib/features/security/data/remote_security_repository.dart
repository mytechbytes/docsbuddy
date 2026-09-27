import '../../../core/data/supabase/supabase_guard.dart';
import '../../../core/error/app_failure.dart';
import '../domain/security_models.dart';
import '../domain/security_repository.dart';
import 'security_remote_data_source.dart';

/// Security over GoTrue MFA + the auth session.
class RemoteSecurityRepository implements SecurityRepository {
  RemoteSecurityRepository(this._remote);

  final SecurityRemoteDataSource _remote;

  @override
  Future<SecurityStatus> status() => guardBackend(() async {
        final verified = await _remote.verifiedTotpFactors();
        return verified.isEmpty
            ? const SecurityStatus()
            : SecurityStatus(totpFactorId: verified.first.id, enrolledAt: verified.first.createdAt);
      });

  @override
  Future<TotpEnrollment> enrollTotp() => guardBackend(() async {
        final e = await _remote.enrollTotp() ?? (throw const ServerFailure('TOTP enrollment unavailable.'));
        return TotpEnrollment(factorId: e.id, secret: e.secret, uri: e.uri);
      });

  @override
  Future<void> verifyTotp({required String factorId, required String code}) =>
      guardBackend(() => _remote.challengeAndVerify(factorId, code.trim()));

  @override
  Future<void> disableTotp(String factorId) => guardBackend(() => _remote.unenroll(factorId));

  @override
  Future<bool> needsMfaChallenge() async {
    try {
      final aal = _remote.assuranceLevels();
      return aal.next == 'aal2' && aal.current != aal.next;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> verifyMfaChallenge(String code) => guardBackend(() async {
        final factors = await _remote.verifiedTotpFactors();
        if (factors.isEmpty) throw const ValidationFailure('No authenticator enrolled.');
        await _remote.challengeAndVerify(factors.first.id, code.trim());
      });

  @override
  Future<SessionInfo> currentSession() async {
    final last = _remote.lastSignInAt;
    return SessionInfo(device: 'This device', lastSignIn: last == null ? null : DateTime.tryParse(last));
  }

  @override
  Future<void> signOutOtherDevices() => guardBackend(_remote.signOutOthers);
}
