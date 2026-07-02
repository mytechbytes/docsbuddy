import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../../../core/widgets/db_logo.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';

/// Design screen 02 — Rooms: "Add a new room" composer + photo cards with
/// registered-asset counts, backed by `public.locations`.
class RoomsPage extends ConsumerStatefulWidget {
  const RoomsPage({super.key});

  @override
  ConsumerState<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends ConsumerState<RoomsPage> {
  final _newRoom = TextEditingController();
  bool _adding = false;

  @override
  void dispose() {
    _newRoom.dispose();
    super.dispose();
  }

  Future<void> _addRoom() async {
    final name = _newRoom.text.trim();
    if (name.isEmpty) return;
    setState(() => _adding = true);
    try {
      await ref.read(catalogRepositoryProvider).createLocation(name);
      _newRoom.clear();
      ref.invalidate(locationsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not add room: $e'), backgroundColor: AppColors.red));
      }
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationsProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        titleSpacing: 20,
        title: const Align(alignment: Alignment.centerLeft, child: DbLogo(size: 20)),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(locationsProvider),
        child: locations.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
            children: [
              _AddRoomComposer(controller: _newRoom, busy: _adding, onSubmit: _addRoom),
              const SizedBox(height: 16),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                      child: Text('No rooms yet. Add your first room above.',
                          style: TextStyle(color: AppColors.muted))),
                )
              else
                for (final l in list) _RoomCard(location: l),
            ],
          ),
        ),
      ),
    );
  }
}

/// The design's inline "Add a new room" row with a ⊕ submit button.
class _AddRoomComposer extends StatelessWidget {
  const _AddRoomComposer({required this.controller, required this.busy, required this.onSubmit});
  final TextEditingController controller;
  final bool busy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 4, 8, 4),
      decoration: BoxDecoration(
          color: AppColors.paper, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSubmit(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add a new room',
                hintStyle: TextStyle(color: AppColors.placeholder, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          busy
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : IconButton(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.ink2),
                ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.location});
  final Location location;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push('/room/${location.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
            color: AppColors.paper, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AssetThumb(
              imageRef: location.imageUrl,
              width: double.infinity,
              height: 140,
              radius: 0,
              fallback: Container(
                width: double.infinity,
                height: 140,
                color: const Color(0xFFEEF3FB),
                child: const Icon(Icons.meeting_room_outlined, size: 40, color: AppColors.chipBlue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(location.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                        const SizedBox(height: 2),
                        Text('${location.assetCount} Registered',
                            style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: AppColors.bg,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line)),
                    child: const Icon(Icons.chevron_right, size: 18, color: AppColors.ink2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
