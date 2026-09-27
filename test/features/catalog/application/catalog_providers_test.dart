import 'package:docsbuddy/features/catalog/application/catalog_providers.dart';
import 'package:docsbuddy/features/catalog/application/catalog_sync.dart';
import 'package:docsbuddy/features/catalog/application/rooms_controller.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  late ProviderContainer container;
  late RecordingNotificationService notifications;
  late FakePushMessagingService push;

  setUp(() {
    notifications = RecordingNotificationService();
    push = FakePushMessagingService();
    container = makeContainer(
      overrides: testOverrides(
        catalog: FakeCatalogRepository(latency: Duration.zero),
        notifications: notifications,
        push: push,
      ),
    );
  });

  test('search matches across assets and services; blank query finds nothing', () async {
    await container.read(assetsProvider.future);
    await container.read(upcomingRemindersProvider.future);

    final hits = container.read(catalogSearchProvider('acko'));
    expect(hits.assets, isEmpty);
    expect(hits.reminders.single.provider, 'Acko General');
    expect(container.read(catalogSearchProvider('fridge')).assets.single.name, 'Samsung 340L Fridge');
    expect(container.read(catalogSearchProvider('  ')).assets, isEmpty);
  });

  test('room detail lists the room’s appliances with their services, soonest first', () async {
    final garage = (await container.read(locationsProvider.future)).firstWhere((l) => l.name == 'Garage');
    await container.read(assetsProvider.future);
    await container.read(upcomingRemindersProvider.future);

    final detail = await container.read(roomDetailProvider(garage.id).future);
    final bike = detail!.appliances.single;
    expect(bike.asset.name, 'Royal Enfield Classic');
    expect(bike.reminders.map((r) => r.daysLeft), orderedEquals([...bike.reminders.map((r) => r.daysLeft)]..sort()));
    expect(await container.read(roomDetailProvider('missing').future), isNull);
  });

  test('a silent push refreshes catalog reads', () async {
    final catalog = _CountingCatalog();
    final c = makeContainer(overrides: testOverrides(catalog: catalog, push: push));
    c.listen(remoteChangeSyncProvider, (_, _) {});
    c.listen(assetsProvider, (_, _) {});
    await c.read(assetsProvider.future);
    expect(catalog.assetReads, 1);

    push.changes.add(null);
    await pumpEventQueue();
    await c.read(assetsProvider.future);
    expect(catalog.assetReads, 2);
  });
}

class _CountingCatalog extends FakeCatalogRepository {
  _CountingCatalog() : super(latency: Duration.zero);
  int assetReads = 0;

  @override
  Future<List<Asset>> assets() {
    assetReads++;
    return super.assets();
  }
}
