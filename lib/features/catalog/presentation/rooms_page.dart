import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/widgets/adaptive_layout.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/feedback.dart';
import '../application/rooms_controller.dart';
import '../domain/catalog_models.dart';
import 'widgets/catalog_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

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

  RoomsController get _rooms => ref.read(locationsProvider.notifier);

  @override
  void dispose() {
    _newRoom.dispose();
    super.dispose();
  }

  Future<void> _addRoom() async {
    if (_newRoom.text.trim().isEmpty) return;
    setState(() => _adding = true);
    final ok = await runAction(context, () => _rooms.create(_newRoom.text));
    if (ok) _newRoom.clear();
    if (mounted) setState(() => _adding = false);
  }

  /// FAB flow: name + optional photo (camera / gallery / files) in one sheet.
  Future<void> _openAddRoomSheet() => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.palette.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
        builder: (context) => const _AddRoomSheet(),
      );

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationsProvider);
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        title: Text(context.l10n.navRooms, style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
      ),
      floatingActionButton: FloatingActionButton(
        // Tabs share an IndexedStack, so the default hero tag would collide.
        heroTag: null,
        onPressed: _openAddRoomSheet,
        backgroundColor: context.palette.inverseSurface,
        foregroundColor: context.palette.onInverse,
        tooltip: context.l10n.catalogCreateRoom,
        child: const Icon(Icons.add),
      ),
      body: locations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.failureText(e))),
        data: (list) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: _AddRoomComposer(controller: _newRoom, busy: _adding, onSubmit: _addRoom),
              ),
              Expanded(
                // Pull-to-refresh works for both the list and the empty state
                // (e.g. right after joining a family, to pull its rooms in).
                child: RefreshIndicator(
                  onRefresh: _rooms.refresh,
                  child: list.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 140),
                            Center(
                                child: Text(context.l10n.catalogNoRooms,
                                    style: TextStyle(color: context.palette.textMuted))),
                          ],
                        )
                      // Long-press-drag a card to reorder rooms.
                      : ReorderableListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                          itemCount: list.length,
                          onReorderItem: (oldIndex, newIndex) => runAction(context, () => _rooms.reorder(oldIndex, newIndex)),
                          itemBuilder: (context, i) =>
                              _RoomCard(key: ValueKey(list[i].id), location: list[i]),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// FAB bottom sheet: room name + optional photo captured on the go or picked
/// from the device, created in one shot.
class _AddRoomSheet extends ConsumerStatefulWidget {
  const _AddRoomSheet();

  @override
  ConsumerState<_AddRoomSheet> createState() => _AddRoomSheetState();
}

class _AddRoomSheetState extends ConsumerState<_AddRoomSheet> {
  final _name = TextEditingController();
  PickedMedia? _photo;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await pickImage(context);
    if (picked != null) setState(() => _photo = picked);
  }

  Future<void> _create() async {
    setState(() => _busy = true);
    final ok = await runAction(context, () => ref.read(locationsProvider.notifier).create(_name.text, photo: _photo));
    if (!mounted) return;
    ok ? Navigator.of(context).pop() : setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.catalogCreateRoom,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.palette.text)),
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _pickPhoto,
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: context.palette.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.palette.fieldBorder, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: _photo != null
                  ? Image.memory(_photo!.bytes, fit: BoxFit.cover)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: context.palette.textMuted, size: 26),
                        SizedBox(height: 6),
                        Text(context.l10n.catalogAddRoomPhotoLong,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.palette.textMuted)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            onSubmitted: (_) => _create(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.palette.text),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: context.palette.background,
              hintText: context.l10n.catalogRoomNameHint,
              hintStyle: TextStyle(color: context.palette.placeholder, fontWeight: FontWeight.w400),
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
          const SizedBox(height: 18),
          PrimaryButton(label: context.l10n.catalogCreateRoom, isLoading: _busy, onPressed: _create),
        ],
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
          color: context.palette.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.palette.border)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSubmit(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.palette.text),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: context.l10n.catalogAddNewRoom,
                hintStyle: TextStyle(color: context.palette.placeholder, fontWeight: FontWeight.w400),
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
                  icon: Icon(Icons.add_circle_outline, color: context.palette.textSecondary),
                ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({super.key, required this.location});
  final Location location;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push(AppRoutes.room(location.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
            color: context.palette.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: context.palette.border)),
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
                color: context.palette.accentSoft,
                child: Icon(Icons.meeting_room_outlined, size: 40, color: context.palette.accent),
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
                            maxLines: context.primaryLines,
                            overflow: context.primaryOverflow,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
                        const SizedBox(height: 2),
                        Text(context.l10n.catalogRegisteredCount(location.assetCount),
                            style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: context.palette.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.palette.border)),
                    child: Icon(Icons.chevron_right, size: 18, color: context.palette.textSecondary),
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
