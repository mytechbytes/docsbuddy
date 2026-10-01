// Play Store screenshot harness — the real app on the in-memory fakes (no
// Supabase), pre-seeded with a signed-in user, a family, documents and a
// realistic home inventory so every screen looks lived-in.
// NOT shipped — run it only to capture store screenshots:
//
//   flutter run -t lib/main_store_screenshots.dart -d <simulator>
//
// Everything here is fictional demo data.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'bootstrap/backends/fake_backend.dart';
import 'bootstrap/dependencies.dart';
import 'core/logging/app_logger.dart';
import 'features/auth/data/fake_auth_repository.dart';
import 'features/catalog/data/fake_catalog_repository.dart';
import 'features/catalog/domain/catalog_enums.dart';
import 'features/catalog/domain/catalog_inputs.dart';
import 'features/documents/data/fake_document_repository.dart';
import 'features/documents/domain/document_models.dart';
import 'features/family/data/fake_family_repository.dart';
import 'features/family/domain/family_models.dart';
import 'features/profile/data/fake_profile_repository.dart';
import 'features/profile/domain/profile.dart';

class _SignedInFakeAuth extends FakeAuthRepository {
  @override
  bool get isSignedIn => true;
}

class _DemoProfile extends FakeProfileRepository {
  @override
  Future<Profile> get() async => const Profile(
        id: 'u_demo',
        displayName: 'Anand Kumar',
        email: 'anand.kumar@example.com',
        phone: '+91 98123 45678',
        verified: true,
      );
}

class _DemoFamily extends FakeFamilyRepository {
  static const _family = Family(id: 'fam_demo', name: 'Kumar Family', ownerId: 'me');
  static const _members = [
    FamilyMember(userId: 'me', displayName: 'Anand Kumar', role: FamilyRole.owner, phone: '+91 98123 45678'),
    FamilyMember(userId: 'u2', displayName: 'Priya Kumar', role: FamilyRole.admin),
    FamilyMember(userId: 'u3', displayName: 'Rohan Kumar', role: FamilyRole.member),
    FamilyMember(userId: 'u4', displayName: 'Meera Kumar', role: FamilyRole.viewer),
  ];

  @override
  Future<Family?> currentFamily() async => _family;

  @override
  Future<List<FamilyMember>> members(String familyId) async => _members;
}

/// The same believable set of files on every asset's detail screen.
class _DemoDocuments extends FakeDocumentRepository {
  @override
  Future<List<DocumentMeta>> forAsset(String assetId) async {
    DocumentMeta doc(String title, DocKind kind, String mime, int kb, int daysAgo) => DocumentMeta(
          id: '$assetId-$title',
          assetId: assetId,
          title: title,
          kind: kind,
          mimeType: mime,
          sizeBytes: kb * 1024,
          storagePath: 'demo/$assetId/$title',
          createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
        );
    return [
      doc('Invoice.pdf', DocKind.invoice, 'application/pdf', 412, 210),
      doc('Warranty.pdf', DocKind.warranty, 'application/pdf', 188, 210),
      doc('Manual.pdf', DocKind.manual, 'application/pdf', 2480, 205),
    ];
  }

  @override
  Future<int> countAll() async => 14;
}

DateTime _inDays(int d) => DateTime.now().add(Duration(days: d));

Future<void> _enrich(FakeCatalogRepository catalog) async {
  Future<void> add(AssetInput asset, List<ReminderInput> services) async {
    final a = await catalog.addAsset(asset);
    for (final s in services) {
      await catalog.addReminder(a.id, s);
    }
  }

  await add(
    AssetInput(
      name: 'Daikin Inverter AC',
      category: AssetCategoryKind.appliance,
      locationName: 'Living Room',
      brand: 'Daikin',
      model: 'FTKM50',
      serialNo: 'DK-7731-2290',
      purchaseDate: DateTime(2023, 5, 18),
      purchasePrice: 46500,
      store: 'Reliance Digital',
    ),
    [
      ReminderInput(
          kind: ReminderKind.service,
          label: 'Service',
          dueDate: _inDays(12),
          recurrence: Recurrence.halfYearly,
          notifyOffsets: const [14, 3, 1],
          provider: 'Daikin Care',
          cost: 1800),
      ReminderInput(
          kind: ReminderKind.amc,
          label: 'AMC',
          dueDate: _inDays(190),
          recurrence: Recurrence.yearly,
          notifyOffsets: const [30, 7, 1],
          provider: 'Daikin Care',
          cost: 5200),
    ],
  );
  await add(
    AssetInput(
      name: 'LG 7 kg Front Load',
      category: AssetCategoryKind.appliance,
      locationName: 'Utility',
      brand: 'LG',
      model: 'FHM1207ZDL',
      purchaseDate: DateTime(2024, 1, 9),
      purchasePrice: 31990,
      store: 'Croma',
    ),
    [
      ReminderInput(
          kind: ReminderKind.warranty,
          label: 'Warranty',
          dueDate: _inDays(140),
          notifyOffsets: const [30, 7],
          provider: 'LG Electronics'),
    ],
  );
  await add(
    AssetInput(
      name: 'Honda City ZX',
      category: AssetCategoryKind.vehicle,
      locationName: 'Garage',
      brand: 'Honda',
      model: 'City ZX CVT',
      serialNo: 'KA 03 MN 4567',
      purchaseDate: DateTime(2022, 11, 4),
      purchasePrice: 1425000,
      store: 'Honda Cars Indiranagar',
    ),
    [
      ReminderInput(
          kind: ReminderKind.insurance,
          label: 'Insurance',
          dueDate: _inDays(18),
          recurrence: Recurrence.yearly,
          notifyOffsets: const [60, 14, 1],
          provider: 'ICICI Lombard',
          policyNo: 'ICL-MOT-5521907',
          cost: 21800),
      ReminderInput(
          kind: ReminderKind.pollution,
          label: 'Pollution (PUC)',
          dueDate: _inDays(9),
          recurrence: Recurrence.halfYearly,
          notifyOffsets: const [7, 1]),
    ],
  );
  await add(
    AssetInput(
      name: 'Sony Bravia 55" 4K',
      category: AssetCategoryKind.electronics,
      locationName: 'Living Room',
      brand: 'Sony',
      model: 'KD-55X75K',
      purchaseDate: DateTime(2024, 10, 20),
      purchasePrice: 61990,
      store: 'Amazon',
    ),
    [
      ReminderInput(
          kind: ReminderKind.warranty,
          label: 'Warranty',
          dueDate: _inDays(210),
          notifyOffsets: const [30, 7],
          provider: 'Sony India'),
    ],
  );
  await add(
    AssetInput(
      name: 'Kent RO Water Purifier',
      category: AssetCategoryKind.appliance,
      locationName: 'Kitchen',
      brand: 'Kent',
      model: 'Grand Plus',
      purchaseDate: DateTime(2023, 7, 2),
      purchasePrice: 15500,
      store: 'Kent Retail',
    ),
    [
      ReminderInput(
          kind: ReminderKind.service,
          label: 'Filter service',
          dueDate: _inDays(6),
          recurrence: Recurrence.quarterly,
          notifyOffsets: const [7, 1],
          provider: 'Kent Care',
          cost: 1200),
    ],
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Test-only API, used deliberately: this harness is never shipped.
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({'onboarding_complete': true});
  final prefs = await SharedPreferences.getInstance();

  final catalog = FakeCatalogRepository(latency: const Duration(milliseconds: 40));
  await _enrich(catalog);

  runApp(
    ProviderScope(
      overrides: [
        ...platformOverrides(prefs, logger: const DebugAppLogger(), firebaseReady: false),
        ...backendOverrides(FakeBackend(
          auth: _SignedInFakeAuth(),
          catalog: catalog,
          documents: _DemoDocuments(),
          family: _DemoFamily(),
          profile: _DemoProfile(),
        )),
      ],
      child: const DocsBuddyApp(),
    ),
  );
}
