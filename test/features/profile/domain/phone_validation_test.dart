import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/profile/domain/phone_validation.dart';
import 'package:docsbuddy/features/profile/domain/profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizes valid E.164 and rejects junk', () {
    expect(normalizePhone('+91 98123 45678'), '+919812345678');
    expect(normalizePhone('+1 (415) 555-0100'), '+14155550100');
    expect(normalizePhone('9812345678'), isNull); // no country code
    expect(normalizePhone('+0 123'), isNull);
    expect(normalizePhone(''), isNull);
  });

  test('profile form rule: blank clears, junk is a ValidationFailure', () {
    expect(validatePhoneInput('  '), '');
    expect(validatePhoneInput('+91 98123 45678'), '+919812345678');
    expect(() => validatePhoneInput('12345'), throwsA(isA<ValidationFailure>()));
  });

  test('initials', () {
    expect(initialOf(' anand'), 'A');
    expect(initialOf(''), '?');
  });
}
