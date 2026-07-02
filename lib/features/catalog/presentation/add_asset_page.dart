import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';

class AddAssetPage extends ConsumerStatefulWidget {
  const AddAssetPage({super.key});

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
  AssetCategoryKind _category = AssetCategoryKind.vehicle;
  DateTime? _purchaseDate;
  PlatformFile? _photo;
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

  static String _imageMime(String? ext) => switch (ext?.toLowerCase()) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        'gif' => 'image/gif',
        _ => 'image/jpeg',
      };

  Future<void> _pickPurchaseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
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
          locationName: _text(_location),
          brand: _text(_brand),
          model: _text(_model),
          serialNo: _text(_serialNo),
          purchaseDate: _purchaseDate,
          purchasePrice: double.tryParse(_price.text.trim().replaceAll(',', '')),
          store: _text(_store),
        );
    final photo = _photo;
    if (photo?.bytes != null) {
      try {
        await repo.setAssetImage(asset.id,
            bytes: photo!.bytes!, fileName: photo.name, mimeType: _imageMime(photo.extension));
      } catch (_) {
        // Asset is saved; a failed photo upload shouldn't block the flow —
        // it can be retried from the asset-detail header.
      }
    }
    if (!mounted) return;
    refreshCatalog(ref);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const Text('Add asset', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        children: [
          Center(child: _PhotoPicker(photo: _photo, onTap: _pickPhoto)),
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
                  onSelected: (_) => setState(() => _category = c),
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
              Expanded(
                child: _DateField(
                  label: 'Purchase date',
                  value: _purchaseDate,
                  onTap: _pickPurchaseDate,
                ),
              ),
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
          const SizedBox(height: 24),
          PrimaryButton(label: 'Save asset', isLoading: _saving, onPressed: _save),
        ],
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
