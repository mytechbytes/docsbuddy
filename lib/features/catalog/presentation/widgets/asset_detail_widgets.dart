import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/catalog_models.dart';
import '../service_detail_sheet.dart';
import 'catalog_widgets.dart';

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

  Asset get asset => widget.asset;
  int get reminderCount => widget.reminderCount;
  VoidCallback get onChangePhoto => widget.onChangePhoto;

  @override
  Widget build(BuildContext context) {
    final meta = [
      '${plural(reminderCount, 'reminder')} tracked',
      if (asset.brand != null) asset.brand,
      if (asset.model != null) asset.model,
      if (asset.serialNo != null) asset.serialNo,
    ].whereType<String>().join(' · ');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                              color: AppColors.bg,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppColors.line)),
                          child: Text.rich(
                            TextSpan(
                              text: '${e.key}  ',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.muted, fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(
                                    text: e.value,
                                    style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Expand: the full asset record inline.
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: _expanded ? 'Hide details' : 'Show all details',
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.ink2),
            onPressed: () => setState(() => _expanded = !_expanded),
          ),
        ],
      ),
          if (_expanded) ...[
            const SizedBox(height: 6),
            const Divider(color: AppColors.line, height: 16),
            InfoRow('Type', asset.typeLabel),
            InfoRow('Category', asset.category.label),
            if (asset.locationName != null) InfoRow('Room', asset.locationName!),
            if (asset.brand != null) InfoRow('Brand', asset.brand!),
            if (asset.model != null) InfoRow('Model', asset.model!),
            if (asset.serialNo != null) InfoRow('Serial / reg. no.', asset.serialNo!),
            if (asset.purchaseDate != null)
              InfoRow('Purchase date', DateFormat('d MMM yyyy').format(asset.purchaseDate!)),
            if (asset.purchasePrice != null)
              InfoRow('Purchase price', '₹ ${NumberFormat('#,##0.##').format(asset.purchasePrice)}'),
            if (asset.store != null) InfoRow('Store', asset.store!),
            for (final e in asset.properties.entries) InfoRow(e.key, e.value),
            InfoRow('Reminders tracked', '$reminderCount'),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
          ),
        ],
      ),
    );
  }
}

/// Red "next due" banner highlighting the most urgent reminder.
class NextDueBanner extends StatelessWidget {
  const NextDueBanner({super.key, required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final phrase = dueCountdown(reminder.daysLeft);
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

class ServiceRow extends StatelessWidget {
  const ServiceRow({super.key, required this.reminder, required this.onTap, required this.onAction});
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
