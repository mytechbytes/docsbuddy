import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/step_flow.dart';
import '../../documents/presentation/attachment_widgets.dart';
import '../application/catalog_providers.dart';
import '../application/editor_controllers.dart';
import '../application/rooms_controller.dart';
import '../domain/catalog_inputs.dart';
import '../domain/catalog_models.dart';
import '../domain/common_categories.dart';
import '../domain/property_specs.dart';
import 'widgets/catalog_widgets.dart';
import 'widgets/asset_form_fields.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

/// Add / edit asset as a 3-step flow:
///   1. Category (responsive grid, includes Other)
///   2. Appliance type for that category (+ always-available custom type)
///   3. Details — photo, name, optional room, purchase info, type properties
class AddAssetPage extends ConsumerStatefulWidget {
  const AddAssetPage({super.key, this.preset, this.initialLocation, this.editing});

  /// Pre-selected type from the appliance picker (screen 05).
  final AssetCategory? preset;

  /// Pre-filled room name (the room-detail "Add here" flow).
  final String? initialLocation;

  /// When set, the page edits this asset instead of creating one — the
  /// AMC/invoice/auto-seed affordances are hidden (services are managed on
  /// the asset detail).
  final Asset? editing;

  @override
  ConsumerState<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends ConsumerState<AddAssetPage> {
  static const _stepCategory = 0;
  static const _stepType = 1;
  static const _stepDetails = 2;

  /// Editing or arriving from the appliance picker skips to details.
  late int _step =
      widget.editing != null || widget.preset != null ? _stepDetails : _stepCategory;

  late final _name = TextEditingController(text: widget.editing?.name ?? '');
  late final _newRoom = TextEditingController();
  late final _brand = TextEditingController(text: widget.editing?.brand ?? '');
  late final _model = TextEditingController(text: widget.editing?.model ?? '');
  late final _serialNo = TextEditingController(text: widget.editing?.serialNo ?? '');
  late final _price = TextEditingController(
      text: widget.editing?.purchasePrice == null ? '' : widget.editing!.purchasePrice!.toStringAsFixed(0));
  late final _store = TextEditingController(text: widget.editing?.store ?? '');
  late AssetCategory? _type = widget.preset;

  /// Once the user picks a type, the edited asset's saved type stops applying.
  bool _typeTouched = false;

  /// Type name entered via the "Others" popup (custom, not in the catalog).
  late String? _customType =
      widget.editing != null && widget.editing!.categoryId == null ? widget.editing!.categoryName : null;

  /// Spec fields shown when editing before the type changes.
  late final String? _editingSlug = widget.editing == null ? null : specSlugForAsset(widget.editing!);
  late AssetCategoryKind _category =
      widget.editing?.category ?? widget.preset?.kindGroup ?? AssetCategoryKind.vehicle;

  /// Selected room name; null = no room; [_newRoomSentinel] = typing a new one.
  static const _newRoomSentinel = '::new::';
  late String? _room = widget.editing?.locationName ?? widget.initialLocation;

  late DateTime? _purchaseDate = widget.editing?.purchaseDate;
  DateTime? _amcDate;
  PickedMedia? _photo;
  final _invoices = <PickedMedia>[];

  /// Values for the type's [PropertySpec] fields, keyed by spec label.
  final _specValues = <String, TextEditingController>{};

  /// Free-form extra properties (label + value rows).
  final _extraProps = <(TextEditingController, TextEditingController)>[];

  bool get _isEdit => widget.editing != null;

  @override
  void initState() {
    super.initState();
    // Editing: pre-fill spec fields and free-form rows from saved properties.
    final split = splitProperties(widget.editing?.properties ?? const {}, _editingSlug);
    split.specValues.forEach((k, v) => _specValues[k] = TextEditingController(text: v));
    for (final e in split.extras) {
      _extraProps.add((TextEditingController(text: e.label), TextEditingController(text: e.value)));
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _newRoom.dispose();
    _brand.dispose();
    _model.dispose();
    _serialNo.dispose();
    _price.dispose();
    _store.dispose();
    for (final c in _specValues.values) {
      c.dispose();
    }
    for (final (k, v) in _extraProps) {
      k.dispose();
      v.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await pickImage(context);
    if (picked != null) setState(() => _photo = picked);
  }

  Future<void> _pickInvoices() async {
    final picked = await pickDocuments(context);
    if (picked.isNotEmpty) setState(() => _invoices.addAll(picked));
  }

  Future<void> _pickDate({required bool amc}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: amc ? (_amcDate ?? now) : (_purchaseDate ?? now),
      firstDate: DateTime(2000),
      lastDate: amc ? DateTime(now.year + 10) : now,
    );
    if (picked != null) setState(() => amc ? _amcDate = picked : _purchaseDate = picked);
  }

  /// "Others" popup — name the custom appliance type.
  Future<void> _askCustomType() async {
    final controller = TextEditingController(text: _customType ?? '');
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.palette.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(context.l10n.catalogCustomTypeTitle,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: context.palette.text)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.palette.text),
          decoration: InputDecoration(
            hintText: context.l10n.catalogCustomTypeHint,
            hintStyle: TextStyle(color: context.palette.placeholder, fontWeight: FontWeight.w400),
          ),
          onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: Text(context.l10n.catalogUseType, style: TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    setState(() {
      _customType = name;
      _type = null;
      _typeTouched = true;
      _step = _stepDetails;
    });
  }

  void _selectType(AssetCategory c) {
    setState(() {
      _type = c;
      _customType = null;
      _typeTouched = true;
      _category = c.kindGroup;
      _step = _stepDetails;
    });
  }

  /// The type in effect: the picked one, else (editing) the saved one.
  AssetCategory? _effectiveType(List<AssetCategory> categories) => _typeTouched || widget.editing == null
      ? _type
      : _type ?? resolveAssetType(widget.editing!, categories);

  String? _specSlug(AssetCategory? type) => type?.slug ?? (_typeTouched ? null : _editingSlug);

  /// Snapshot of the form as typed; the controller validates and parses it.
  AssetDraft _draft(AssetCategory? type) => AssetDraft(
        name: _name.text,
        category: _category,
        type: type,
        customType: _customType,
        specSlug: _specSlug(type),
        roomName: _room == _newRoomSentinel ? _newRoom.text : _room,
        brand: _brand.text,
        model: _model.text,
        serialNo: _serialNo.text,
        price: _price.text,
        store: _store.text,
        purchaseDate: _purchaseDate,
        specValues: {for (final e in _specValues.entries) e.key: e.value.text},
        extraProperties: [for (final (k, v) in _extraProps) PropertyEntry(label: k.text, value: v.text)],
      );

  Future<void> _save(AssetCategory? type) async {
    final ok = await runAction(
      context,
      () => ref.read(assetEditorControllerProvider.notifier).save(
            draft: _draft(type),
            editing: widget.editing,
            photo: _photo,
            invoices: _invoices,
            amcDate: _amcDate,
          ),
    );
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).value ?? commonAssetCategories;
    final saving = ref.watch(assetEditorControllerProvider).isLoading;
    final type = _effectiveType(categories);

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.palette.text),
        title: Text(_isEdit ? context.l10n.catalogEditAsset : context.l10n.catalogAddAsset,
            style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              children: switch (_step) {
                _stepCategory => _categoryStep(),
                _stepType => _typeStep(categories),
                _ => _detailsStep(type),
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: StepNav(
                step: _step,
                busy: saving,
                nextLabel: switch (_step) {
                  _stepCategory => context.l10n.commonNext,
                  _stepType => type == null && _customType == null ? context.l10n.commonSkip : context.l10n.commonNext,
                  _ => _isEdit ? context.l10n.catalogSaveChanges : context.l10n.catalogSaveAsset,
                },
                onBack: () => setState(() => _step--),
                onNext: () {
                  if (_step < _stepDetails) {
                    setState(() => _step++);
                  } else {
                    _save(type);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 1: category ──
  List<Widget> _categoryStep() {
    return [
      StepHeader(step: 0, total: 3, title: context.l10n.catalogChooseCategory, subtitle: context.l10n.catalogChooseCategorySubtitle),
      const SizedBox(height: 18),
      LayoutBuilder(
        builder: (context, constraints) {
          // 1 / 2 / 3 columns depending on available width.
          final w = constraints.maxWidth;
          final cols = w < 240 ? 1 : (w < 480 ? 2 : 3);
          return GridView.count(
            crossAxisCount: cols,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: cols == 1 ? 3.4 : 1.55,
            children: [
              for (final c in AssetCategoryKind.values)
                CategoryCard(
                  kind: c,
                  selected: _category == c,
                  onTap: () => setState(() {
                    if (_category != c) {
                      _category = c;
                      _type = null;
                      _typeTouched = true;
                    }
                    _step = _stepType;
                  }),
                ),
            ],
          );
        },
      ),
    ];
  }

  // ── Step 2: appliance type ──
  List<Widget> _typeStep(List<AssetCategory> categories) {
    final forCategory = categories.where((c) => c.kindGroup == _category).toList();
    return [
      StepHeader(
          step: 1,
          total: 3,
          title: context.l10n.catalogSelectAppliance,
          subtitle: forCategory.isEmpty
              ? context.l10n.catalogNoPresetTypes(_category.displayName(context))
              : context.l10n.catalogTypesIn(_category.displayName(context))),
      const SizedBox(height: 18),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final c in forCategory)
            AssetTypeChip(
              icon: c.icon,
              label: c.name,
              selected: _type?.id == c.id,
              onTap: () => _selectType(c),
            ),
          // The custom type escape hatch is always available.
          AssetTypeChip(
            icon: _customType == null ? Icons.add_circle_outline : Icons.edit_outlined,
            label: _customType ?? context.l10n.catalogOthers,
            selected: _customType != null,
            onTap: _askCustomType,
          ),
        ],
      ),
    ];
  }

  // ── Step 3: details ──
  List<Widget> _detailsStep(AssetCategory? type) {
    final specs = propertySpecsFor(_specSlug(type));
    final rooms = ref.watch(locationsProvider).value ?? const <Location>[];
    return [
      StepHeader(
          step: 2,
          total: 3,
          title: type?.name ?? _customType ?? context.l10n.catalogDetails,
          subtitle: context.l10n.catalogOnlyNameRequired),
      const SizedBox(height: 16),
      Center(child: AssetPhotoPicker(photo: _photo, existingRef: widget.editing?.imageUrl, onTap: _pickPhoto)),
      const SizedBox(height: 18),
      AppTextField(label: context.l10n.catalogName, controller: _name, icon: Icons.label_outline, hint: context.l10n.catalogNameHint),
      const SizedBox(height: 14),
      Text(context.l10n.catalogRoomOptional, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.text)),
      const SizedBox(height: 6),
      RoomDropdown(
        rooms: rooms,
        value: _room,
        newRoomSentinel: _newRoomSentinel,
        onChanged: (v) => setState(() => _room = v),
      ),
      if (_room == _newRoomSentinel) ...[
        const SizedBox(height: 10),
        AppTextField(label: '', controller: _newRoom, icon: Icons.place_outlined, hint: context.l10n.catalogNewRoomHint),
      ],
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(child: AppTextField(label: context.l10n.catalogBrand, controller: _brand, hint: context.l10n.commonOptional)),
          const SizedBox(width: 12),
          Expanded(child: AppTextField(label: context.l10n.catalogModelNumber, controller: _model, hint: context.l10n.commonOptional)),
        ],
      ),
      const SizedBox(height: 14),
      AppTextField(label: context.l10n.catalogSerialNo, controller: _serialNo, icon: Icons.tag, hint: context.l10n.catalogSerialHint),
      const SizedBox(height: 14),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: DateField(label: context.l10n.catalogPurchaseDate, value: _purchaseDate, onTap: () => _pickDate(amc: false))),
          const SizedBox(width: 12),
          Expanded(
            child: AppTextField(
              label: context.l10n.catalogPurchasePrice,
              controller: _price,
              hint: context.l10n.catalogPriceHint,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      AppTextField(label: context.l10n.catalogStore, controller: _store, icon: Icons.storefront_outlined, hint: context.l10n.catalogStoreHint),

      // ── Type-specific properties ──
      const SizedBox(height: 20),
      Text(context.l10n.catalogDetailsFor(type?.name ?? _customType ?? context.l10n.catalogThisAppliance).toUpperCase(),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.textMuted, letterSpacing: 1)),
      const SizedBox(height: 10),
      for (final spec in specs) ...[
        AppTextField(
          label: spec.label,
          controller: _specValues.putIfAbsent(spec.label, TextEditingController.new),
          hint: spec.hint,
        ),
        const SizedBox(height: 12),
      ],
      for (var i = 0; i < _extraProps.length; i++) ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: AppTextField(label: '', controller: _extraProps[i].$1, hint: context.l10n.catalogPropertyHint)),
            const SizedBox(width: 10),
            Expanded(child: AppTextField(label: '', controller: _extraProps[i].$2, hint: context.l10n.catalogValueHint)),
            IconButton(
              icon: Icon(Icons.remove_circle_outline, size: 20, color: context.palette.textMuted),
              onPressed: () => setState(() {
                final (k, v) = _extraProps.removeAt(i);
                k.dispose();
                v.dispose();
              }),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () =>
              setState(() => _extraProps.add((TextEditingController(), TextEditingController()))),
          icon: const Icon(Icons.add, size: 18),
          label: Text(context.l10n.catalogAddProperty, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),

      if (!_isEdit) ...[
        const SizedBox(height: 8),
        DateField(label: context.l10n.catalogAmcDate, value: _amcDate, onTap: () => _pickDate(amc: true)),
        const SizedBox(height: 14),
        Text(context.l10n.catalogInvoices,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.text)),
        const SizedBox(height: 8),
        PickedMediaGrid(files: _invoices, onRemove: (i) => setState(() => _invoices.removeAt(i))),
        if (_invoices.isNotEmpty) const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _pickInvoices,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: BorderSide(color: context.palette.fieldBorder, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: Icon(Icons.upload_file_outlined, size: 18, color: context.palette.textSecondary),
          label: Text(context.l10n.catalogAttachInvoice,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.palette.text)),
        ),
        if (type != null && type.defaults.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: context.palette.accentSoft, borderRadius: BorderRadius.circular(12)),
            child: Text(
              context.l10n.catalogWillAutoAdd(type.defaults.map((d) => d.label).join(' · ')),
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: context.palette.accent),
            ),
          ),
        ],
      ],
    ];
  }
}
