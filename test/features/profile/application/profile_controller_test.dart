import 'dart:typed_data';

import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/media/picked_media.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/profile/application/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  late ProviderContainer container;
  setUp(() {
    container = makeContainer(overrides: testOverrides(catalog: FakeCatalogRepository(latency: Duration.zero)));
    container.listen(profileProvider, (_, _) {});
  });

  test('updateInfo normalises the phone and emits the saved profile', () async {
    await container.read(profileProvider.future);
    await container.read(profileProvider.notifier).updateInfo(displayName: 'Anand', phone: '+91 98123 45678');
    final p = container.read(profileProvider).requireValue;
    expect(p.displayName, 'Anand');
    expect(p.phone, '+919812345678');
  });

  test('an invalid phone is rejected without saving', () async {
    final before = await container.read(profileProvider.future);
    await expectLater(
      container.read(profileProvider.notifier).updateInfo(displayName: 'X', phone: '98123'),
      throwsA(isA<ValidationFailure>()),
    );
    expect(container.read(profileProvider).requireValue, before);
  });

  test('setAvatar stores the new photo reference', () async {
    await container.read(profileProvider.future);
    await container
        .read(profileProvider.notifier)
        .setAvatar(PickedMedia(name: 'me.jpg', bytes: Uint8List.fromList([1])));
    expect(container.read(profileProvider).requireValue.avatarUrl, isNotNull);
  });

  test('stats count assets, open services and documents', () async {
    final stats = await container.read(profileStatsProvider.future);
    expect(stats.assets, 3);
    expect(stats.reminders, 4);
    expect(stats.documents, 0);
  });
}
