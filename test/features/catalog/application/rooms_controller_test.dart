import 'dart:typed_data';

import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/media/picked_media.dart';
import 'package:docsbuddy/features/catalog/application/rooms_controller.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

/// Fails reorders on demand, to exercise the optimistic rollback.
class _FlakyCatalog extends FakeCatalogRepository {
  _FlakyCatalog() : super(latency: Duration.zero);
  bool failReorder = false;

  @override
  Future<void> reorderLocations(List<String> orderedIds) async {
    if (failReorder) throw const NetworkFailure();
    return super.reorderLocations(orderedIds);
  }
}

void main() {
  late _FlakyCatalog catalog;
  late ProviderContainer container;

  setUp(() {
    catalog = _FlakyCatalog();
    container = makeContainer(overrides: testOverrides(catalog: catalog));
    container.listen(locationsProvider, (_, _) {});
  });

  List<String> names() => [for (final l in container.read(locationsProvider).requireValue) l.name];

  test('create validates the name and uploads the optional photo', () async {
    await container.read(locationsProvider.future);
    final rooms = container.read(locationsProvider.notifier);

    await expectLater(rooms.create('  '), throwsA(isA<ValidationFailure>()));

    final room = await rooms.create(' Study ', photo: PickedMedia(name: 'study.jpg', bytes: Uint8List(1)));
    expect(room.name, 'Study');
    await container.read(locationsProvider.future);
    expect(names(), contains('Study'));
    expect((await catalog.locations()).firstWhere((l) => l.id == room.id).imageUrl, isNotNull);
  });

  test('reorder applies immediately and persists', () async {
    await container.read(locationsProvider.future);
    final before = names();
    await container.read(locationsProvider.notifier).reorder(0, 2);
    expect(names(), [before[1], before[2], before[0]]);
    expect([for (final l in await catalog.locations()) l.name], names());
  });

  test('a failed reorder rolls back and surfaces the failure', () async {
    await container.read(locationsProvider.future);
    final before = names();
    catalog.failReorder = true;

    await expectLater(container.read(locationsProvider.notifier).reorder(0, 2), throwsA(isA<NetworkFailure>()));
    expect(names(), before);
  });

  test('rename ignores blank or unchanged names', () async {
    final kitchen = (await container.read(locationsProvider.future)).firstWhere((l) => l.name == 'Kitchen');
    final rooms = container.read(locationsProvider.notifier);
    await rooms.rename(kitchen, '   ');
    await rooms.rename(kitchen, 'Kitchen');
    await rooms.rename(kitchen, 'Pantry');
    await container.read(locationsProvider.future);
    expect(names(), contains('Pantry'));
    expect(names(), isNot(contains('Kitchen')));
  });
}
