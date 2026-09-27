import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/auth/data/auth_remote_data_source.dart';
import 'package:docsbuddy/features/auth/data/remote_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late RemoteAuthRepository repo;

  setUpAll(() => registerFallbackValue(OAuthProviderKind.google));

  setUp(() {
    remote = _MockRemote();
    repo = RemoteAuthRepository(remote, redirectUrl: 'app://callback');
  });

  test('sign-up trims input and redirects back into the app', () async {
    when(() => remote.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullName: any(named: 'fullName'),
          redirectTo: any(named: 'redirectTo'),
        )).thenAnswer((_) async {});
    await repo.signUp(name: ' Anand ', email: ' a@b.dev ', password: 'pw');
    verify(() => remote.signUp(email: 'a@b.dev', password: 'pw', fullName: 'Anand', redirectTo: 'app://callback'))
        .called(1);
  });

  test('OAuth uses the configured redirect', () async {
    when(() => remote.signInWithOAuth(any(), any())).thenAnswer((_) async {});
    await repo.signInWithApple();
    verify(() => remote.signInWithOAuth(OAuthProviderKind.apple, 'app://callback')).called(1);
  });

  test('Microsoft uses its own provider with the same redirect', () async {
    when(() => remote.signInWithOAuth(any(), any())).thenAnswer((_) async {});
    await repo.signInWithMicrosoft();
    verify(() => remote.signInWithOAuth(OAuthProviderKind.microsoft, 'app://callback')).called(1);
  });

  test('GoTrue errors become user-safe AuthFailures', () async {
    when(() => remote.signInWithPassword(any(), any())).thenThrow(const AuthException('Invalid login credentials'));
    await expectLater(
      repo.signInWithPassword(email: 'a@b.dev', password: 'x'),
      throwsA(isA<AuthFailure>().having((f) => f.message, 'message', 'Invalid login credentials')),
    );
  });

  test('network trouble becomes NetworkFailure', () async {
    when(() => remote.sendEmailOtp(any())).thenThrow(Exception('ClientException: Connection refused'));
    await expectLater(repo.sendPasswordResetCode('a@b.dev'), throwsA(isA<NetworkFailure>()));
  });
}
