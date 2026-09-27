import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/auth/domain/password_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('change-password strength scores by length and character classes', () {
    expect(passwordStrength('').$1, 0);
    expect(passwordStrength('abc').$1, 1);
    expect(passwordStrength('abcdefg1').$1, 2);
    expect(passwordStrength('Abcdefg123').$1, 3);
    expect(passwordStrength('Abcdefg123!x'), (4, 'Excellent'));
  });

  test('sign-up meter counts met checks', () {
    expect(signUpStrength('').$1, 0);
    expect(signUpStrength('abcdefgh').$1, 1);
    expect(signUpStrength('Abcdefg1!').$1, 4);
    expect(signUpStrength('Abcdefg1!').$2, 'Excellent password.');
  });

  test('checklist flags', () {
    final c = checkPassword('Secret1');
    expect(c.length, isFalse);
    expect(c.upper, isTrue);
    expect(c.number, isTrue);
    expect(c.special, isFalse);
  });

  test('reset and change validation', () {
    expect(() => validateResetPassword('secret12', 'secret12'), throwsA(isA<ValidationFailure>()));
    expect(() => validateResetPassword('Secret12', 'Secret13'), throwsA(isA<ValidationFailure>()));
    validateResetPassword('Secret12', 'Secret12');

    expect(() => validateNewPassword('short', 'short'), throwsA(isA<ValidationFailure>()));
    expect(() => validateNewPassword('longenough', 'different'), throwsA(isA<ValidationFailure>()));
    validateNewPassword('longenough', 'longenough');
  });
}
