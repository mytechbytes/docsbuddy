import 'dart:typed_data';

import 'catalog_models.dart';
import 'catalog_repository.dart';

/// In-memory catalog with seed data so the dashboard/assets screens have content
/// out of the box (local dev, tests, the offline build).
class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository() {
    _seed();
  }

  final _assets = <Asset>[];
  final _reminders = <Reminder>[];
  final _locations = <Location>[];
  int _seq = 0;

  String _id(String p) => '${p}_${_seq++}';
  DateTime _inDays(int d) => DateTime.now().add(Duration(days: d));
  Future<void> _delay() => Future<void>.delayed(const Duration(milliseconds: 350));

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
    return _assets.firstWhere((a) => a.id == id);
  }

  @override
  Future<List<Reminder>> remindersFor(String assetId) async {
    await _delay();
    return (_sorted.where((r) => r.assetId == assetId)).toList();
  }

  @override
  Future<List<Location>> locations() async {
    await _delay();
    int count(String name) => _assets.where((a) => (a.locationName ?? '').toLowerCase() == name.toLowerCase()).length;
    return [
      for (final l in _locations)
        Location(id: l.id, name: l.name, assetCount: count(l.name), kind: l.kind, imageUrl: l.imageUrl, parentId: l.parentId),
    ];
  }

  @override
  Future<Asset> addAsset({
    required String name,
    required AssetCategoryKind category,
    String? locationName,
    String? brand,
    String? model,
    String? serialNo,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? store,
  }) async {
    await _delay();
    final loc = locationName?.trim();
    if (loc != null && loc.isNotEmpty && !_locations.any((l) => l.name.toLowerCase() == loc.toLowerCase())) {
      _locations.add(Location(id: _id('l'), name: loc, kind: 'room'));
    }
    final a = Asset(
      id: _id('a'),
      name: name.trim(),
      category: category,
      locationName: loc == null || loc.isEmpty ? null : loc,
      brand: brand,
      model: model,
      serialNo: serialNo,
      purchaseDate: purchaseDate,
      purchasePrice: purchasePrice,
      store: store,
    );
    _assets.add(a);
    return a;
  }

  @override
  Future<Reminder> addReminder({
    required String assetId,
    required ReminderKind kind,
    required String label,
    required DateTime dueDate,
    Recurrence recurrence = Recurrence.none,
    List<int>? notifyOffsets,
    String? provider,
    String? policyNo,
    double? cost,
    String? notes,
  }) async {
    await _delay();
    final asset = _assets.firstWhere((a) => a.id == assetId);
    final r = Reminder(
      id: _id('r'),
      assetId: assetId,
      assetName: asset.name,
      kind: kind,
      label: label.trim(),
      dueDate: dueDate,
      recurrence: recurrence,
      notifyOffsets: notifyOffsets ?? const [30, 7, 1],
      provider: provider,
      policyNo: policyNo,
      cost: cost,
      notes: notes,
    );
    _reminders.add(r);
    return r;
  }

  @override
  Future<void> completeReminder(String reminderId) async {
    await _delay();
    final i = _reminders.indexWhere((r) => r.id == reminderId);
    if (i < 0) return;
    final r = _reminders.removeAt(i);
    // Mirror complete_asset_date(): recurring services roll forward.
    final months = switch (r.recurrence) {
      Recurrence.monthly => 1,
      Recurrence.quarterly => 3,
      Recurrence.halfYearly => 6,
      Recurrence.yearly => 12,
      Recurrence.none => 0,
    };
    if (months > 0) {
      _reminders.add(Reminder(
        id: r.id,
        assetId: r.assetId,
        assetName: r.assetName,
        kind: r.kind,
        label: r.label,
        dueDate: DateTime(r.dueDate.year, r.dueDate.month + months, r.dueDate.day),
        recurrence: r.recurrence,
        notifyOffsets: r.notifyOffsets,
        provider: r.provider,
        policyNo: r.policyNo,
        cost: r.cost,
        notes: r.notes,
      ));
    }
  }

  @override
  Future<Asset> setAssetImage(
    String assetId, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    await _delay();
    final i = _assets.indexWhere((a) => a.id == assetId);
    if (i < 0) throw Exception('Asset not found.');
    final a = _assets[i];
    // No real storage locally — record a marker ref; the UI shows the fallback.
    final updated = Asset(
      id: a.id,
      name: a.name,
      category: a.category,
      locationName: a.locationName,
      locationId: a.locationId,
      brand: a.brand,
      model: a.model,
      serialNo: a.serialNo,
      purchaseDate: a.purchaseDate,
      purchasePrice: a.purchasePrice,
      store: a.store,
      imageUrl: 'local/$assetId/$fileName',
    );
    _assets[i] = updated;
    return updated;
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
    _locations[i] = Location(
        id: old.id, name: name.trim(), assetCount: old.assetCount, kind: old.kind, imageUrl: old.imageUrl, parentId: old.parentId);
  }
}
