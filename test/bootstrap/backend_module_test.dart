import 'package:docsbuddy/bootstrap/backends/fake_backend.dart';
import 'package:docsbuddy/bootstrap/dependencies.dart';
import 'package:docsbuddy/core/providers/core_providers.dart';
import 'package:docsbuddy/features/catalog/application/catalog_providers.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Counts how often the catalog repository is (re)created.
class _CountingBackend extends FakeBackend {
  int catalogs = 0;

  @override
  CatalogRepository createCatalogRepository() {
    catalogs++;
    return FakeCatalogRepository(latency: Duration.zero);
  }
}

void main() {
  test('binds the module’s repositories and label', () {
    final container = ProviderContainer.test(overrides: backendOverrides(FakeBackend()));
    expect(container.read(backendLabelProvider), 'Local (fake)');
    expect(container.read(catalogRepositoryProvider), isA<FakeCatalogRepository>());
  });

  test('family-scoped repositories are rebuilt when membership changes, for any backend', () {
    final backend = _CountingBackend();
    final container = ProviderContainer.test(overrides: backendOverrides(backend));

    container.read(catalogRepositoryProvider);
    expect(backend.catalogs, 1);
    container.read(familyScopeProvider.notifier).changed();
    container.read(catalogRepositoryProvider);
    expect(backend.catalogs, 2);
  });

  test('the fake backend keeps one instance so in-memory data survives rebuilds', () {
    final backend = FakeBackend();
    expect(identical(backend.createCatalogRepository(), backend.createCatalogRepository()), isTrue);
  });
}
