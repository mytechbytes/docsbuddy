import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../../../core/widgets/db_logo.dart';
import '../../documents/presentation/asset_documents_section.dart';
import '../../profile/application/profile_providers.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';
import 'service_detail_sheet.dart';

class AssetDetailPage extends ConsumerWidget {
  const AssetDetailPage({super.key, required this.assetId});
  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetProvider(assetId));
    final reminders = ref.watch(assetRemindersProvider(assetId));
    final list = reminders.valueOrNull ?? const <Reminder>[];
    final next = _soonest(list);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const DbLogo(size: 18),
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_none, color: AppColors.ink2, size: 22),
          ),
          const _Avatar(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.ink2, size: 22),
            onSelected: (v) {
              final a = asset.valueOrNull;
              if (a == null) return;
              v == 'edit' ? _editAsset(context, ref, a) : _deleteAsset(context, ref, a);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit asset')),
              PopupMenuItem(value: 'delete', child: Text('Delete asset', style: TextStyle(color: AppColors.red))),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: asset.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (a) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            _InfoCard(asset: a, reminderCount: list.length, onChangePhoto: () => _changePhoto(context, ref, a)),
            const SizedBox(height: 16),
            if (next != null) ...[
              _NextDueBanner(reminder: next),
              const SizedBox(height: 20),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Reminders · ${list.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                _AddPill(onTap: () => _addReminder(context, ref, a)),
              ],
            ),
            const SizedBox(height: 12),
            reminders.when(
              loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Text('$e'),
              data: (rs) => rs.isEmpty
                  ? const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: Text('No reminders for this asset yet.', style: TextStyle(color: AppColors.muted))))
                  : Column(children: [
                      for (final r in rs)
                        _ReminderRow(
                          reminder: r,
                          onTap: () => _openService(context, ref, r),
                          onAction: (action) => _handleServiceAction(context, ref, r, action),
                        ),
                    ]),
            ),
            const SizedBox(height: 22),
            AssetDocumentsSection(assetId: a.id),
          ],
        ),
      ),
    );
  }

  /// The most urgent reminder (smallest days-left, overdue first).
  static Reminder? _soonest(List<Reminder> list) {
    if (list.isEmpty) return null;
    final sorted = [...list]..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
    return sorted.first;
  }

  /// Picks an image and uploads it as the asset's photo.
  Future<void> _changePhoto(BuildContext context, WidgetRef ref, Asset asset) async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    final f = res?.files.firstOrNull;
    final bytes = f?.bytes;
    if (f == null || bytes == null) return;
    try {
      await ref.read(catalogRepositoryProvider).setAssetImage(
            asset.id,
            bytes: bytes,
            fileName: f.name,
            mimeType: _imageMime(f.extension),
          );
      ref.invalidate(assetProvider(assetId));
      refreshCatalog(ref);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Photo upload failed: $e'), backgroundColor: AppColors.red));
      }
    }
  }

  static String _imageMime(String? ext) => switch (ext?.toLowerCase()) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        'gif' => 'image/gif',
        _ => 'image/jpeg',
      };

  /// Marks a service done — recurring ones roll their due date forward.
  Future<void> _complete(BuildContext context, WidgetRef ref, Reminder r) async {
    await ref.read(catalogRepositoryProvider).completeReminder(r.id);
    ref.invalidate(assetRemindersProvider(assetId));
    refreshCatalog(ref);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(r.recurrence == Recurrence.none
            ? '${r.label} marked as done.'
            : '${r.label} done — next due date scheduled.'),
        backgroundColor: AppColors.green,
      ));
    }
  }

  Future<void> _addReminder(BuildContext context, WidgetRef ref, Asset asset) async {
    await context.push('/asset/${asset.id}/add-reminder');
    ref.invalidate(assetRemindersProvider(assetId));
    refreshCatalog(ref);
  }

  Future<void> _openService(BuildContext context, WidgetRef ref, Reminder r) async {
    final action = await ServiceDetailSheet.show(context, r);
    if (action != null && context.mounted) {
      await _handleServiceAction(context, ref, r, action);
    }
  }

  Future<void> _handleServiceAction(
      BuildContext context, WidgetRef ref, Reminder r, ServiceAction action) async {
    switch (action) {
      case ServiceAction.edit:
        await context.push('/asset/$assetId/add-reminder', extra: r);
        ref.invalidate(assetRemindersProvider(assetId));
        refreshCatalog(ref);
      case ServiceAction.complete:
        await _complete(context, ref, r);
      case ServiceAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.paper,
            title: const Text('Delete reminder?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            content: Text('“${r.label}” and its scheduled notifications will be removed.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700))),
            ],
          ),
        );
        if (confirmed != true) return;
        await ref.read(catalogRepositoryProvider).deleteReminder(r.id);
        ref.invalidate(assetRemindersProvider(assetId));
        refreshCatalog(ref);
    }
  }

  Future<void> _editAsset(BuildContext context, WidgetRef ref, Asset asset) async {
    await context.push('/asset-edit', extra: asset);
    ref.invalidate(assetProvider(assetId));
    refreshCatalog(ref);
  }

  Future<void> _deleteAsset(BuildContext context, WidgetRef ref, Asset asset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paper,
        title: const Text('Delete asset?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: Text('“${asset.name}” and all its reminders and documents will be removed. This can\'t be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(catalogRepositoryProvider).deleteAsset(asset.id);
    refreshCatalog(ref);
    if (context.mounted) Navigator.of(context).pop();
  }
}

/// Real `users.avatar_url`; tap opens Profile.
class _Avatar extends ConsumerWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).valueOrNull;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => context.push('/profile'),
      child: AssetThumb(
        imageRef: profile?.avatarUrl,
        size: 30,
        radius: 15,
        fallback: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Color(0xFFF1C27D), Color(0xFFD68B5C)]),
          ),
          alignment: Alignment.center,
          child: profile == null
              ? const Icon(Icons.person, color: Colors.white, size: 17)
              : Text(profile.initial,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      ),
    );
  }
}

class _AddPill extends StatelessWidget {
  const _AddPill({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(999)),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: Colors.white),
            SizedBox(width: 4),
            Text('Add', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.asset, required this.reminderCount, required this.onChangePhoto});
  final Asset asset;
  final int reminderCount;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    final meta = [
      '$reminderCount reminder${reminderCount == 1 ? '' : 's'} tracked',
      if (asset.brand != null) asset.brand,
      if (asset.model != null) asset.model,
      if (asset.serialNo != null) asset.serialNo,
    ].whereType<String>().join(' · ');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onChangePhoto,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AssetThumb(
                  imageRef: asset.imageUrl,
                  size: 64,
                  radius: 16,
                  fallback: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(16)),
                    child: Icon(asset.category.icon, color: AppColors.ink2, size: 30),
                  ),
                ),
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.paper, width: 2),
                    ),
                    child: const Icon(Icons.photo_camera_outlined, size: 11, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink, height: 1.2)),
                const SizedBox(height: 6),
                Align(alignment: Alignment.centerLeft, child: CategoryChip(asset.typeLabel)),
                const SizedBox(height: 8),
                Text(meta, style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Red "next due" banner highlighting the most urgent reminder.
class _NextDueBanner extends StatelessWidget {
  const _NextDueBanner({required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final d = reminder.daysLeft;
    final phrase = d < 0
        ? 'Overdue by ${-d} day${d == -1 ? '' : 's'}'
        : d == 0
            ? 'Due today'
            : '$d day${d == 1 ? '' : 's'} left';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NEXT DUE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Text('${reminder.label} · $phrase',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(DateFormat('d MMM yyyy').format(reminder.dueDate),
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 4),
              Text('Reminds ${reminder.offsetsLabel}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({required this.reminder, required this.onTap, required this.onAction});
  final Reminder reminder;
  final VoidCallback onTap;
  final ValueChanged<ServiceAction> onAction;

  @override
  Widget build(BuildContext context) {
    final service = [
      if (reminder.provider != null) reminder.provider,
      if (reminder.policyNo != null) reminder.policyNo,
    ].whereType<String>().join(' · ');
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: Row(
        children: [
          IconBubble(kind: reminder.kind, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(DateFormat('d MMM yyyy').format(reminder.dueDate), style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                    const SizedBox(width: 8),
                    const Icon(Icons.notifications_none, size: 13, color: AppColors.muted),
                    const SizedBox(width: 3),
                    Text(reminder.offsetsLabel, style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                  ],
                ),
                if (service.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(service, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          DayPill(daysLeft: reminder.daysLeft),
          PopupMenuButton<ServiceAction>(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_vert, size: 18, color: AppColors.muted),
            onSelected: onAction,
            itemBuilder: (_) => const [
              PopupMenuItem(value: ServiceAction.complete, child: Text('Mark as done')),
              PopupMenuItem(value: ServiceAction.edit, child: Text('Edit')),
              PopupMenuItem(
                  value: ServiceAction.delete,
                  child: Text('Delete', style: TextStyle(color: AppColors.red))),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

