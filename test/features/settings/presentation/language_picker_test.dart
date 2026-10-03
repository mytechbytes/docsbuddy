import 'package:docsbuddy/core/l10n/app_language.dart';
import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:docsbuddy/core/l10n/language_controller.dart';
import 'package:docsbuddy/features/settings/presentation/language_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

/// A page that opens the picker and shows the current choice, inside an app
/// that follows [languageProvider] the way the real one does.
class _Harness extends ConsumerWidget {
  const _Harness();

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
        locale: ref.watch(languageProvider).locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(children: [
              Text('current: ${languageLabel(context, ref.watch(languageProvider))}'),
              ElevatedButton(onPressed: () => pickLanguage(context, ref), child: Text(context.l10n.settingsLanguage)),
            ]),
          ),
        ),
      );
}

void main() {
  Widget app({AppLanguage language = AppLanguage.system}) =>
      ProviderScope(overrides: testOverrides(language: language), retry: noRetry, child: const _Harness());

  testWidgets('offers Automatic first, then every language by its own name', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a language'), findsOneWidget);
    expect(find.text('Automatic'), findsOneWidget);
    expect(find.text('Follows your device language'), findsOneWidget);
    for (final language in AppLanguage.explicit) {
      expect(find.text(language.nativeName!), findsOneWidget, reason: language.code);
    }
    // Automatic is the current choice, so it carries the tick.
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('choosing a language switches the whole app to it, and Automatic switches back', (tester) async {
    await tester.pumpWidget(app(language: AppLanguage.english));
    expect(find.text('Language'), findsOneWidget);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();

    expect(find.text('Idioma'), findsOneWidget, reason: 'the button label is now Spanish');
    expect(find.text('current: Español'), findsOneWidget);
  });

  testWidgets('Arabic lays the app out right-to-left', (tester) async {
    await tester.pumpWidget(app(language: AppLanguage.arabic));
    await tester.pumpAndSettle();

    expect(Directionality.of(tester.element(find.byType(Scaffold))), TextDirection.rtl);
  });
}
