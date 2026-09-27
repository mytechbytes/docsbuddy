import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_failure.dart';
import 'catalog_models.dart';
import 'common_categories.dart';
import 'property_specs.dart';

part 'catalog_inputs.freezed.dart';

// ── Validated commands (what repositories accept) ──

/// A validated asset create/update. [categoryId] may be a real catalog FK or
/// a built-in `cat_*` fallback id (treated as no-FK); [typeName] carries the
/// display name for fallback or custom ("Others") types.
@freezed
abstract class AssetInput with _$AssetInput {
  const factory AssetInput({
    required String name,
    required AssetCategoryKind category,
    String? categoryId,
    String? typeName,
    String? locationName,
    String? brand,
    String? model,
    String? serialNo,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? store,
    @Default(<String, String>{}) Map<String, String> properties,
  }) = _AssetInput;
}

/// A validated service create/update.
@freezed
abstract class ReminderInput with _$ReminderInput {
  const factory ReminderInput({
    required ReminderKind kind,
    required String label,
    required DateTime dueDate,
    @Default(Recurrence.none) Recurrence recurrence,

    /// Days before due, largest first. Null = the backend default.
    List<int>? notifyOffsets,
    String? provider,
    String? policyNo,
    double? cost,
    String? notes,
  }) = _ReminderInput;
}

// ── Raw form input (what the UI collects) ──

/// One free-form "label: value" property row on the asset form.
@freezed
abstract class PropertyEntry with _$PropertyEntry {
  const factory PropertyEntry({required String label, required String value}) = _PropertyEntry;
}

/// Everything the Add/Edit-asset form captured, as typed text. [toInput]
/// owns trimming, parsing and validation so the widget never does.
@freezed
abstract class AssetDraft with _$AssetDraft {
  const AssetDraft._();

  const factory AssetDraft({
    required String name,
    required AssetCategoryKind category,

    /// Chosen catalog/built-in type; null with [customType] set = "Others".
    AssetCategory? type,
    String? customType,

    /// Slug whose spec fields the form showed (defaults to [type]'s).
    String? specSlug,
    String? roomName,
    @Default('') String brand,
    @Default('') String model,
    @Default('') String serialNo,
    @Default('') String price,
    @Default('') String store,
    DateTime? purchaseDate,

    /// Values for the type's [PropertySpec] fields, keyed by spec label.
    @Default(<String, String>{}) Map<String, String> specValues,
    @Default(<PropertyEntry>[]) List<PropertyEntry> extraProperties,
  }) = _AssetDraft;

  /// Throws [ValidationFailure] when the draft can't be saved.
  AssetInput toInput() {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) throw const ValidationFailure('Please enter a name.');

    // Fallback/custom types carry their name in typeName (no DB FK).
    final t = type;
    final typeName = t != null ? (isDbCategoryId(t.id) ? null : t.name) : _blankToNull(customType);

    return AssetInput(
      name: trimmedName,
      category: category,
      categoryId: t?.id,
      typeName: typeName,
      locationName: _blankToNull(roomName),
      brand: _blankToNull(brand),
      model: _blankToNull(model),
      serialNo: _blankToNull(serialNo),
      purchaseDate: purchaseDate,
      purchasePrice: parseAmount(price),
      store: _blankToNull(store),
      properties: collectProperties(specSlug ?? t?.slug),
    );
  }

  /// Type-spec values first (in spec order), then non-empty free-form rows.
  Map<String, String> collectProperties(String? slug) {
    final props = <String, String>{};
    for (final spec in propertySpecsFor(slug)) {
      final v = specValues[spec.label]?.trim();
      if (v != null && v.isNotEmpty) props[spec.label] = v;
    }
    for (final e in extraProperties) {
      final key = e.label.trim();
      final value = e.value.trim();
      if (key.isNotEmpty && value.isNotEmpty) props[key] = value;
    }
    return props;
  }
}

/// Everything the Add/Edit-service form captured, as typed text.
@freezed
abstract class ReminderDraft with _$ReminderDraft {
  const ReminderDraft._();

  const factory ReminderDraft({
    required ReminderKind kind,
    required DateTime dueDate,
    required Recurrence recurrence,
    required Set<int> notifyOffsets,
    @Default('') String label,
    @Default('') String provider,
    @Default('') String policyNo,
    @Default('') String cost,
    @Default('') String notes,
  }) = _ReminderDraft;

  ReminderInput toInput() => ReminderInput(
        kind: kind,
        label: label.trim().isEmpty ? kind.label : label.trim(),
        dueDate: dueDate,
        recurrence: recurrence,
        notifyOffsets: sortedOffsets(notifyOffsets),
        provider: _blankToNull(provider),
        policyNo: _blankToNull(policyNo),
        cost: parseAmount(cost),
        notes: _blankToNull(notes),
      );
}

// ── Pure helpers ──

/// Parses a user-typed amount ("42,000", " 4200.50 "); null when blank/invalid.
double? parseAmount(String text) => double.tryParse(text.trim().replaceAll(',', ''));

/// Notify offsets, largest (earliest) first.
List<int> sortedOffsets(Iterable<int> offsets) => offsets.toList()..sort((a, b) => b.compareTo(a));

/// Splits an asset's stored properties into the type's spec fields and the
/// remaining free-form rows (for pre-filling the edit form).
({Map<String, String> specValues, List<PropertyEntry> extras}) splitProperties(
  Map<String, String> properties,
  String? slug,
) {
  final specLabels = propertySpecsFor(slug).map((s) => s.label).toSet();
  final specValues = <String, String>{};
  final extras = <PropertyEntry>[];
  properties.forEach((k, v) {
    if (specLabels.contains(k)) {
      specValues[k] = v;
    } else {
      extras.add(PropertyEntry(label: k, value: v));
    }
  });
  return (specValues: specValues, extras: extras);
}

/// The loaded catalog type an existing asset was saved with (by id).
AssetCategory? resolveAssetType(Asset asset, List<AssetCategory> categories) =>
    categories.where((c) => c.id == asset.categoryId).firstOrNull;

/// Spec slug for an existing asset: its built-in type by id, else by name
/// (the DB seed mirrors [commonAssetCategories], so names line up).
String? specSlugForAsset(Asset asset) => commonAssetCategories
    .where((c) => c.id == asset.categoryId || (asset.categoryName != null && c.name == asset.categoryName))
    .firstOrNull
    ?.slug;

String? _blankToNull(String? s) {
  final t = s?.trim();
  return t == null || t.isEmpty ? null : t;
}
