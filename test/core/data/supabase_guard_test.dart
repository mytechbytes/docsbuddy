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
}
