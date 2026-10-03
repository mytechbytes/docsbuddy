import 'package:docsbuddy/core/data/supabase/supabase_guard.dart';
import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('passes results through', () async {
    expect(await guardBackend(() async => 42), 42);
  });

  test('maps SDK exceptions to user-safe failures', () async {
    await expectLater(
      guardBackend(() => throw const AuthException('Invalid login credentials')),
      throwsA(isA<AuthFailure>().having((f) => f.message, 'message', 'Invalid login credentials')),
    );
    await expectLater(
      guardBackend(() => throw const PostgrestException(message: 'duplicate key')),
      throwsA(isA<ServerFailure>().having((f) => f.message, 'message', 'duplicate key')),
    );
    await expectLater(
      guardBackend(() => throw StorageException('Object not found')),
      throwsA(isA<ServerFailure>()),
    );
  });

  test('network errors become NetworkFailure; the rest UnknownFailure', () async {
    await expectLater(
      guardBackend(() => throw Exception('SocketException: Failed host lookup')),
      throwsA(isA<NetworkFailure>()),
    );
    await expectLater(guardBackend(() => throw StateError('boom')), throwsA(isA<UnknownFailure>()));
  });

  test('already-mapped failures pass through untouched', () async {
    await expectLater(
      guardBackend(() => throw const ValidationFailure('Name required')),
      throwsA(isA<ValidationFailure>().having((f) => f.message, 'message', 'Name required')),
    );
  });

  test('AppFailure.from keeps failures and wraps anything else', () {
    const f = NetworkFailure();
    expect(AppFailure.from(f), same(f));
    final unknown = AppFailure.from(Exception('x'));
    expect(unknown, isA<UnknownFailure>());
    expect(unknown.message, isNot(contains('Exception'))); // never leaks internals
  });

  group('server errors that used to reach the user in English', () {
    Future<AppFailure> failureOf(Object error) async {
      try {
        await guardBackend<void>(() => throw error);
      } on AppFailure catch (f) {
        return f;
      }
      fail('expected a failure');
    }

    test('known GoTrue codes become coded failures the UI can translate', () async {
      const byCode = {
        'invalid_credentials': FailureReason.invalidCredentials,
        'email_not_confirmed': FailureReason.emailNotConfirmed,
        'user_already_exists': FailureReason.userExists,
        'email_exists': FailureReason.userExists,
        'weak_password': FailureReason.weakPassword,
        'over_request_rate_limit': FailureReason.rateLimited,
        'over_email_send_rate_limit': FailureReason.rateLimited,
        'otp_expired': FailureReason.codeInvalid,
        'same_password': FailureReason.samePassword,
        'session_expired': FailureReason.notSignedIn,
      };
      for (final entry in byCode.entries) {
        final failure = await failureOf(AuthException('server says something', code: entry.key));
        expect(failure, isA<AuthFailure>(), reason: entry.key);
        expect(failure.reason, entry.value, reason: entry.key);
      }
    });

    test('older servers without a code are recognised by their message', () async {
      expect((await failureOf(const AuthException('Invalid login credentials'))).reason, FailureReason.invalidCredentials);
      expect((await failureOf(const AuthException('User already registered'))).reason, FailureReason.userExists);
      expect((await failureOf(const AuthException('Email not confirmed'))).reason, FailureReason.emailNotConfirmed);
    });

    test('an unrecognised server message still passes through unchanged', () async {
      final failure = await failureOf(const AuthException('Something only the server knows', code: 'brand_new_code'));
      expect(failure.reason, isNull);
      expect(failure.message, 'Something only the server knows');
    });

    test('the SDK’s own network and session errors are not shown as raw SDK text', () async {
      expect(await failureOf(AuthRetryableFetchException(message: 'ClientException: Failed host lookup')), isA<NetworkFailure>());
      expect((await failureOf(AuthSessionMissingException())).reason, FailureReason.notSignedIn);
    });

    test('a weak-password rejection from the SDK is translated', () async {
      final failure = await failureOf(AuthWeakPasswordException(message: 'too weak', statusCode: '422', reasons: const ['length']));
      expect(failure.reason, FailureReason.weakPassword);
    });
  });
}

