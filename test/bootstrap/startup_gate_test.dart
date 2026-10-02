import 'dart:async';

import 'package:docsbuddy/bootstrap/app_startup.dart';
import 'package:docsbuddy/bootstrap/backends/fake_backend.dart';
import 'package:docsbuddy/bootstrap/backend_module.dart';
import 'package:docsbuddy/bootstrap/startup_gate.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_app.dart';

void main() {
  const settle = Duration(milliseconds: 300); // lets the message cross-fade finish

  Widget gate(AppStartup startup) => StartupGate(
        startup: startup,
        appBuilder: (_) => const Directionality(textDirection: TextDirection.ltr, child: Text('THE APP')),
      );

  testWidgets('tells the user what is happening at each step, then shows the app', (tester) async {
    final firebase = Completer<bool>();
    final backend = Completer<BackendModule>();
    final prefs = Completer<SharedPreferences>();
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(gate(AppStartup(
      initFirebase: () => firebase.future,
      createLogger: ({required firebaseReady}) => RecordingLogger(),
      reportUncaughtErrors: (_) {},
      createBackend: (_) => backend.future,
      loadPreferences: () => prefs.future,
    )));
    await tester.pump();
    expect(find.text('Starting DocsBuddy…'), findsOneWidget);
    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(find.text('THE APP'), findsNothing);

    firebase.complete(false);
    await tester.pump();
    await tester.pump(settle);
    expect(find.text('Connecting to your account…'), findsOneWidget);
    expect(find.text('Step 2 of 3'), findsOneWidget);

    backend.complete(FakeBackend());
    await tester.pump();
    await tester.pump(settle);
    expect(find.text('Loading your preferences…'), findsOneWidget);
    expect(find.text('Step 3 of 3'), findsOneWidget);

    prefs.complete(await SharedPreferences.getInstance());
    await tester.pump();
    await tester.pump();
    expect(find.text('THE APP'), findsOneWidget);
    expect(find.text('Loading your preferences…'), findsNothing);
  });

  testWidgets('a failed step shows what went wrong and Try again recovers', (tester) async {
    var failBackend = true;
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(gate(AppStartup(
      initFirebase: () async => false,
      createLogger: ({required firebaseReady}) => RecordingLogger(),
      reportUncaughtErrors: (_) {},
      createBackend: (_) async => failBackend ? throw StateError('offline') : FakeBackend(),
      loadPreferences: SharedPreferences.getInstance,
    )));
    await tester.pump();
    await tester.pump();

    expect(find.text("Couldn't start DocsBuddy"), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('THE APP'), findsNothing);

    failBackend = false;
    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.text('THE APP'), findsOneWidget);
  });
}
