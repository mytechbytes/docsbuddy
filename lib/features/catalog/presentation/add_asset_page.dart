import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../documents/application/document_providers.dart';
import '../../documents/data/document_models.dart';
import '../application/catalog_providers.dart';
import '../application/default_reminders.dart';
import '../data/catalog_models.dart';

class AddAssetPage extends ConsumerStatefulWidget {
  const AddAssetPage({super.key, this.preset});

  /// Pre-selected type from the appliance picker (screen 05).
  final AssetCategory? preset;

  @override
  ConsumerState<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends ConsumerState<AddAssetPage> {
  final _name = TextEditingController();
  final _location = TextEditingController();
  final _brand = TextEditingController();
  final _model = TextEditingController();
  final _serialNo = TextEditingController();
  final _price = TextEditingController();
  final _store = TextEditingController();
  late AssetCategory? _type = widget.preset;
  late AssetCategoryKind _category = widget.preset?.kindGroup ?? AssetCategoryKind.vehicle;
  DateTime? _purchaseDate;
  DateTime? _amcDate;
  PlatformFile? _photo;
  PlatformFile? _invoice;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    _brand.dispose();
    _model.dispose();
    _serialNo.dispose();
    _price.dispose();
    _store.dispose();
    super.dispose();
  }

  String? _text(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _pickPhoto() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    final f = res?.files.firstOrNull;
    if (f?.bytes != null) setState(() => _photo = f);
  }

  Future<void> _pickInvoice() async {
    final res = await FilePicker.platform.pickFiles(withData: true);
    final f = res?.files.firstOrNull;
    if (f?.bytes != null) setState(() => _invoice = f);
  }

  static String _imageMime(String? ext) => switch (ext?.toLowerCase()) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        'gif' => 'image/gif',
        _ => 'image/jpeg',
      };

  static String _docMime(String? ext) => switch (ext?.toLowerCase()) {
        'pdf' => 'application/pdf',
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        _ => 'application/octet-stream',
      };

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

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a name.'), backgroundColor: AppColors.red));
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(catalogRepositoryProvider);
    final asset = await repo.addAsset(
      name: _name.text,
      category: _category,
      categoryId: _type?.id,
      locationName: _text(_location),
      brand: _text(_brand),
      model: _text(_model),
      serialNo: _text(_serialNo),
      purchaseDate: _purchaseDate,
      purchasePrice: double.tryParse(_price.text.trim().replaceAll(',', '')),
      store: _text(_store),
    );

    // Auto-seed the type's default services (AMC date overrides/creates AMC).
    try {
      await seedDefaultReminders(repo, asset, _type, amcDate: _amcDate);
    } catch (_) {/* asset saved; reminders can be added manually */}

    final photo = _photo;
    if (photo?.bytes != null) {
      try {
        await repo.setAssetImage(asset.id,
            bytes: photo!.bytes!, fileName: photo.name, mimeType: _imageMime(photo.extension));
      } catch (_) {/* retry from asset detail */}
    }

    final invoice = _invoice;
    if (invoice?.bytes != null) {
      try {
        await ref.read(documentRepositoryProvider).upload(
              assetId: asset.id,
              fileName: invoice!.name,
              bytes: invoice.bytes!,
              mimeType: _docMime(invoice.extension),
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
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const <AssetCategory>[];
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: Text(_type == null ? 'Add asset' : 'Add ${_type!.name}',
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        children: [
          Center(child: _PhotoPicker(photo: _photo, onTap: _pickPhoto)),
          const SizedBox(height: 18),
          if (categories.isNotEmpty) ...[
            const Text('Appliance type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 6),
            _TypeDropdown(
              categories: categories,
              value: _type,
              onChanged: (c) => setState(() {
                _type = c;
                if (c != null) _category = c.kindGroup;
              }),
            ),
            const SizedBox(height: 14),
          ],
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
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _DateField(label: 'AMC date', value: _amcDate, onTap: () => _pickDate(amc: true))),
              const SizedBox(width: 12),
              Expanded(child: _InvoicePicker(invoice: _invoice, onTap: _pickInvoice)),
            ],
          ),
          if (_type != null && _type!.defaults.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFEEF3FB), borderRadius: BorderRadius.circular(12)),
              child: Text(
                'Will auto-add: ${_type!.defaults.map((d) => d.label).join(' · ')}',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.chipBlue),
              ),
            ),
          ],
          const SizedBox(height: 24),
          PrimaryButton(label: 'Save asset', isLoading: _saving, onPressed: _save),
        ],
      ),
    );
  }
}

/// Dropdown over the category catalog, matched by id so instances from the
/// picker route and the provider interchange safely.
class _TypeDropdown extends StatelessWidget {
  const _TypeDropdown({required this.categories, required this.value, required this.onChanged});
  final List<AssetCategory> categories;
  final AssetCategory? value;
  final ValueChanged<AssetCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = categories.where((c) => c.id == value?.id).firstOrNull;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder, width: 1.5),
      ),
      child: DropdownButton<AssetCategory?>(
        value: selected,
        isExpanded: true,
        underline: const SizedBox(),
        hint: const Text('Search Your Appliance', style: TextStyle(fontSize: 14, color: AppColors.placeholder)),
        items: [
          const DropdownMenuItem<AssetCategory?>(value: null, child: Text('Other / not listed')),
          for (final c in categories)
            DropdownMenuItem<AssetCategory?>(
              value: c,
              child: Row(
                children: [
                  Icon(c.icon, size: 18, color: AppColors.ink2),
                  const SizedBox(width: 8),
                  Text(c.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                ],
              ),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

/// Tappable photo box: preview of the picked image, or an add-photo prompt.
class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.photo, required this.onTap});
  final PlatformFile? photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bytes = photo?.bytes;
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
        child: bytes != null
            ? Image.memory(bytes, fit: BoxFit.cover)
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: AppColors.muted, size: 26),
                  SizedBox(height: 6),
                  Text('Add photo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted)),
                ],
              ),
      ),
    );
  }
}

/// Tappable invoice box styled like a field: file name once picked.
class _InvoicePicker extends StatelessWidget {
  const _InvoicePicker({required this.invoice, required this.onTap});
  final PlatformFile? invoice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                Icon(invoice == null ? Icons.upload_file_outlined : Icons.check_circle_outline,
                    size: 18, color: invoice == null ? AppColors.muted : AppColors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    invoice?.name ?? 'invoice / receipt',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: invoice == null ? FontWeight.w400 : FontWeight.w600,
                      color: invoice == null ? AppColors.placeholder : AppColors.ink,
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
