import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:docsbuddy/core/widgets/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

/// A page with one button that runs [onTap] with the page's own context.
Widget _app(RecordingLogger logger, void Function(BuildContext context) onTap) => ProviderScope(
      overrides: testOverrides(logger: logger),
      retry: noRetry,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(child: ElevatedButton(onPressed: () => onTap(context), child: const Text('Go'))),
          ),
        ),
      ),
    );

void main() {
  testWidgets('an unexpected failure shown by an action is also reported', (tester) async {
    final logger = RecordingLogger();
    await tester.pumpWidget(_app(logger, (context) => runAction(context, () async => throw StateError('boom'), loading: 'Saving…')));

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong. Please try again.'), findsOneWidget, reason: 'the user is told');
    expect(logger.errors, hasLength(1), reason: 'and production hears about it');
  });

  testWidgets('a failure the user caused is shown but not logged', (tester) async {
    final logger = RecordingLogger();
    await tester.pumpWidget(_app(logger, (context) => runAction(context, () async => throw const NetworkFailure(), loading: 'Saving…')));

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Can’t reach the server'), findsOneWidget);
    expect(logger.errors, isEmpty);
    expect(logger.warnings, isEmpty);
  });

  testWidgets('showing the same failure twice reports it once', (tester) async {
    final logger = RecordingLogger();
    final failure = UnknownFailure(StateError('boom'));
    await tester.pumpWidget(_app(logger, (context) {
      context.showFailure(failure);
      context.showFailure(failure);
    }));

    await tester.tap(find.text('Go'));
    await tester.pump();

    expect(logger.errors, hasLength(1));
  });

  testWidgets('inline error text reports too, but building text does not', (tester) async {
    final logger = RecordingLogger();
    late String inline;
    await tester.pumpWidget(_app(logger, (context) {
      inline = context.failureMessage(UnknownFailure(StateError('boom')));
      context.failureText(UnknownFailure(StateError('rebuilt on every frame'))); // must stay silent
    }));

    await tester.tap(find.text('Go'));
    await tester.pump();

    expect(inline, 'Something went wrong. Please try again.');
    expect(logger.errors, hasLength(1));
  });

  testWidgets('with no provider scope at all, showing a failure still works', (tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(onPressed: () => context.showFailure(StateError('boom')), child: const Text('Go')),
        ),
      ),
    ));

    await tester.tap(find.text('Go'));
    await tester.pump();

    expect(find.text('Something went wrong. Please try again.'), findsOneWidget);
  });
}
