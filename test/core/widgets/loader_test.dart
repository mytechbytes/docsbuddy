import 'dart:async';

import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:docsbuddy/core/widgets/feedback.dart';
import 'package:docsbuddy/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A page with one button that runs [onTap] with the page's own context.
Widget _app(void Function(BuildContext context) onTap) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(child: ElevatedButton(onPressed: () => onTap(context), child: const Text('Go'))),
        ),
      ),
    );

void main() {
  group('withLoader', () {
    testWidgets('shows the message before the work starts, and closes it when the work succeeds', (tester) async {
      final work = Completer<int>();
      var started = false;
      int? result;

      await tester.pumpWidget(_app((context) async {
        result = await withLoader(context, 'Saving your asset…', () {
          started = true;
          return work.future;
        });
      }));
      await tester.tap(find.text('Go'));
      await tester.pump();

      expect(find.text('Saving your asset…'), findsOneWidget, reason: 'loader first');
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(started, isTrue);

      work.complete(42);
      await tester.pumpAndSettle();

      expect(find.text('Saving your asset…'), findsNothing);
      expect(result, 42);
    });

    testWidgets('closes the loader and passes the error on when the work fails', (tester) async {
      Object? caught;
      await tester.pumpWidget(_app((context) async {
        try {
          await withLoader<void>(context, 'Deleting asset…', () async => throw StateError('boom'));
        } catch (e) {
          caught = e;
        }
      }));

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.text('Deleting asset…'), findsNothing);
      expect(caught, isA<StateError>());
    });

    testWidgets('blocks taps and the back button while it is up', (tester) async {
      final work = Completer<void>();
      var taps = 0;
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => Column(children: [
              ElevatedButton(onPressed: () => withLoader(context, 'Working…', () => work.future), child: const Text('Start')),
              ElevatedButton(onPressed: () => taps++, child: const Text('Behind')),
            ]),
          ),
        ),
      ));

      await tester.tap(find.text('Start'));
      await tester.pump();
      await tester.tap(find.text('Behind'), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0, reason: 'the barrier swallows taps');

      await tester.binding.handlePopRoute(); // Android back
      await tester.pump();
      expect(find.text('Working…'), findsOneWidget, reason: 'back must not dismiss a loader mid-request');

      work.complete();
      await tester.pumpAndSettle();
      expect(find.text('Working…'), findsNothing);
    });
  });

  group('runAction', () {
    testWidgets('shows the loader first, then the success message once it closes', (tester) async {
      final work = Completer<void>();
      bool? ok;
      await tester.pumpWidget(_app((context) async {
        ok = await runAction(context, () => work.future, loading: 'Saving…', success: 'Saved');
      }));

      await tester.tap(find.text('Go'));
      await tester.pump();
      expect(find.text('Saving…'), findsOneWidget);
      expect(find.text('Saved'), findsNothing);

      work.complete();
      await tester.pumpAndSettle();

      expect(find.text('Saving…'), findsNothing);
      expect(find.text('Saved'), findsOneWidget);
      expect(ok, isTrue);
    });

    testWidgets('on failure closes the loader, shows the failure text and reports false', (tester) async {
      bool? ok;
      await tester.pumpWidget(_app((context) async {
        ok = await runAction(context, () async => throw const NetworkFailure(), loading: 'Saving…');
      }));

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.text('Saving…'), findsNothing);
      expect(find.text('Can’t reach the server. Check your internet connection.'), findsOneWidget);
      expect(ok, isFalse);
    });
  });

  group('LoadingView', () {
    testWidgets('says what the screen is loading', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: LoadingView(message: 'Loading your assets…'))));

      expect(find.text('Loading your assets…'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('has a compact form for a section inside a screen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: LoadingView.section(message: 'Loading documents…'))));

      expect(find.text('Loading documents…'), findsOneWidget);
    });
  });
}
