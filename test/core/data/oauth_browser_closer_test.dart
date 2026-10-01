import 'dart:async';

import 'package:docsbuddy/core/data/supabase/oauth_browser_closer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late StreamController<AuthState> events;
  late int closed;
  late StreamSubscription<AuthState> sub;

  setUp(() {
    events = StreamController<AuthState>.broadcast();
    closed = 0;
    sub = closeBrowserOnSignIn(events.stream, close: () async => closed++);
  });

  tearDown(() async {
    await sub.cancel();
    await events.close();
  });

  Future<void> emit(AuthChangeEvent event) async {
    events.add(AuthState(event, null));
    await Future<void>.delayed(Duration.zero);
  }

  test('closes the in-app browser when the user signs in', () async {
    await emit(AuthChangeEvent.signedIn);
    expect(closed, 1);
  });

  test('ignores every other auth event', () async {
    await emit(AuthChangeEvent.initialSession);
    await emit(AuthChangeEvent.tokenRefreshed);
    await emit(AuthChangeEvent.signedOut);
    expect(closed, 0);
  });

  test('a failing close or an error event never escapes', () async {
    await sub.cancel();
    sub = closeBrowserOnSignIn(events.stream, close: () async => throw UnsupportedError('no browser'));

    events.addError(const AuthException('Code verifier could not be found in local storage.'));
    await emit(AuthChangeEvent.signedIn);
    // Reaching here without an uncaught error is the assertion.
    expect(closed, 0);
  });
}
