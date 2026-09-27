import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/auth/application/auth_controller.dart';
import 'package:docsbuddy/features/auth/domain/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_app.dart';

class _MockAuth extends Mock implements AuthRepository {}

void main() {
  late _MockAuth auth;
  late ProviderContainer container;

  setUp(() {
    auth = _MockAuth();
    container = makeContainer(overrides: testOverrides(auth: auth));
    container.listen(authControllerProvider, (_, _) {});
  });

  AuthController controller() => container.read(authControllerProvider.notifier);

  test('successful sign-in trims the email and settles to data', () async {
    when(() => auth.signInWithPassword(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async {});
    expect(await controller().signIn('  a@b.dev ', 'pw'), isTrue);
    verify(() => auth.signInWithPassword(email: 'a@b.dev', password: 'pw')).called(1);
    expect(container.read(authControllerProvider), isA<AsyncData<void>>());
  });

  test('failures land in state as AppFailure and report false', () async {
    when(() => auth.signInWithPassword(email: any(named: 'email'), password: any(named: 'password')))
        .thenThrow(const AuthFailure('Incorrect email or password.'));
    expect(await controller().signIn('a@b.dev', 'bad'), isFalse);
    final error = container.read(authControllerProvider).error;
    expect(error, isA<AuthFailure>());
    expect((error! as AppFailure).message, 'Incorrect email or password.');
  });

  test('unexpected errors are normalised, never leaked', () async {
    when(() => auth.signOut()).thenThrow(StateError('internal'));
    expect(await controller().signOut(), isFalse);
    expect(container.read(authControllerProvider).error, isA<UnknownFailure>());
  });

  test('sign-up requires accepting the terms before calling the backend', () async {
    expect(await controller().signUp('A', 'a@b.dev', 'Secret123', acceptedTerms: false), isFalse);
    expect(container.read(authControllerProvider).error, isA<ValidationFailure>());
    verifyNever(() => auth.signUp(
        name: any(named: 'name'), email: any(named: 'email'), password: any(named: 'password')));
  });

  test('reset validates the new password first', () async {
    expect(await controller().resetPassword('weak', 'weak'), isFalse);
    verifyNever(() => auth.updatePassword(any()));

    when(() => auth.updatePassword('Secret123')).thenAnswer((_) async {});
    expect(await controller().resetPassword('Secret123', 'Secret123'), isTrue);
  });
}
