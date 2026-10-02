import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/widgets/adaptive_layout.dart';
import '../../../core/widgets/feedback.dart';
import '../application/catalog_providers.dart';
import '../application/rooms_controller.dart';
import '../domain/catalog_models.dart';
import 'widgets/catalog_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

/// Design screen 03 — Room detail: hero photo (tap to change), editable name,
/// summary line, and the appliances registered in the room.
class RoomDetailPage extends ConsumerWidget {
  const RoomDetailPage({super.key, required this.locationId});
  final String locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(roomDetailProvider(locationId));

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.palette.text),
      ),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.failureText(e))),
        data: (d) {
          if (d == null) {
            return Center(child: Text(context.l10n.catalogRoomNotFound, style: TextStyle(color: context.palette.textMuted)));
          }
          final room = d.room;
          final inRoom = d.appliances;
          return RefreshIndicator(
            onRefresh: () async {
              ref.read(catalogRefresherProvider).all();
              await ref.read(roomDetailProvider(locationId).future);
            },
            child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _changePhoto(context, ref, room),
                child: AssetThumb(
                  imageRef: room.imageUrl,
                  width: double.infinity,
                  height: 150,
                  radius: 18,
                  fallback: Container(
                    width: double.infinity,
                    height: 150,
                    decoration:
                        BoxDecoration(color: context.palette.accentSoft, borderRadius: BorderRadius.circular(18)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 30, color: context.palette.accent),
                        SizedBox(height: 6),
                        Text(context.l10n.catalogAddRoomPhoto,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.palette.accent)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(room.name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: context.palette.text)),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_outlined, size: 20, color: context.palette.textSecondary),
                    onPressed: () => _rename(context, ref, room),
                  ),
                ],
              ),
              Text.rich(
                TextSpan(
                  text: context.l10n.catalogRoomSummaryLead,
                  children: [
                    TextSpan(
                        text: context.l10n.catalogApplianceCount(inRoom.length),
                        style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
                    const TextSpan(text: '.'),
                  ],
                ),
                style: TextStyle(fontSize: 13.5, color: context.palette.textMuted),
              ),
              const SizedBox(height: 18),
              Text(context.l10n.catalogAppliances,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
              const SizedBox(height: 10),
              if (inRoom.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                      child: Text(context.l10n.catalogNothingRegistered, style: TextStyle(color: context.palette.textMuted))),
                )
              else
                for (final a in inRoom) _ApplianceGroupCard(asset: a.asset, reminders: a.reminders),
            ],
          ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.palette.accent,
        onPressed: () {
          final room = ref.read(roomDetailProvider(locationId)).value?.room;
          context.push(AppRoutes.appliancePicker(location: room?.name));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(context.l10n.catalogAddHere, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Future<void> _rename(BuildContext context, WidgetRef ref, Location room) async {
    final controller = TextEditingController(text: room.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.palette.surface,
        title: Text(context.l10n.catalogRenameRoom, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: Text(context.l10n.commonSave, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
    controller.dispose();
    if (name == null || !context.mounted) return;
    await runAction(context, () => ref.read(locationsProvider.notifier).rename(room, name));
  }

  Future<void> _changePhoto(BuildContext context, WidgetRef ref, Location room) async {
    final f = await pickImage(context);
    if (f == null || !context.mounted) return;
    await runAction(context, () => ref.read(locationsProvider.notifier).setPhoto(room, f));
  }
}

/// Dashboard-style card: appliance header with full details, then every
/// service/reminder on the appliance with its own day pill.
class _ApplianceGroupCard extends StatelessWidget {
  const _ApplianceGroupCard({required this.asset, required this.reminders});
  final Asset asset;
  final List<Reminder> reminders;

  @override
  Widget build(BuildContext context) {
    final detailLine = [
      asset.typeName(context),
      if (asset.brand != null) asset.brand!,
      if (asset.model != null) asset.model!,
    ].join(' · ');
    final extraLine = [
      if (asset.serialNo != null) asset.serialNo!,
      if (asset.purchaseDate != null) context.l10n.catalogSince(context.formatMonthYear(asset.purchaseDate!)),
      ...asset.properties.entries.map((e) => '${e.key} ${e.value}'),
    ].join(' · ');
    final thumb = AssetThumb(
      imageRef: asset.imageUrl,
      size: 52,
      fallback: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(color: context.palette.accentSoft, borderRadius: BorderRadius.circular(14)),
        child: Icon(asset.category.icon, size: 24, color: context.palette.accent),
      ),
    );
    Widget details(bool wrap) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(asset.name,
                maxLines: wrap ? null : 1,
                overflow: wrap ? null : TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.palette.text, height: 1.15)),
            const SizedBox(height: 3),
            Text(detailLine,
                maxLines: wrap ? null : 1,
                overflow: wrap ? null : TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
            if (extraLine.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(extraLine,
                  maxLines: wrap ? null : 1,
                  overflow: wrap ? null : TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: context.palette.textMuted)),
            ],
          ],
        );
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: context.palette.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.palette.border)),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            onTap: () => context.push(AppRoutes.asset(asset.id)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: reminders.isNotEmpty
                  ? BadgedTile(leading: thumb, badge: DayPill(daysLeft: reminders.first.daysLeft), body: details)
                  : Row(
                      children: [
                        thumb,
                        const SizedBox(width: 12),
                        Expanded(child: details(context.largeText)),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right, size: 18, color: context.palette.textMuted),
                      ],
                    ),
            ),
          ),
          if (reminders.isNotEmpty) ...[
            Divider(height: 1, color: context.palette.border),
            for (final r in reminders)
              InkWell(
                onTap: () => context.push(AppRoutes.asset(r.assetId)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: BadgedTile(
                    gap: 10,
                    badgeGap: 0,
                    leading: IconBubble(kind: r.kind, size: 34),
                    badge: DayPill(daysLeft: r.daysLeft),
                    body: (wrap) => Text('${r.label} · ${context.formatShortDate(r.dueDate)}',
                        maxLines: wrap ? null : 1,
                        overflow: wrap ? null : TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: context.palette.text)),
                  ),
                ),
              ),
            const SizedBox(height: 4),
          ] else
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(context.l10n.catalogNoRemindersOnAppliance,
                    style: TextStyle(fontSize: 11.5, color: context.palette.textMuted)),
              ),
            ),
        ],
      ),
    );
  }
}
