import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/adaptive_layout.dart';
import '../../domain/catalog_models.dart';
import '../service_detail_sheet.dart';
import 'catalog_widgets.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';

class AddPill extends StatelessWidget {
  const AddPill({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: context.palette.inverseSurface, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: context.palette.onInverse),
            SizedBox(width: 4),
            Text(context.l10n.commonAdd, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.onInverse)),
          ],
        ),
      ),
    );
  }
}

class AssetInfoCard extends StatefulWidget {
  const AssetInfoCard({super.key, required this.asset, required this.reminderCount, required this.onChangePhoto});
  final Asset asset;
  final int reminderCount;
  final VoidCallback onChangePhoto;

  @override
  State<AssetInfoCard> createState() => _AssetInfoCardState();
}

class _AssetInfoCardState extends State<AssetInfoCard> {
  bool _expanded = false;

  /// Narrowest card (at the default font size) that fits the photo beside the
  /// name; below it the photo goes above the name.
  static const _photoBesideWidth = 230.0;

  Asset get asset => widget.asset;
  int get reminderCount => widget.reminderCount;
  VoidCallback get onChangePhoto => widget.onChangePhoto;

  Widget _photo(BuildContext context) => InkWell(
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
                decoration: BoxDecoration(color: context.palette.background, borderRadius: BorderRadius.circular(16)),
                child: Icon(asset.category.icon, color: context.palette.textSecondary, size: 30),
              ),
            ),
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: context.palette.inverseSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.palette.surface, width: 2),
                ),
                child: Icon(Icons.photo_camera_outlined, size: 11, color: context.palette.onInverse),
              ),
            ),
          ],
        ),
      );

  /// Expand: the full asset record inline.
  Widget _expandButton(BuildContext context) => IconButton(
        visualDensity: VisualDensity.compact,
        tooltip: _expanded ? context.l10n.catalogHideDetails : context.l10n.catalogShowDetails,
        icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: context.palette.textSecondary),
        onPressed: () => setState(() => _expanded = !_expanded),
      );

  Widget _details(BuildContext context, String meta) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(asset.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: context.palette.text, height: 1.2)),
          const SizedBox(height: 6),
          Align(alignment: Alignment.centerLeft, child: CategoryChip(asset.typeName(context))),
          const SizedBox(height: 8),
          Text(meta, style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
          // Type-specific properties (Tonnage, IMEI, …) from Add asset.
          if (asset.properties.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final e in asset.properties.entries)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                        color: context.palette.background,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: context.palette.border)),
                    child: Text.rich(
                      TextSpan(
                        text: '${e.key}  ',
                        style: TextStyle(fontSize: 11.5, color: context.palette.textMuted, fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(text: e.value, style: TextStyle(color: context.palette.text, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      );

  @override
  Widget build(BuildContext context) {
    final meta = [
      context.l10n.catalogRemindersTracked(reminderCount),
      if (asset.brand != null) asset.brand,
      if (asset.model != null) asset.model,
      if (asset.serialNo != null) asset.serialNo,
    ].whereType<String>().join(' · ');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: context.palette.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: context.palette.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (fitsAtScale(context, constraints.maxWidth, _photoBesideWidth)) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _photo(context),
                    const SizedBox(width: 14),
                    Expanded(child: _details(context, meta)),
                    _expandButton(context),
                  ],
                );
              }
              // Too narrow for a photo and a name side by side: photo and
              // expander on one line, the name and details full width beneath.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [_photo(context), const Spacer(), _expandButton(context)]),
                  const SizedBox(height: 12),
                  _details(context, meta),
                ],
              );
            },
          ),
          if (_expanded) ...[
            const SizedBox(height: 6),
            Divider(color: context.palette.border, height: 16),
            InfoRow(context.l10n.catalogType, asset.typeName(context)),
            InfoRow(context.l10n.catalogCategory, asset.category.displayName(context)),
            if (asset.locationName != null) InfoRow(context.l10n.catalogRoom, asset.locationName!),
            if (asset.brand != null) InfoRow(context.l10n.catalogBrand, asset.brand!),
            if (asset.model != null) InfoRow(context.l10n.catalogModel, asset.model!),
            if (asset.serialNo != null) InfoRow(context.l10n.catalogSerialShort, asset.serialNo!),
            if (asset.purchaseDate != null)
              InfoRow(context.l10n.catalogPurchaseDate, context.formatDate(asset.purchaseDate!)),
            if (asset.purchasePrice != null)
              InfoRow(context.l10n.catalogPurchasePrice, context.formatMoney(asset.purchasePrice!)),
            if (asset.store != null) InfoRow(context.l10n.catalogStore, asset.store!),
            for (final e in asset.properties.entries) InfoRow(e.key, e.value),
            InfoRow(context.l10n.catalogRemindersTrackedLabel, '$reminderCount'),
          ],
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key});
  final String label;
  final String value;

  /// Narrowest (at the default font size) that fits the 128dp label column
  /// beside a readable value.
  static const _sideBySideWidth = 260.0;

  @override
  Widget build(BuildContext context) {
    final labelText = Text(label, style: TextStyle(fontSize: 12.5, color: context.palette.textMuted));
    final valueText =
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.text));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (fitsAtScale(context, constraints.maxWidth, _sideBySideWidth)) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(width: 128, child: labelText), Expanded(child: valueText)],
            );
          }
          // Too tight for a fixed label column: label above value.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [labelText, const SizedBox(height: 2), valueText],
          );
        },
      ),
    );
  }
}

/// Red "next due" banner highlighting the most urgent reminder.
class NextDueBanner extends StatelessWidget {
  const NextDueBanner({super.key, required this.reminder});
  final Reminder reminder;

  /// Narrowest (at the default font size) that fits the headline and the dates side by side.
  static const _sideBySideWidth = 270.0;

  @override
  Widget build(BuildContext context) {
    final phrase = dueCountdown(context.l10n, reminder.daysLeft);
    final headline = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.catalogNextDue, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text('${reminder.label} · $phrase',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15)),
      ],
    );
    Widget dates(CrossAxisAlignment align) => Column(
          crossAxisAlignment: align,
          children: [
            Text(context.formatDate(reminder.dueDate),
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 4),
            Text(context.l10n.catalogRemindsOffsets(context.formatOffsets(reminder.notifyOffsets)), style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(18)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // The dates keep their natural width beside the headline, so with
          // large text they squeeze it to a few letters a line. Stack them then.
          if (fitsAtScale(context, constraints.maxWidth, _sideBySideWidth)) {
            return Row(
              children: [
                Expanded(child: headline),
                const SizedBox(width: 12),
                dates(CrossAxisAlignment.end),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [headline, const SizedBox(height: 10), dates(CrossAxisAlignment.start)],
          );
        },
      ),
    );
  }
}

class ServiceRow extends StatelessWidget {
  const ServiceRow({super.key, required this.reminder, required this.onTap, required this.onAction});
  final Reminder reminder;
  final VoidCallback onTap;
  final ValueChanged<ServiceAction> onAction;

  /// Narrowest (at the default font size) that keeps the text, the day pill and
  /// the menu on one row; below it the pill moves under the text.
  static const _singleRowWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    final service = [
      if (reminder.provider != null) reminder.provider,
      if (reminder.policyNo != null) reminder.policyNo,
    ].whereType<String>().join(' · ');

    Widget details({required bool wrap}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reminder.label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.palette.text)),
            const SizedBox(height: 3),
            // Only ~130px remain beside the icon, day pill and menu, so the
            // date and the offsets list (up to six values) wrap rather than
            // overflow.
            Wrap(
              spacing: 8,
              runSpacing: 2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(context.formatDate(reminder.dueDate), style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_none, size: 13, color: context.palette.textMuted),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(context.formatOffsets(reminder.notifyOffsets),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
                    ),
                  ],
                ),
              ],
            ),
            if (service.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(service,
                  maxLines: wrap ? null : 1,
                  overflow: wrap ? null : TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: context.palette.textMuted)),
            ],
          ],
        );

    final menu = PopupMenuButton<ServiceAction>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert, size: 18, color: context.palette.textMuted),
      onSelected: onAction,
      itemBuilder: (_) => [
        PopupMenuItem(value: ServiceAction.complete, child: Text(context.l10n.catalogMarkAsDone)),
        PopupMenuItem(value: ServiceAction.edit, child: Text(context.l10n.commonEdit)),
        PopupMenuItem(
            value: ServiceAction.delete,
            child: Text(context.l10n.commonDelete, style: TextStyle(color: context.palette.danger))),
      ],
    );

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: context.palette.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.palette.border)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (fitsAtScale(context, constraints.maxWidth, _singleRowWidth)) {
              return Row(
                children: [
                  IconBubble(kind: reminder.kind, size: 44),
                  const SizedBox(width: 12),
                  Expanded(child: details(wrap: false)),
                  const SizedBox(width: 8),
                  DayPill(daysLeft: reminder.daysLeft),
                  menu,
                ],
              );
            }
            // Not enough room beside an icon, a pill and a menu: icon and menu
            // share a line, and the text and the pill get the full width below.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [IconBubble(kind: reminder.kind, size: 44), const Spacer(), menu]),
                const SizedBox(height: 8),
                details(wrap: true),
                const SizedBox(height: 8),
                DayPill(daysLeft: reminder.daysLeft),
              ],
            );
          },
        ),
      ),
    );
  }
}
