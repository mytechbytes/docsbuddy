import 'dart:math';

import 'package:docsbuddy/features/security/application/recovery_codes.dart';
import 'package:docsbuddy/features/security/data/security_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recovery codes are well-formed, unique and hash deterministically', () {
    final codes = generateRecoveryCodes(random: Random(42));
    expect(codes, hasLength(10));
    expect(codes.toSet(), hasLength(10));
    for (final c in codes) {
      expect(RegExp(r'^[A-HJ-NP-Z2-9]{4}-[A-HJ-NP-Z2-9]{4}$').hasMatch(c), isTrue, reason: c);
    }
    // Hashing normalizes case/whitespace.
    expect(hashRecoveryCode(' ${codes.first.toLowerCase()} '), hashRecoveryCode(codes.first));
    expect(hashRecoveryCode(codes.first), isNot(hashRecoveryCode(codes.last)));
  });

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

  test('generating recovery codes updates the unused count', () async {
    final repo = FakeSecurityRepository();
    expect((await repo.status()).unusedRecoveryCodes, 0);
    final codes = await repo.generateRecoveryCodes();
    expect(codes, hasLength(10));
    expect((await repo.status()).unusedRecoveryCodes, 10);
  });
}
