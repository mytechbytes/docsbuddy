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
  int _seq = 0;

  String _id(String p) => '${p}_${_seq++}';
  DateTime _inDays(int d) => DateTime.now().add(Duration(days: d));
  Future<void> _delay() => Future<void>.delayed(const Duration(milliseconds: 350));

  void _seed() {
    final bike = Asset(id: _id('a'), name: 'Royal Enfield Classic', category: AssetCategoryKind.vehicle, locationName: 'Garage', brand: 'Royal Enfield');
    final fridge = Asset(id: _id('a'), name: 'Samsung 340L Fridge', category: AssetCategoryKind.appliance, locationName: 'Kitchen', brand: 'Samsung');
    final phone = Asset(id: _id('a'), name: 'iPhone 15 Pro', category: AssetCategoryKind.electronics, locationName: 'Bedroom', brand: 'Apple');
    _assets.addAll([bike, fridge, phone]);
    _reminders.addAll([
      Reminder(id: _id('r'), assetId: bike.id, assetName: bike.name, kind: ReminderKind.pollution, label: 'Pollution', dueDate: _inDays(4), recurrence: Recurrence.yearly),
      Reminder(id: _id('r'), assetId: bike.id, assetName: bike.name, kind: ReminderKind.insurance, label: 'Insurance', dueDate: _inDays(25), recurrence: Recurrence.yearly),
      Reminder(id: _id('r'), assetId: fridge.id, assetName: fridge.name, kind: ReminderKind.warranty, label: 'Warranty', dueDate: _inDays(70)),
      Reminder(id: _id('r'), assetId: phone.id, assetName: phone.name, kind: ReminderKind.amc, label: 'AppleCare', dueDate: _inDays(-2)),
    ]);
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
    final byName = <String, int>{};
    for (final a in _assets) {
      final n = a.locationName ?? 'Unassigned';
      byName[n] = (byName[n] ?? 0) + 1;
    }
    return byName.entries.map((e) => Location(id: e.key, name: e.key, assetCount: e.value)).toList();
  }

  @override
  Future<Asset> addAsset({
    required String name,
    required AssetCategoryKind category,
    String? locationName,
    String? brand,
    String? model,
  }) async {
    await _delay();
    final a = Asset(id: _id('a'), name: name.trim(), category: category, locationName: locationName, brand: brand, model: model);
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
  }) async {
    await _delay();
    final asset = _assets.firstWhere((a) => a.id == assetId);
    final r = Reminder(id: _id('r'), assetId: assetId, assetName: asset.name, kind: kind, label: label.trim(), dueDate: dueDate, recurrence: recurrence);
    _reminders.add(r);
    return r;
  }

  @override
  Future<void> completeReminder(String reminderId) async {
    await _delay();
    _reminders.removeWhere((r) => r.id == reminderId);
  }
}
