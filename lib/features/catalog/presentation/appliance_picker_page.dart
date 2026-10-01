import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/feedback.dart';
import '../application/catalog_providers.dart';
import '../domain/catalog_models.dart';
import 'widgets/catalog_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

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
    final categories = ref.watch(filteredCategoriesProvider(_query));
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.palette.text),
        title: Text(context.l10n.catalogSelectYourAppliance, style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
        actions: [
          IconButton(icon: Icon(Icons.close, color: context.palette.text), onPressed: () => context.pop()),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.palette.text),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: context.palette.surface,
                hintText: context.l10n.catalogSearchAppliance,
                hintStyle: TextStyle(color: context.palette.placeholder, fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.search, size: 18, color: context.palette.textMuted),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.palette.fieldBorder, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.palette.accent, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: categories.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(context.failureText(e), style: TextStyle(color: context.palette.textMuted))),
              data: (filtered) {
                if (filtered.isEmpty) {
                  return Center(
                      child: Text(context.l10n.catalogNoMatchingAppliance,
                          style: TextStyle(color: context.palette.textMuted)));
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


class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, this.locationName});
  final AssetCategory category;
  final String? locationName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.replaceWithNewAsset(preset: category, location: locationName),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration:
            BoxDecoration(color: context.palette.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.palette.border)),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: context.palette.background, borderRadius: BorderRadius.circular(12)),
              child: Icon(category.icon, color: context.palette.textSecondary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(category.name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.palette.text)),
            ),
            Icon(Icons.chevron_right, color: context.palette.textMuted),
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
      onTap: () => context.replaceWithNewAsset(location: locationName),
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: context.palette.background, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.palette.border)),
        child: Row(
          children: [
            Icon(Icons.add_circle_outline, color: context.palette.accent, size: 20),
            SizedBox(width: 12),
            Expanded(
                child: Text(context.l10n.catalogSomethingElse,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.palette.accent))),
          ],
        ),
      ),
    );
  }
}
