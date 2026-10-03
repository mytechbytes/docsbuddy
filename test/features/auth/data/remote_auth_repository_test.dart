import 'dart:async';

import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/auth/data/auth_remote_data_source.dart';
import 'package:docsbuddy/features/auth/data/remote_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../helpers/test_app.dart';

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

  group('failures after the browser hands control back', () {
    late RecordingLogger logger;

    RemoteAuthRepository repoWith(Stream<Object> errors, {required bool signedIn}) {
      when(() => remote.callbackErrors()).thenAnswer((_) => errors);
      when(() => remote.hasSession).thenReturn(signedIn);
      logger = RecordingLogger();
      return RemoteAuthRepository(remote, redirectUrl: 'app://callback', logger: logger, callbackGrace: Duration.zero);
    }

    test('a redirect the SDK could not exchange becomes a user-safe failure and is logged', () async {
      final r = repoWith(
        Stream.value(const AuthException('Code verifier could not be found in local storage.')),
        signedIn: false,
      );

      final failure = await r.callbackFailures.first;

      expect(failure, isA<AuthFailure>().having((f) => f.reason, 'reason', FailureReason.signInIncomplete));
      expect(failure.message, isNot(contains('verifier')), reason: 'SDK wording stays out of the UI');
      expect(logger.warnings, ['Sign-in callback failed'], reason: 'the real cause goes to Crashlytics');
    });

    test('a duplicate delivery of a link that already signed the user in is not an error', () async {
      final r = repoWith(Stream.value(const AuthException('Code verifier could not be found')), signedIn: true);

      expect(await r.callbackFailures.toList(), isEmpty);
      expect(logger.warnings, isEmpty);
    });

    test('losing the network mid-exchange is reported as a network failure', () async {
      final r = repoWith(Stream.value(Exception('ClientException: Connection reset')), signedIn: false);

      expect(await r.callbackFailures.first, isA<NetworkFailure>());
    });
  });
}
