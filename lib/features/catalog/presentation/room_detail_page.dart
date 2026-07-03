import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';

/// Design screen 03 — Room detail: hero photo (tap to change), editable name,
/// summary line, and the appliances registered in the room.
class RoomDetailPage extends ConsumerWidget {
  const RoomDetailPage({super.key, required this.locationId});
  final String locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsProvider);
    final assets = ref.watch(assetsProvider).valueOrNull ?? const <Asset>[];
    final reminders = ref.watch(upcomingRemindersProvider).valueOrNull ?? const <Reminder>[];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: locations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          final room = list.where((l) => l.id == locationId).firstOrNull;
          if (room == null) {
            return const Center(child: Text('Room not found.', style: TextStyle(color: AppColors.muted)));
          }
          final inRoom = assets
              .where((a) =>
                  a.locationId == room.id ||
                  (a.locationName ?? '').toLowerCase() == room.name.toLowerCase())
              .toList();
          return ListView(
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
                        BoxDecoration(color: const Color(0xFFEEF3FB), borderRadius: BorderRadius.circular(18)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 30, color: AppColors.chipBlue),
                        SizedBox(height: 6),
                        Text('Add a room photo',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.chipBlue)),
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
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.ink2),
                    onPressed: () => _rename(context, ref, room),
                  ),
                ],
              ),
              Text.rich(
                TextSpan(
                  text: 'The heart of your home, managing ',
                  children: [
                    TextSpan(
                        text: '${inRoom.length} appliance${inRoom.length == 1 ? '' : 's'}',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
                    const TextSpan(text: '.'),
                  ],
                ),
                style: const TextStyle(fontSize: 13.5, color: AppColors.muted),
              ),
              const SizedBox(height: 18),
              const Text('Appliances',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 10),
              if (inRoom.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                      child: Text('Nothing registered here yet.', style: TextStyle(color: AppColors.muted))),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.88),
                  itemCount: inRoom.length,
                  itemBuilder: (context, i) => _ApplianceCard(
                    asset: inRoom[i],
                    soonest: _soonestFor(inRoom[i].id, reminders),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.chipBlue,
        onPressed: () {
          final room = ref.read(locationsProvider).valueOrNull?.where((l) => l.id == locationId).firstOrNull;
          context.push('/appliance-picker?location=${Uri.encodeComponent(room?.name ?? '')}');
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add here', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  static Reminder? _soonestFor(String assetId, List<Reminder> reminders) {
    final mine = reminders.where((r) => r.assetId == assetId).toList()
      ..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
    return mine.firstOrNull;
  }

  Future<void> _rename(BuildContext context, WidgetRef ref, Location room) async {
    final controller = TextEditingController(text: room.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paper,
        title: const Text('Rename room', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || name == room.name) return;
    await ref.read(catalogRepositoryProvider).updateLocation(room.id, name: name);
    ref.invalidate(locationsProvider);
    ref.invalidate(assetsProvider);
  }

  Future<void> _changePhoto(BuildContext context, WidgetRef ref, Location room) async {
    final f = await pickImage(context);
    if (f == null) return;
    try {
      await ref.read(catalogRepositoryProvider).setLocationImage(
            room.id,
            bytes: f.bytes,
            fileName: f.name,
            mimeType: f.imageMime,
          );
      ref.invalidate(locationsProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Photo upload failed: $e'), backgroundColor: AppColors.red));
      }
    }
  }
}

class _ApplianceCard extends StatelessWidget {
  const _ApplianceCard({required this.asset, required this.soonest});
  final Asset asset;
  final Reminder? soonest;

  @override
  Widget build(BuildContext context) {
    final brandModel = [asset.brand, asset.model].whereType<String>().join(' · ');
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push('/asset/${asset.id}'),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.paper, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo strip (falls back to the category icon).
            AssetThumb(
              imageRef: asset.imageUrl,
              width: double.infinity,
              height: 74,
              radius: 0,
              fallback: Container(
                width: double.infinity,
                height: 74,
                color: const Color(0xFFEEF3FB),
                child: Icon(asset.category.icon, size: 30, color: AppColors.chipBlue),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink, height: 1.2)),
                    const SizedBox(height: 2),
                    Text(brandModel.isEmpty ? asset.typeLabel : '${asset.typeLabel} · $brandModel',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                    const Spacer(),
                    Row(
                      children: [
                        if (soonest != null) ...[
                          DayPill(daysLeft: soonest!.daysLeft),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(soonest!.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
                          ),
                        ] else
                          const Text('No reminders',
                              style: TextStyle(fontSize: 10.5, color: AppColors.muted)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
