import 'package:docsbuddy/features/security/data/security_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fake TOTP flow: enroll → verify → enabled → disable', () async {
    final repo = FakeSecurityRepository();
    expect((await repo.status()).totpEnabled, isFalse);

    final enrollment = await repo.enrollTotp();
    expect(enrollment.uri, startsWith('otpauth://totp/'));
    expect((await repo.status()).totpEnabled, isFalse); // pending until verified

    expect(() => repo.verifyTotp(factorId: enrollment.factorId, code: '12'), throwsException);
    await repo.verifyTotp(factorId: enrollment.factorId, code: '123456');
    expect((await repo.status()).totpEnabled, isTrue);

    await repo.disableTotp(enrollment.factorId);
    expect((await repo.status()).totpEnabled, isFalse);
  });

  test('MFA challenge: fake never requires it and validates code shape', () async {
    final repo = FakeSecurityRepository();
    expect(await repo.needsMfaChallenge(), isFalse);
    expect(() => repo.verifyMfaChallenge('123'), throwsException);
    await repo.verifyMfaChallenge('123456'); // 6 digits accepted
  });
}
