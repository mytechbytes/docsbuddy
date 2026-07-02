import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';

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

  bool _matchesAsset(Asset a, String q) => [
        a.name,
        a.brand ?? '',
        a.model ?? '',
        a.serialNo ?? '',
        a.typeLabel,
        a.locationName ?? '',
      ].any((s) => s.toLowerCase().contains(q));

  bool _matchesReminder(Reminder r, String q) => [
        r.label,
        r.assetName,
        r.provider ?? '',
        r.policyNo ?? '',
      ].any((s) => s.toLowerCase().contains(q));

  @override
  Widget build(BuildContext context) {
    final assets = ref.watch(assetsProvider).valueOrNull ?? const <Asset>[];
    final reminders = ref.watch(upcomingRemindersProvider).valueOrNull ?? const <Reminder>[];
    final q = _query.toLowerCase();
    final assetHits = q.isEmpty ? const <Asset>[] : assets.where((a) => _matchesAsset(a, q)).toList();
    final reminderHits = q.isEmpty ? const <Reminder>[] : reminders.where((r) => _matchesReminder(r, q)).toList();

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
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search assets, services, policy numbers…',
              hintStyle: TextStyle(color: AppColors.placeholder, fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ),
        ),
      ),
      body: q.isEmpty
          ? const Center(
              child: Text('Type to search your assets and reminders.', style: TextStyle(color: AppColors.muted)))
          : (assetHits.isEmpty && reminderHits.isEmpty)
              ? const Center(child: Text('No matches.', style: TextStyle(color: AppColors.muted)))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    if (assetHits.isNotEmpty) ...[
                      const _SectionLabel('Assets'),
                      for (final a in assetHits) _AssetHit(asset: a),
                    ],
                    if (reminderHits.isNotEmpty) ...[
                      const _SectionLabel('Reminders'),
                      for (final r in reminderHits) _ReminderHit(reminder: r),
                    ],
                  ],
                ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Text(text.toUpperCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
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
      onTap: () => context.push('/asset/${asset.id}'),
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
      onTap: () => context.push('/asset/${reminder.assetId}'),
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
                  Text(DateFormat('d MMM yyyy').format(reminder.dueDate),
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
