import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/l10n/failure_text.dart';
import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/catalog/presentation/widgets/catalog_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizations l10n;
  setUpAll(() async => l10n = await AppLocalizations.delegate.load(const Locale('en')));

  test('coded failures are localized; server messages pass through', () {
    expect(localizeFailure(l10n, const ValidationFailure('x', reason: FailureReason.nameRequired)), l10n.errorNameRequired);
    expect(localizeFailure(l10n, const NetworkFailure()), l10n.errorNetwork);
    expect(localizeFailure(l10n, StateError('boom')), l10n.errorUnknown);
    expect(localizeFailure(l10n, const ServerFailure('duplicate key')), 'duplicate key');
    expect(
      localizeFailure(l10n, const ServerFailure('x', reason: FailureReason.uploadsFailed, args: [1, 3])),
      '1 of 3 uploads failed.',
    );
  });

  test('every failure reason has a translation', () {
    for (final reason in FailureReason.values) {
      final args = reason == FailureReason.uploadsFailed ? const <Object>[1, 2] : const <Object>[];
      expect(localizeFailure(l10n, ServerFailure('fallback', reason: reason, args: args)), isNot('fallback'));
    }
  });

  testWidgets('enum display names come from the ARB', (tester) async {
    late String kind, group, recurrence;
    await tester.pumpWidget(Localizations(
      locale: const Locale('en'),
      delegates: AppLocalizations.localizationsDelegates,
      child: Builder(builder: (context) {
        kind = ReminderKind.amc.displayName(context);
        group = AssetCategoryKind.vehicle.displayName(context);
        recurrence = Recurrence.halfYearly.displayName(context);
        return const SizedBox();
      }),
    ));
    expect((kind, group, recurrence), ('AMC', 'Vehicle', 'Half-yearly'));
  });

  test('countdown phrases pluralise', () {
    expect(dueCountdown(l10n, -1), 'Overdue by 1 day');
    expect(dueCountdown(l10n, -3), 'Overdue by 3 days');
    expect(dueCountdown(l10n, 0), 'Due today');
    expect(dueCountdown(l10n, 1), '1 day left');
    expect(relativeDays(l10n, -2), '2d ago');
  });
}
