import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';

/// Design screen 05 — "Select Your Appliances": searchable list of the
/// category catalog; picking one opens Add-asset pre-filled with that type
/// (and its default services are seeded on save).
class AppliancePickerPage extends ConsumerStatefulWidget {
  const AppliancePickerPage({super.key, this.locationName});

  /// Pre-fills the add-asset Location field (the room-detail "Add here" flow).
  final String? locationName;

  @override
  ConsumerState<AppliancePickerPage> createState() => _AppliancePickerPageState();
}

class _AppliancePickerPageState extends ConsumerState<AppliancePickerPage> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        actions: [
          IconButton(icon: const Icon(Icons.close, color: AppColors.ink), onPressed: () => context.pop()),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text('Select Your Appliance',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: AppColors.paper,
                hintText: 'Search Your Appliance',
                hintStyle: const TextStyle(color: AppColors.placeholder, fontWeight: FontWeight.w400),
                prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.muted),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.fieldBorder, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.chipBlue, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: categories.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e', style: const TextStyle(color: AppColors.muted))),
              data: (list) {
                final filtered =
                    _query.isEmpty ? list : list.where((c) => c.name.toLowerCase().contains(_query)).toList();
                if (filtered.isEmpty) {
                  return const Center(
                      child: Text('No matching appliance — use "Something else" below.',
                          style: TextStyle(color: AppColors.muted)));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  itemCount: filtered.length + 1,
                  itemBuilder: (context, i) => i < filtered.length
                      ? _CategoryTile(category: filtered[i], locationName: widget.locationName)
                      : _SomethingElseTile(locationName: widget.locationName),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String _assetNewPath(String? locationName) =>
    locationName == null || locationName.isEmpty
        ? '/asset-new'
        : '/asset-new?location=${Uri.encodeComponent(locationName)}';

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, this.locationName});
  final AssetCategory category;
  final String? locationName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.pushReplacement(_assetNewPath(locationName), extra: category),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration:
            BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
              child: Icon(category.icon, color: AppColors.ink2, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(category.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

/// Escape hatch for anything not in the catalog — plain add-asset flow.
class _SomethingElseTile extends StatelessWidget {
  const _SomethingElseTile({this.locationName});
  final String? locationName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.pushReplacement(_assetNewPath(locationName)),
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppColors.bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
        child: const Row(
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.chipBlue, size: 20),
            SizedBox(width: 12),
            Expanded(
                child: Text('Something else',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.chipBlue))),
          ],
        ),
      ),
    );
  }
}
