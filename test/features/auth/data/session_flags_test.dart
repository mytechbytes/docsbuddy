import 'dart:async';

import 'package:docsbuddy/features/auth/data/auth_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('maps auth events to the signed-in flag', () async {
    final events = StreamController<AuthState>();
    final flags = <bool>[];
    final sub = sessionFlags(events.stream).listen(flags.add);

    events
      ..add(AuthState(AuthChangeEvent.initialSession, null))
      ..add(AuthState(AuthChangeEvent.signedIn, Session(accessToken: 't', tokenType: 'bearer', user: _user)))
      ..add(AuthState(AuthChangeEvent.signedOut, null));
    await Future<void>.delayed(Duration.zero);

    expect(flags, [false, true, false]);
    await sub.cancel();
    await events.close();
  });

  test('a duplicate-callback error does not break or fail the stream', () async {
    final events = StreamController<AuthState>();
    final flags = <bool>[];
    final errors = <Object>[];
    final sub = sessionFlags(events.stream).listen(flags.add, onError: errors.add);

    events
      ..add(AuthState(AuthChangeEvent.signedIn, Session(accessToken: 't', tokenType: 'bearer', user: _user)))
      ..addError(const AuthException('Code verifier could not be found in local storage.'))
      ..add(AuthState(AuthChangeEvent.signedOut, null));
    await Future<void>.delayed(Duration.zero);

    expect(errors, isEmpty);
    expect(flags, [true, false]);
    await sub.cancel();
    await events.close();
  });

  test('authErrors is the other half: only the errors, as values', () async {
    final events = StreamController<AuthState>();
    final errors = <Object>[];
    final done = Completer<void>();
    final sub = authErrors(events.stream).listen(errors.add, onDone: done.complete);

    final failure = const AuthException('Code verifier could not be found in local storage.');
    events
      ..add(AuthState(AuthChangeEvent.signedIn, Session(accessToken: 't', tokenType: 'bearer', user: _user)))
      ..addError(failure)
      ..add(AuthState(AuthChangeEvent.signedOut, null));
    await Future<void>.delayed(Duration.zero);

    expect(errors, [failure]);
    await events.close();
    await done.future;
    await sub.cancel();
  });
}

const _user = User(id: 'u1', appMetadata: {}, userMetadata: {}, aud: 'authenticated', createdAt: '2026-01-01T00:00:00Z');
