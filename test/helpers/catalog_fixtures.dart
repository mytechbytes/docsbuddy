import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';

/// A reminder due [days] from now (or from [base]).
Reminder reminderDueIn(
  int days, {
  String? id,
  String assetId = 'a1',
  String assetName = 'Bike',
  ReminderKind kind = ReminderKind.insurance,
  List<int> offsets = const [30, 7, 1],
  DateTime? base,
}) =>
    Reminder(
      id: id ?? 'r$days-${kind.name}-$assetId',
      assetId: assetId,
      assetName: assetName,
      kind: kind,
      label: kind.label,
      dueDate: (base ?? DateTime.now()).add(Duration(days: days)),
      notifyOffsets: offsets,
    );

const acCategory = AssetCategory(id: 'c1', slug: 'appliance-ac', name: 'Air Conditioner', defaults: [
  DefaultReminder(kind: ReminderKind.amc, label: 'AMC', startMonths: 12, recurrence: Recurrence.yearly),
  DefaultReminder(kind: ReminderKind.service, label: 'Wet Service', startMonths: 6, recurrence: Recurrence.halfYearly),
  DefaultReminder(kind: ReminderKind.warranty, label: 'Warranty', startMonths: 12),
]);
