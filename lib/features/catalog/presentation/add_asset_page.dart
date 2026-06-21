import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  AssetCategoryKind _category = AssetCategoryKind.vehicle;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    _brand.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a name.'), backgroundColor: AppColors.red));
      return;
    }
    setState(() => _saving = true);
    await ref.read(catalogRepositoryProvider).addAsset(
          name: _name.text,
          category: _category,
          locationName: _location.text.trim().isEmpty ? null : _location.text.trim(),
          brand: _brand.text.trim().isEmpty ? null : _brand.text.trim(),
        );
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
          AppTextField(label: 'Brand', controller: _brand, icon: Icons.business_outlined, hint: 'optional'),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Save asset', isLoading: _saving, onPressed: _save),
        ],
      ),
    );
  }
}
