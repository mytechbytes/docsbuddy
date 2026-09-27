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

class AssetsPage extends ConsumerStatefulWidget {
  const AssetsPage({super.key});

  @override
  ConsumerState<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends ConsumerState<AssetsPage> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assets = ref.watch(filteredAssetsProvider(_query));

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        title: Text(context.l10n.navAssets, style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.palette.inverseSurface,
        onPressed: () => context.push(AppRoutes.appliancePicker()),
        icon: Icon(Icons.add, color: context.palette.onInverse),
        label: Text(context.l10n.catalogAddAsset, style: TextStyle(color: context.palette.onInverse, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
            child: TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v.trim()),
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
          Expanded(
            child: assets.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(context.failureText(e))),
              data: (visible) {
                if (visible.isEmpty) {
                  return Center(
                      child: Text(_query.isEmpty ? context.l10n.catalogNoAssets : context.l10n.commonNoMatches,
                          style: TextStyle(color: context.palette.textMuted)));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                  itemCount: visible.length,
                  itemBuilder: (context, i) => _AssetTile(asset: visible[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({required this.asset});
  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push(AppRoutes.asset(asset.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: context.palette.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.palette.border)),
        child: Row(
          children: [
            AssetThumb(
              imageRef: asset.imageUrl,
              size: 44,
              radius: 12,
              fallback: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: context.palette.background, borderRadius: BorderRadius.circular(12)),
                child: Icon(asset.category.icon, color: context.palette.textSecondary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.palette.text)),
                  const SizedBox(height: 2),
                  Text(asset.subtitle, style: TextStyle(fontSize: 12, color: context.palette.textMuted)),
                ],
              ),
            ),
            CategoryChip(asset.typeName(context)),
            Icon(Icons.chevron_right, color: context.palette.textMuted),
          ],
        ),
      ),
    );
  }
}
