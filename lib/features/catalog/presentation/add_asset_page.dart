import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../../documents/application/document_providers.dart';
import '../../documents/data/document_models.dart';
import '../application/catalog_providers.dart';
import '../application/common_categories.dart';
import '../application/default_reminders.dart';
import '../data/catalog_models.dart';

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
  late final _name = TextEditingController(text: widget.editing?.name ?? '');
  late final _location = TextEditingController(text: widget.editing?.locationName ?? widget.initialLocation ?? '');
  late final _brand = TextEditingController(text: widget.editing?.brand ?? '');
  late final _model = TextEditingController(text: widget.editing?.model ?? '');
  late final _serialNo = TextEditingController(text: widget.editing?.serialNo ?? '');
  late final _price = TextEditingController(
      text: widget.editing?.purchasePrice == null ? '' : widget.editing!.purchasePrice!.toStringAsFixed(0));
  late final _store = TextEditingController(text: widget.editing?.store ?? '');
  late AssetCategory? _type = widget.preset;
  bool _typeTouched = false;

  /// Type name entered via the "Others" popup (custom, not in the catalog).
  late String? _customType =
      widget.editing != null && widget.editing!.categoryId == null ? widget.editing!.categoryName : null;
  late AssetCategoryKind _category =
      widget.editing?.category ?? widget.preset?.kindGroup ?? AssetCategoryKind.vehicle;
  late DateTime? _purchaseDate = widget.editing?.purchaseDate;
  DateTime? _amcDate;
  PickedMedia? _photo;
  final _invoices = <PickedMedia>[];
  bool _saving = false;

  /// Values for the type's [PropertySpec] fields, keyed by spec label.
  final _specValues = <String, TextEditingController>{};

  /// Free-form extra properties (label + value rows).
  final _extraProps = <(TextEditingController, TextEditingController)>[];

  bool get _isEdit => widget.editing != null;

  @override
  void initState() {
    super.initState();
    // Editing: split stored properties into spec fields vs free-form rows.
    final existing = widget.editing?.properties ?? const <String, String>{};
    if (existing.isNotEmpty) {
      final slug = _slugForEditing();
      final specLabels = propertySpecsFor(slug).map((s) => s.label).toSet();
      existing.forEach((k, v) {
        if (specLabels.contains(k)) {
          _specValues[k] = TextEditingController(text: v);
        } else {
          _extraProps.add((TextEditingController(text: k), TextEditingController(text: v)));
        }
      });
    }
  }

  /// Slug of the asset-being-edited's type: matched by built-in id, else by
  /// name (the DB seed mirrors [commonAssetCategories], so names line up).
  String? _slugForEditing() {
    final e = widget.editing;
    if (e == null) return null;
    final match = commonAssetCategories
        .where((c) => c.id == e.categoryId || (e.categoryName != null && c.name == e.categoryName))
        .firstOrNull;
    return match?.slug;
  }

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
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

  String? _text(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

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
        backgroundColor: AppColors.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Custom appliance type',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
          decoration: const InputDecoration(
            hintText: 'e.g. Dishwasher, Inverter, Camera…',
            hintStyle: TextStyle(color: AppColors.placeholder, fontWeight: FontWeight.w400),
          ),
          onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Use type', style: TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    setState(() {
      _customType = name;
      _type = null;
      _typeTouched = true;
    });
  }

  void _selectType(AssetCategory c) {
    setState(() {
      _type = c;
      _customType = null;
      _typeTouched = true;
      _category = c.kindGroup;
    });
  }

  Map<String, String> _collectProperties(String? slug) {
    final props = <String, String>{};
    for (final spec in propertySpecsFor(slug)) {
      final v = _specValues[spec.label]?.text.trim();
      if (v != null && v.isNotEmpty) props[spec.label] = v;
    }
    for (final (k, v) in _extraProps) {
      final key = k.text.trim();
      final value = v.text.trim();
      if (key.isNotEmpty && value.isNotEmpty) props[key] = value;
    }
    return props;
  }

  Future<void> _save(AssetCategory? type) async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a name.'), backgroundColor: AppColors.red));
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(catalogRepositoryProvider);
    // Fallback/custom types carry their name in typeName (no DB FK).
    final typeName = type != null
        ? (isDbCategoryId(type.id) ? null : type.name)
        : _customType;
    final properties = _collectProperties(type?.slug);
    final Asset asset;
    if (_isEdit) {
      asset = await repo.updateAsset(
        widget.editing!.id,
        name: _name.text,
        category: _category,
        categoryId: type?.id,
        typeName: typeName,
        locationName: _text(_location),
        brand: _text(_brand),
        model: _text(_model),
        serialNo: _text(_serialNo),
        purchaseDate: _purchaseDate,
        purchasePrice: double.tryParse(_price.text.trim().replaceAll(',', '')),
        store: _text(_store),
        properties: properties,
      );
    } else {
      asset = await repo.addAsset(
        name: _name.text,
        category: _category,
        categoryId: type?.id,
        typeName: typeName,
        locationName: _text(_location),
        brand: _text(_brand),
        model: _text(_model),
        serialNo: _text(_serialNo),
        purchaseDate: _purchaseDate,
        purchasePrice: double.tryParse(_price.text.trim().replaceAll(',', '')),
        store: _text(_store),
        properties: properties,
      );

      // Auto-seed the type's default services (AMC date overrides/creates AMC).
      try {
        await seedDefaultReminders(repo, asset, type, amcDate: _amcDate);
      } catch (_) {/* asset saved; reminders can be added manually */}
    }

    final photo = _photo;
    if (photo != null) {
      try {
        await repo.setAssetImage(asset.id,
            bytes: photo.bytes, fileName: photo.name, mimeType: photo.imageMime);
      } catch (_) {/* retry from asset detail */}
    }

    for (final invoice in _invoices) {
      try {
        await ref.read(documentRepositoryProvider).upload(
              assetId: asset.id,
              fileName: invoice.name,
              bytes: invoice.bytes,
              mimeType: invoice.docMime,
              kind: DocKind.invoice,
            );
      } catch (_) {/* attach later from the documents section */}
    }

    if (!mounted) return;
    refreshCatalog(ref);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).valueOrNull ?? commonAssetCategories;
    // Editing: resolve the asset's current type until the user changes it.
    final type = _typeTouched
        ? _type
        : _type ?? categories.where((c) => c.id == widget.editing?.categoryId).firstOrNull;
    final specs = propertySpecsFor(type?.slug);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: Text(
            _isEdit ? 'Edit asset' : (type == null ? 'Add asset' : 'Add ${type.name}'),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        children: [
          Center(child: _PhotoPicker(photo: _photo, existingRef: widget.editing?.imageUrl, onTap: _pickPhoto)),
          const SizedBox(height: 18),
          const Text('Select your appliance',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 8),
          _TypeGrid(
            categories: categories,
            selected: type,
            customType: _customType,
            onSelect: _selectType,
            onOthers: _askCustomType,
          ),
          const SizedBox(height: 18),
          const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in AssetCategoryKind.values)
                ChoiceChip(
                  selected: _category == c,
                  onSelected: (_) => setState(() {
                    _category = c;
                    _typeTouched = true;
                    if (_type != null && _type!.kindGroup != c) _type = null;
                  }),
                  avatar: Icon(c.icon, size: 18, color: _category == c ? Colors.white : AppColors.ink2),
                  label: Text(c.label),
                  labelStyle: TextStyle(fontWeight: FontWeight.w600, color: _category == c ? Colors.white : AppColors.ink),
                  selectedColor: AppColors.ink,
                  backgroundColor: AppColors.paper,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999), side: const BorderSide(color: AppColors.line)),
                ),
            ],
          ),
          const SizedBox(height: 18),
          AppTextField(label: 'Name', controller: _name, icon: Icons.label_outline, hint: 'e.g. Samsung 340L Fridge'),
          const SizedBox(height: 14),
          AppTextField(label: 'Location', controller: _location, icon: Icons.place_outlined, hint: 'e.g. Kitchen'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: AppTextField(label: 'Brand', controller: _brand, hint: 'optional')),
              const SizedBox(width: 12),
              Expanded(child: AppTextField(label: 'Model number', controller: _model, hint: 'optional')),
            ],
          ),
          const SizedBox(height: 14),
          AppTextField(label: 'Serial / registration no.', controller: _serialNo, icon: Icons.tag, hint: 'e.g. TN 01 AB 1234'),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _DateField(label: 'Purchase date', value: _purchaseDate, onTap: () => _pickDate(amc: false))),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  label: 'Purchase price',
                  controller: _price,
                  hint: 'e.g. 42000',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppTextField(label: 'Store', controller: _store, icon: Icons.storefront_outlined, hint: 'e.g. Croma'),

          // ── Type-specific properties ──
          if (specs.isNotEmpty || _extraProps.isNotEmpty || type != null || _customType != null) ...[
            const SizedBox(height: 20),
            Text(
                'Details for ${type?.name ?? _customType ?? 'this appliance'}'.toUpperCase(),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
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
                  Expanded(child: AppTextField(label: '', controller: _extraProps[i].$1, hint: 'e.g. Colour')),
                  const SizedBox(width: 10),
                  Expanded(child: AppTextField(label: '', controller: _extraProps[i].$2, hint: 'value')),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppColors.muted),
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
            TextButton.icon(
              onPressed: () => setState(
                  () => _extraProps.add((TextEditingController(), TextEditingController()))),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add property', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],

          if (!_isEdit) ...[
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _DateField(label: 'AMC date', value: _amcDate, onTap: () => _pickDate(amc: true))),
                const SizedBox(width: 12),
                Expanded(child: _InvoicePicker(invoices: _invoices, onTap: _pickInvoices)),
              ],
            ),
            if (type != null && type.defaults.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFEEF3FB), borderRadius: BorderRadius.circular(12)),
                child: Text(
                  'Will auto-add: ${type.defaults.map((d) => d.label).join(' · ')}',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.chipBlue),
                ),
              ),
            ],
          ],
          const SizedBox(height: 24),
          PrimaryButton(
              label: _isEdit ? 'Save changes' : 'Save asset',
              isLoading: _saving,
              onPressed: () => _save(type)),
        ],
      ),
    );
  }
}

/// The appliance-type picker: icon tiles for every catalog type plus an
/// "Others" tile that pops the custom-type input.
class _TypeGrid extends StatelessWidget {
  const _TypeGrid({
    required this.categories,
    required this.selected,
    required this.customType,
    required this.onSelect,
    required this.onOthers,
  });

  final List<AssetCategory> categories;
  final AssetCategory? selected;
  final String? customType;
  final ValueChanged<AssetCategory> onSelect;
  final VoidCallback onOthers;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final c in categories)
          _TypeChip(
            icon: c.icon,
            label: c.name,
            selected: selected?.id == c.id,
            onTap: () => onSelect(c),
          ),
        _TypeChip(
          icon: customType == null ? Icons.add_circle_outline : Icons.edit_outlined,
          label: customType ?? 'Others',
          selected: customType != null,
          onTap: onOthers,
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : AppColors.paper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.ink : AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? Colors.white : AppColors.ink2),
            const SizedBox(width: 7),
            Text(label,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.ink)),
          ],
        ),
      ),
    );
  }
}

/// Tappable photo box: the freshly picked image, the asset's existing photo
/// (edit mode), or an add-photo prompt. Tap → camera / gallery / files sheet.
class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.photo, required this.onTap, this.existingRef});
  final PickedMedia? photo;
  final String? existingRef;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final placeholder = const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, color: AppColors.muted, size: 26),
        SizedBox(height: 6),
        Text('Add photo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted)),
      ],
    );
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.fieldBorder, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: photo != null
            ? Image.memory(photo!.bytes, fit: BoxFit.cover)
            : AssetThumb(imageRef: existingRef, size: 96, radius: 18, fallback: placeholder),
      ),
    );
  }
}

/// Tappable invoice box styled like a field; supports multiple attachments.
class _InvoicePicker extends StatelessWidget {
  const _InvoicePicker({required this.invoices, required this.onTap});
  final List<PickedMedia> invoices;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = switch (invoices.length) {
      0 => 'invoice / receipt',
      1 => invoices.first.name,
      final n => '$n files attached',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Add invoice', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder, width: 1.5),
            ),
            child: Row(
              children: [
                Icon(invoices.isEmpty ? Icons.upload_file_outlined : Icons.check_circle_outline,
                    size: 18, color: invoices.isEmpty ? AppColors.muted : AppColors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: invoices.isEmpty ? FontWeight.w400 : FontWeight.w600,
                      color: invoices.isEmpty ? AppColors.placeholder : AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Tappable date field styled like [AppTextField].
class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.value, required this.onTap});
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_outlined, size: 18, color: AppColors.muted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value == null ? 'optional' : DateFormat('d MMM yyyy').format(value!),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: value == null ? FontWeight.w400 : FontWeight.w600,
                      color: value == null ? AppColors.placeholder : AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
