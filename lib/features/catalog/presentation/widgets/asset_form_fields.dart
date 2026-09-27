import 'package:flutter/material.dart';

import '../../../../core/media/media_picker.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/catalog_models.dart';
import 'catalog_widgets.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';

/// One selectable category card on step 1.
class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.kind, required this.selected, required this.onTap});
  final AssetCategoryKind kind;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? context.palette.inverseSurface : context.palette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? context.palette.inverseSurface : context.palette.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? context.palette.onInverse.withValues(alpha: 0.12) : context.palette.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(kind.icon, size: 22, color: selected ? context.palette.onInverse : context.palette.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(kind.displayName(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: selected ? context.palette.onInverse : context.palette.inverseSurface)),
          ],
        ),
      ),
    );
  }
}

class AssetTypeChip extends StatelessWidget {
  const AssetTypeChip({super.key, required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? context.palette.inverseSurface : context.palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? context.palette.inverseSurface : context.palette.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? context.palette.onInverse : context.palette.textSecondary),
            const SizedBox(width: 7),
            Text(label,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: selected ? context.palette.onInverse : context.palette.inverseSurface)),
          ],
        ),
      ),
    );
  }
}

/// Existing-rooms dropdown: no room (blank) / a room / "New room…".
class RoomDropdown extends StatelessWidget {
  const RoomDropdown({super.key, 
    required this.rooms,
    required this.value,
    required this.newRoomSentinel,
    required this.onChanged,
  });

  final List<Location> rooms;
  final String? value;
  final String newRoomSentinel;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final names = {for (final r in rooms) r.name};
    // Keep a prefilled value selectable even before it exists as a room.
    if (value != null && value != newRoomSentinel) names.add(value!);
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.palette.fieldBorder, width: 1.5),
      ),
      child: DropdownButton<String?>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(context.l10n.catalogNoRoomHint,
            style: TextStyle(fontSize: 14, color: context.palette.placeholder)),
        items: [
          DropdownMenuItem<String?>(
              value: null,
              child: Text(context.l10n.catalogNoRoom, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.palette.textMuted))),
          for (final n in names)
            DropdownMenuItem<String?>(
              value: n,
              child: Row(
                children: [
                  Icon(Icons.meeting_room_outlined, size: 18, color: context.palette.textSecondary),
                  const SizedBox(width: 8),
                  Text(n, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.palette.text)),
                ],
              ),
            ),
          DropdownMenuItem<String?>(
            value: newRoomSentinel,
            child: Row(
              children: [
                Icon(Icons.add_circle_outline, size: 18, color: context.palette.accent),
                SizedBox(width: 8),
                Text(context.l10n.catalogNewRoom,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.palette.accent)),
              ],
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

/// Tappable photo box: the freshly picked image, the asset's existing photo
/// (edit mode), or an add-photo prompt. Tap → camera / gallery / files sheet.
class AssetPhotoPicker extends StatelessWidget {
  const AssetPhotoPicker({super.key, required this.photo, required this.onTap, this.existingRef});
  final PickedMedia? photo;
  final String? existingRef;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final placeholder = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, color: context.palette.textMuted, size: 26),
        SizedBox(height: 6),
        Text(context.l10n.catalogAddPhoto, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.palette.textMuted)),
      ],
    );
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.palette.fieldBorder, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: photo != null
            ? Image.memory(photo!.bytes, fit: BoxFit.cover)
            : AssetThumb(imageRef: existingRef, size: 96, radius: 18, fallback: placeholder),
      ),
    );
  }
}

/// Tappable date field styled like [AppTextField].
class DateField extends StatelessWidget {
  const DateField({super.key, required this.label, required this.value, required this.onTap});
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.text)),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: context.palette.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.palette.fieldBorder, width: 1.5),
            ),
            child: Row(
              children: [
                Icon(Icons.event_outlined, size: 18, color: context.palette.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value == null ? context.l10n.commonOptional : context.formatDate(value!),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: value == null ? FontWeight.w400 : FontWeight.w600,
                      color: value == null ? context.palette.placeholder : context.palette.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
