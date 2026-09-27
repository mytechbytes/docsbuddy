import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/reminders/domain/reminder_filters.dart';
import 'package:docsbuddy/features/dashboard/application/dashboard_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  late ProviderContainer container;
  setUp(() {
    container = makeContainer(overrides: testOverrides(catalog: FakeCatalogRepository(latency: Duration.zero)));
    container.listen(dashboardViewProvider, (_, _) {});
  });

  test('derives stat counts, urgency order and asset groups', () async {
    final view = await container.read(dashboardViewProvider.future);
    expect(view.counts[ReminderFilter.active], 4);
    expect(view.counts[ReminderFilter.expired], 1);
    expect(view.assetCount, 3);
    expect(view.visible.first.label, 'AppleCare'); // overdue first
    expect(view.groups.first.first.assetId, view.visible.first.assetId);
    expect(view.assetsById, hasLength(3));
  });

  test('kind filter and grouping flow into the view', () async {
    await container.read(dashboardViewProvider.future);
    container.read(dashboardControllerProvider.notifier)
      ..setKinds({ReminderKind.insurance})
      ..setGroupByAsset(true);

    final view = await container.read(dashboardViewProvider.future);
    expect(view.visible.every((r) => r.kind == ReminderKind.insurance), isTrue);
    expect(view.filter.groupByAsset, isTrue);
    expect(view.counts[ReminderFilter.active], 4); // stats ignore the list filter
  });
}
