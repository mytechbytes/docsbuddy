import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/loader.dart';
import '../../../core/media/media_picker.dart';
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
import '../../../core/l10n/l10n.dart';
import 'widgets/catalog_widgets.dart';
import '../../../core/theme/app_theme.dart';

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
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.palette.text),
        title: const DbLogo(size: 18),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.notifications),
            icon: Icon(Icons.notifications_none, color: context.palette.textSecondary, size: 22),
          ),
          const ProfileAvatarButton(size: 30),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: context.palette.textSecondary, size: 22),
            onSelected: (v) {
              final a = asset.value;
              if (a == null) return;
              v == 'edit' ? _editAsset(context, ref, a) : _deleteAsset(context, ref, a);
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit', child: Text(context.l10n.catalogEditAsset)),
              PopupMenuItem(value: 'delete', child: Text(context.l10n.catalogDeleteAsset, style: TextStyle(color: context.palette.danger))),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: asset.when(
        loading: () => LoadingView(message: context.l10n.loadingAsset),
        error: (e, _) => Center(child: Text(context.failureText(e))),
        data: (a) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            AssetInfoCard(asset: a, reminderCount: list.length, onChangePhoto: () => _changePhoto(context, ref, a)),
            const SizedBox(height: 16),
            if (next != null) ...[
              NextDueBanner(reminder: next),
              const SizedBox(height: 20),
            ],
            // The title and the Add pill share a line; with large text the pill
            // wraps beneath instead of squeezing the title to a word a line.
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              children: [
                Text(context.l10n.catalogAllReminders(list.length),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
                AddPill(onTap: () => _addReminder(context, ref, a)),
              ],
            ),
            const SizedBox(height: 12),
            services.when(
              loading: () => LoadingView.section(message: context.l10n.loadingReminders),
              error: (e, _) => Text(context.failureText(e)),
              data: (s) => s.all.isEmpty
                  ? Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: Text(context.l10n.catalogNoRemindersForAsset, style: TextStyle(color: context.palette.textMuted))))
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

  Future<void> _changePhoto(BuildContext context, WidgetRef ref, Asset asset) async {
    final f = await pickImage(context);
    if (f == null || !context.mounted) return;
    await runAction(context, () => _actions(ref).setPhoto(f), loading: context.l10n.loadingUploadingPhoto);
  }

  Future<void> _complete(BuildContext context, WidgetRef ref, Reminder r) async {
    final confirmed = await _confirm(
      context,
      title: context.l10n.catalogMarkDoneTitle,
      message: r.isOneOff
          ? context.l10n.catalogMarkDoneOneOff(r.label)
          : context.l10n.catalogMarkDoneRecurring(r.label, r.recurrence.displayName(context).toLowerCase()),
      action: context.l10n.catalogMarkDone,
      color: context.palette.success,
    );
    if (!confirmed || !context.mounted) return;
    await runAction(
      context,
      () => _actions(ref).completeService(r),
      loading: context.l10n.loadingMarkingDone,
      success: r.isOneOff ? context.l10n.catalogMarkedDone(r.label) : context.l10n.catalogDoneRescheduled(r.label),
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
          title: context.l10n.catalogDeleteReminderTitle,
          message: context.l10n.catalogDeleteReminderMessage(r.label),
          action: context.l10n.commonDelete,
          color: context.palette.danger,
        );
        if (confirmed && context.mounted) {
          await runAction(context, () => _actions(ref).deleteService(r), loading: context.l10n.loadingDeletingReminder);
        }
    }
  }

  Future<void> _editAsset(BuildContext context, WidgetRef ref, Asset asset) async {
    await context.pushEditAsset(asset);
  }

  Future<void> _deleteAsset(BuildContext context, WidgetRef ref, Asset asset) async {
    final confirmed = await _confirm(
      context,
      title: context.l10n.catalogDeleteAssetTitle,
      message: context.l10n.catalogDeleteAssetMessage(asset.name),
      action: context.l10n.commonDelete,
      color: context.palette.danger,
    );
    if (!confirmed || !context.mounted) return;
    final ok = await runAction(context, () => _actions(ref).deleteAsset(), loading: context.l10n.loadingDeletingAsset);
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
        backgroundColor: context.palette.surface,
        title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(action, style: TextStyle(color: color, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    return confirmed == true;
  }
}
