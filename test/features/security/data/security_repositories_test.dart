import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/security/data/fake_security_repository.dart';
import 'package:docsbuddy/features/security/data/remote_security_repository.dart';
import 'package:docsbuddy/features/security/data/security_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_app.dart';

class _MockRemote extends Mock implements SecurityRemoteDataSource {}

void main() {
  group('RemoteSecurityRepository', () {
    late _MockRemote remote;
    late RemoteSecurityRepository repo;
    setUp(() {
      remote = _MockRemote();
      repo = RemoteSecurityRepository(remote, logger: RecordingLogger());
    });

    test('status uses the first verified factor', () async {
      final created = DateTime(2025, 5, 1);
      when(() => remote.verifiedTotpFactors()).thenAnswer((_) async => [(id: 'f1', createdAt: created)]);
      final s = await repo.status();
      expect(s.totpFactorId, 'f1');
      expect(s.enrolledAt, created);
    });

    test('step-up is needed only when AAL2 is available but not reached', () async {
      when(() => remote.assuranceLevels()).thenReturn((current: 'aal1', next: 'aal2'));
      expect(await repo.needsMfaChallenge(), isTrue);
      when(() => remote.assuranceLevels()).thenReturn((current: 'aal2', next: 'aal2'));
      expect(await repo.needsMfaChallenge(), isFalse);
      when(() => remote.assuranceLevels()).thenThrow(Exception('no session'));
      expect(await repo.needsMfaChallenge(), isFalse);
    });

    test('challenge without an enrolled factor is a validation failure', () async {
      when(() => remote.verifiedTotpFactors()).thenAnswer((_) async => []);
      await expectLater(repo.verifyMfaChallenge('123456'), throwsA(isA<ValidationFailure>()));
    });

    test('enrollment without TOTP data is a server failure', () async {
      when(() => remote.enrollTotp()).thenAnswer((_) async => null);
      await expectLater(repo.enrollTotp(), throwsA(isA<ServerFailure>()));
    });
  });

  test('fake TOTP flow: enroll → verify → enabled → disable', () async {
    final repo = FakeSecurityRepository();
    final enrollment = await repo.enrollTotp();
    expect(enrollment.uri, startsWith('otpauth://totp/'));
    expect((await repo.status()).totpEnabled, isFalse); // pending until verified

    await expectLater(repo.verifyTotp(factorId: enrollment.factorId, code: '12'), throwsA(isA<ValidationFailure>()));
    await repo.verifyTotp(factorId: enrollment.factorId, code: '123456');
    expect((await repo.status()).totpEnabled, isTrue);

    await repo.disableTotp(enrollment.factorId);
    expect((await repo.status()).totpEnabled, isFalse);
  });
}
