import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../application/catalog_providers.dart';
import '../domain/catalog_models.dart';
import 'widgets/catalog_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/widgets/settings_list.dart';
import '../../../core/l10n/l10n.dart';

/// Search across assets (name/brand/model/serial) and services (label,
/// provider, policy no.) — wires the dashboard's search icon.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query;
    final hits = ref.watch(catalogSearchProvider(q));
    final assetHits = hits.assets;
    final reminderHits = hits.reminders;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: _search,
            autofocus: true,
            onChanged: (v) => setState(() => _query = v.trim()),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: context.l10n.catalogSearchHint,
              hintStyle: TextStyle(color: AppColors.placeholder, fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ),
        ),
      ),
      body: q.isEmpty
          ? Center(
              child: Text(context.l10n.catalogSearchEmpty, style: const TextStyle(color: AppColors.muted)))
          : (assetHits.isEmpty && reminderHits.isEmpty)
              ? Center(child: Text(context.l10n.commonNoMatches, style: const TextStyle(color: AppColors.muted)))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    if (assetHits.isNotEmpty) ...[
                      SectionLabel(context.l10n.navAssets),
                      for (final a in assetHits) _AssetHit(asset: a),
                    ],
                    if (reminderHits.isNotEmpty) ...[
                      SectionLabel(context.l10n.catalogReminders),
                      for (final r in reminderHits) _ReminderHit(reminder: r),
                    ],
                  ],
                ),
    );
  }
}


class _AssetHit extends StatelessWidget {
  const _AssetHit({required this.asset});
  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push(AppRoutes.asset(asset.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppColors.paper, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            AssetThumb(
              imageRef: asset.imageUrl,
              size: 40,
              radius: 12,
              fallback: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
                child: Icon(asset.category.icon, size: 20, color: AppColors.ink2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  Text(asset.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class _ReminderHit extends StatelessWidget {
  const _ReminderHit({required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push(AppRoutes.asset(reminder.assetId)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppColors.paper, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            IconBubble(kind: reminder.kind, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${reminder.assetName} — ${reminder.label}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  Text(context.formatDate(reminder.dueDate),
                      style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                ],
              ),
            ),
            DayPill(daysLeft: reminder.daysLeft),
          ],
        ),
      ),
    );
  }
}
