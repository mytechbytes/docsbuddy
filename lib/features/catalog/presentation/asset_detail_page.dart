import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/db_logo.dart';
import '../../../core/widgets/feedback.dart';
import '../../documents/presentation/asset_documents_section.dart';
import '../application/asset_actions.dart';
import '../application/catalog_providers.dart';
import '../domain/catalog_models.dart';
import 'service_detail_sheet.dart';
import '../../../routing/app_routes.dart';
import 'widgets/asset_detail_widgets.dart';
import '../../profile/presentation/widgets/profile_avatar_button.dart';

class AssetDetailPage extends ConsumerWidget {
  const AssetDetailPage({super.key, required this.assetId});
  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetProvider(assetId));
    final services = ref.watch(assetServicesProvider(assetId));
    final list = services.value?.all ?? const <Reminder>[];
    final next = services.value?.next;

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
            onPressed: () => context.push(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none, color: AppColors.ink2, size: 22),
          ),
          const ProfileAvatarButton(size: 30),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.ink2, size: 22),
            onSelected: (v) {
              final a = asset.value;
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
        error: (e, _) => Center(child: Text(failureMessage(e))),
        data: (a) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            AssetInfoCard(asset: a, reminderCount: list.length, onChangePhoto: () => _changePhoto(context, ref, a)),
            const SizedBox(height: 16),
            if (next != null) ...[
              NextDueBanner(reminder: next),
              const SizedBox(height: 20),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Reminders · ${list.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                AddPill(onTap: () => _addReminder(context, ref, a)),
              ],
            ),
            const SizedBox(height: 12),
            services.when(
              loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Text(failureMessage(e)),
              data: (s) => s.all.isEmpty
                  ? const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: Text('No reminders for this asset yet.', style: TextStyle(color: AppColors.muted))))
                  : Column(children: [
                      for (final r in s.all)
                        ServiceRow(
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

  AssetActions _actions(WidgetRef ref) => ref.read(assetActionsProvider(assetId));

  /// Picks an image and uploads it as the asset's photo.
  Future<void> _changePhoto(BuildContext context, WidgetRef ref, Asset asset) async {
    final f = await pickImage(context);
    if (f == null || !context.mounted) return;
    await runAction(context, () => _actions(ref).setPhoto(f));
  }

  /// Marks a service done — recurring ones roll their due date forward.
  Future<void> _complete(BuildContext context, WidgetRef ref, Reminder r) async {
    final confirmed = await _confirm(
      context,
      title: 'Mark as done?',
      message: r.isOneOff
          ? '“${r.label}” will be completed and removed from upcoming reminders.'
          : '“${r.label}” will be completed and its next due date scheduled (${r.recurrence.label.toLowerCase()}).',
      action: 'Mark done',
      color: AppColors.green,
    );
    if (!confirmed || !context.mounted) return;
    await runAction(
      context,
      () => _actions(ref).completeService(r),
      success: r.isOneOff ? '${r.label} marked as done.' : '${r.label} done — next due date scheduled.',
    );
  }

  Future<void> _addReminder(BuildContext context, WidgetRef ref, Asset asset) async {
    await context.pushAddReminder(asset.id);
  }

  Future<void> _openService(BuildContext context, WidgetRef ref, Reminder r) async {
    final action = await ServiceDetailSheet.show(context, r);
    if (action != null && context.mounted) {
      await _handleServiceAction(context, ref, r, action);
    }
  }

  Future<void> _handleServiceAction(BuildContext context, WidgetRef ref, Reminder r, ServiceAction action) async {
    switch (action) {
      case ServiceAction.edit:
        await context.pushEditReminder(r);
      case ServiceAction.complete:
        await _complete(context, ref, r);
      case ServiceAction.delete:
        final confirmed = await _confirm(
          context,
          title: 'Delete reminder?',
          message: '“${r.label}” and its scheduled notifications will be removed.',
          action: 'Delete',
          color: AppColors.red,
        );
        if (confirmed && context.mounted) await runAction(context, () => _actions(ref).deleteService(r));
    }
  }

  Future<void> _editAsset(BuildContext context, WidgetRef ref, Asset asset) async {
    await context.pushEditAsset(asset);
  }

  Future<void> _deleteAsset(BuildContext context, WidgetRef ref, Asset asset) async {
    final confirmed = await _confirm(
      context,
      title: 'Delete asset?',
      message: '“${asset.name}” and all its reminders and documents will be removed. This can\'t be undone.',
      action: 'Delete',
      color: AppColors.red,
    );
    if (!confirmed || !context.mounted) return;
    final ok = await runAction(context, () => _actions(ref).deleteAsset());
    if (ok && context.mounted) Navigator.of(context).pop();
  }

  static Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String action,
    required Color color,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paper,
        title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(action, style: TextStyle(color: color, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    return confirmed == true;
  }
}
