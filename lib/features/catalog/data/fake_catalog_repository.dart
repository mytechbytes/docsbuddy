import 'dart:typed_data';

import '../../../core/error/app_failure.dart';
import '../domain/catalog_inputs.dart';
import '../domain/catalog_models.dart';
import '../domain/catalog_repository.dart';
import '../domain/common_categories.dart';

/// In-memory catalog with seed data so the dashboard/assets screens have content
/// out of the box (local dev, tests, the offline build).
class FakeCatalogRepository implements CatalogRepository {
  /// [latency] simulates the network so screens show their loading states.
  /// [seed] false starts with no assets, reminders or rooms (a new account).
  FakeCatalogRepository({this.latency = const Duration(milliseconds: 350), bool seed = true}) {
    if (seed) _seed();
  }

  final Duration latency;

  final _assets = <Asset>[];
  final _reminders = <Reminder>[];
  final _locations = <Location>[];
  int _seq = 0;

  String _id(String p) => '${p}_${_seq++}';
  DateTime _inDays(int d) => DateTime.now().add(Duration(days: d));

  /// No timer at zero latency: seeding is a chain of awaited calls, and in a
  /// browser each `Future.delayed(zero)` is a real, clamped `setTimeout`.
  Future<void> _delay() => latency == Duration.zero ? Future<void>.value() : Future<void>.delayed(latency);

  void _seed() {
    final bike = Asset(
        id: _id('a'),
        name: 'Royal Enfield Classic',
        category: AssetCategoryKind.vehicle,
        locationName: 'Garage',
        brand: 'Royal Enfield',
        model: 'Classic 350',
        serialNo: 'TN 01 AB 1234',
        purchaseDate: DateTime(2023, 3, 12),
        purchasePrice: 195000,
        store: 'RE Motors, Chennai');
    final fridge = Asset(
        id: _id('a'),
        name: 'Samsung 340L Fridge',
        category: AssetCategoryKind.appliance,
        locationName: 'Kitchen',
        brand: 'Samsung',
        serialNo: 'RT34K5538S8',
        purchaseDate: DateTime(2024, 8, 2),
        purchasePrice: 42000,
        store: 'Croma');
    final phone = Asset(
        id: _id('a'),
        name: 'iPhone 15 Pro',
        category: AssetCategoryKind.electronics,
        locationName: 'Bedroom',
        brand: 'Apple',
        model: '15 Pro');
    _assets.addAll([bike, fridge, phone]);
    _reminders.addAll([
      Reminder(
          id: _id('r'),
          assetId: bike.id,
          assetName: bike.name,
          kind: ReminderKind.pollution,
          label: 'Pollution',
          dueDate: _inDays(4),
          recurrence: Recurrence.yearly,
          notifyOffsets: const [30, 1]),
      Reminder(
          id: _id('r'),
          assetId: bike.id,
          assetName: bike.name,
          kind: ReminderKind.insurance,
          label: 'Insurance',
          dueDate: _inDays(25),
          recurrence: Recurrence.yearly,
          notifyOffsets: const [60, 14, 1],
          provider: 'Acko General',
          policyNo: 'ACKO-2W-88231',
          cost: 4200),
      Reminder(
          id: _id('r'),
          assetId: fridge.id,
          assetName: fridge.name,
          kind: ReminderKind.warranty,
          label: 'Warranty',
          dueDate: _inDays(70),
          provider: 'Samsung Care'),
      Reminder(
          id: _id('r'),
          assetId: phone.id,
          assetName: phone.name,
          kind: ReminderKind.amc,
          label: 'AppleCare',
          dueDate: _inDays(-2),
          provider: 'Apple',
          policyNo: 'AC+9921',
          cost: 14900),
    ]);
    for (final n in const ['Garage', 'Kitchen', 'Bedroom']) {
      _locations.add(Location(id: _id('l'), name: n, kind: 'room'));
    }
  }

  List<Reminder> get _sorted => [..._reminders]..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  /// Mirrors the 0005 seed so the picker works offline.
  static const _categories = commonAssetCategories;

  int _indexOf<T>(List<T> list, bool Function(T) test, String what) {
    final i = list.indexWhere(test);
    if (i < 0) throw ServerFailure('$what not found.');
    return i;
  }

  void _ensureLocation(String? name) {
    final loc = name?.trim();
    if (loc != null && loc.isNotEmpty && !_locations.any((l) => l.name.toLowerCase() == loc.toLowerCase())) {
      _locations.add(Location(id: _id('l'), name: loc, kind: 'room'));
    }
  }

  @override
  Future<List<AssetCategory>> categories() async {
    await _delay();
    return List.unmodifiable(_categories);
  }

  @override
  Future<List<Reminder>> upcomingReminders({int withinDays = 365}) async {
    await _delay();
    return _sorted.where((r) => r.daysLeft <= withinDays).toList();
  }

  @override
  Future<List<Asset>> assets() async {
    await _delay();
    return List.unmodifiable(_assets);
  }

  @override
  Future<Asset> asset(String id) async {
    await _delay();
    return _assets[_indexOf(_assets, (a) => a.id == id, 'Asset')];
  }

  @override
  Future<List<Reminder>> remindersFor(String assetId) async {
    await _delay();
    return _sorted.where((r) => r.assetId == assetId).toList();
  }

  @override
  Future<List<Location>> locations() async {
    await _delay();
    int count(String name) => _assets.where((a) => (a.locationName ?? '').toLowerCase() == name.toLowerCase()).length;
    return [for (final l in _locations) l.copyWith(assetCount: count(l.name))];
  }

  @override
  Future<Asset> addAsset(AssetInput input) async {
    await _delay();
    _ensureLocation(input.locationName);
    final cat = _categories.where((c) => c.id == input.categoryId).firstOrNull;
    final loc = input.locationName?.trim();
    final a = Asset(
      id: _id('a'),
      name: input.name.trim(),
      category: cat?.kindGroup ?? input.category,
      categoryId: input.categoryId,
      categoryName: cat?.name ?? input.typeName,
      locationName: loc == null || loc.isEmpty ? null : loc,
      brand: input.brand,
      model: input.model,
      serialNo: input.serialNo,
      purchaseDate: input.purchaseDate,
      purchasePrice: input.purchasePrice,
      store: input.store,
      properties: input.properties,
    );
    _assets.add(a);
    return a;
  }

  @override
  Future<Asset> updateAsset(String id, AssetInput input) async {
    await _delay();
    final i = _indexOf(_assets, (a) => a.id == id, 'Asset');
    final a = _assets[i];
    _ensureLocation(input.locationName);
    final cat = _categories.where((c) => c.id == input.categoryId).firstOrNull;
    final loc = input.locationName?.trim();
    final updated = a.copyWith(
      name: input.name.trim().isNotEmpty ? input.name.trim() : a.name,
      category: cat?.kindGroup ?? input.category,
      categoryId: input.categoryId ?? a.categoryId,
      categoryName: cat?.name ?? input.typeName ?? a.categoryName,
      locationName: loc != null && loc.isNotEmpty ? loc : a.locationName,
      brand: input.brand,
      model: input.model,
      serialNo: input.serialNo,
      purchaseDate: input.purchaseDate,
      purchasePrice: input.purchasePrice,
      store: input.store,
      properties: input.properties,
    );
    _assets[i] = updated;
    // Keep reminder rows' asset name in sync.
    for (var j = 0; j < _reminders.length; j++) {
      if (_reminders[j].assetId == id) _reminders[j] = _reminders[j].copyWith(assetName: updated.name);
    }
    return updated;
  }

  @override
  Future<void> deleteAsset(String id) async {
    await _delay();
    _assets.removeWhere((a) => a.id == id);
    _reminders.removeWhere((r) => r.assetId == id);
  }

  @override
  Future<Reminder> addReminder(String assetId, ReminderInput input) async {
    await _delay();
    final asset = _assets[_indexOf(_assets, (a) => a.id == assetId, 'Asset')];
    final r = Reminder(
      id: _id('r'),
      assetId: assetId,
      assetName: asset.name,
      kind: input.kind,
      label: input.label.trim().isEmpty ? input.kind.label : input.label.trim(),
      dueDate: input.dueDate,
      recurrence: input.recurrence,
      notifyOffsets: input.notifyOffsets ?? const [30, 7, 1],
      provider: input.provider,
      policyNo: input.policyNo,
      cost: input.cost,
      notes: input.notes,
    );
    _reminders.add(r);
    return r;
  }

  @override
  Future<Reminder> updateReminder(String id, ReminderInput input) async {
    await _delay();
    final i = _indexOf(_reminders, (r) => r.id == id, 'Reminder');
    final updated = _reminders[i].copyWith(
      kind: input.kind,
      label: input.label.trim().isEmpty ? input.kind.label : input.label.trim(),
      dueDate: input.dueDate,
      recurrence: input.recurrence,
      notifyOffsets: input.notifyOffsets ?? _reminders[i].notifyOffsets,
      provider: input.provider,
      policyNo: input.policyNo,
      cost: input.cost,
      notes: input.notes,
    );
    _reminders[i] = updated;
    return updated;
  }

  @override
  Future<void> deleteReminder(String id) async {
    await _delay();
    _reminders.removeWhere((r) => r.id == id);
  }

  /// Mirrors complete_asset_date(): recurring services roll forward.
  @override
  Future<void> completeReminder(String reminderId) async {
    await _delay();
    final i = _reminders.indexWhere((r) => r.id == reminderId);
    if (i < 0) return;
    final r = _reminders.removeAt(i);
    final months = r.recurrence.stepMonths;
    if (months > 0) {
      _reminders.add(r.copyWith(dueDate: DateTime(r.dueDate.year, r.dueDate.month + months, r.dueDate.day)));
    }
  }

  /// No real storage locally — record a marker ref; the UI shows the fallback.
  @override
  Future<Asset> setAssetImage(
    String assetId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    await _delay();
    final i = _indexOf(_assets, (a) => a.id == assetId, 'Asset');
    return _assets[i] = _assets[i].copyWith(imageUrl: 'local/$assetId/$fileName');
  }

  @override
  Future<String?> resolveImageUrl(String? imageRef) async {
    if (imageRef == null) return null;
    return imageRef.startsWith('http') ? imageRef : null;
  }

  @override
  Future<Location> createLocation(String name) async {
    await _delay();
    final n = name.trim();
    final existing = _locations.where((l) => l.name.toLowerCase() == n.toLowerCase());
    if (existing.isNotEmpty) return existing.first;
    final l = Location(id: _id('l'), name: n, kind: 'room');
    _locations.add(l);
    return l;
  }

  @override
  Future<void> updateLocation(String id, {String? name}) async {
    await _delay();
    final i = _locations.indexWhere((l) => l.id == id);
    if (i < 0 || name == null || name.trim().isEmpty) return;
    final old = _locations[i];
    final renamed = _locations[i] = old.copyWith(name: name.trim());
    // Keep assets pointing at the room by name in this in-memory impl.
    for (var j = 0; j < _assets.length; j++) {
      if ((_assets[j].locationName ?? '').toLowerCase() == old.name.toLowerCase()) {
        _assets[j] = _assets[j].copyWith(locationName: renamed.name);
      }
    }
  }

  @override
  Future<void> reorderLocations(List<String> orderedIds) async {
    await _delay();
    int rank(Location l) {
      final i = orderedIds.indexOf(l.id);
      return i < 0 ? orderedIds.length : i;
    }

    _locations.sort((a, b) => rank(a).compareTo(rank(b)));
  }

  @override
  Future<void> setLocationImage(
    String locationId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    await _delay();
    final i = _indexOf(_locations, (l) => l.id == locationId, 'Room');
    _locations[i] = _locations[i].copyWith(imageUrl: 'local/$locationId/$fileName');
  }
}
