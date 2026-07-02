import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../../documents/application/document_providers.dart';
import '../../documents/data/document_models.dart';
import '../data/catalog_models.dart';

/// What the caller wants done after the sheet closes.
enum ServiceAction { edit, complete, delete }

/// Bottom sheet with the full service record — schedule, offsets, provider,
/// policy no., **cost**, notes — and the documents attached to this service
/// (`documents.asset_date_id`).
class ServiceDetailSheet extends ConsumerWidget {
  const ServiceDetailSheet({super.key, required this.reminder});
  final Reminder reminder;

  static Future<ServiceAction?> show(BuildContext context, Reminder reminder) {
    return showModalBottomSheet<ServiceAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ServiceDetailSheet(reminder: reminder),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = (ref.watch(assetDocumentsProvider(reminder.assetId)).valueOrNull ?? const <DocumentMeta>[])
        .where((d) => d.assetDateId == reminder.id)
        .toList();
    final money = NumberFormat('#,##0.##');

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration:
                        BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(999)))),
            const SizedBox(height: 16),
            Row(
              children: [
                IconBubble(kind: reminder.kind, size: 44),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reminder.label,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                      Text(reminder.assetName, style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                    ],
                  ),
                ),
                DayPill(daysLeft: reminder.daysLeft),
              ],
            ),
            const SizedBox(height: 16),
            _DetailRow(
                icon: Icons.event_outlined,
                label: 'Due',
                value:
                    '${DateFormat('d MMM yyyy').format(reminder.dueDate)} · ${reminder.recurrence == Recurrence.none ? 'One-off' : reminder.recurrence.label}'),
            _DetailRow(icon: Icons.notifications_none, label: 'Reminds', value: reminder.offsetsLabel),
            if (reminder.provider != null)
              _DetailRow(icon: Icons.storefront_outlined, label: 'Provider', value: reminder.provider!),
            if (reminder.policyNo != null)
              _DetailRow(icon: Icons.tag, label: 'Policy / contract', value: reminder.policyNo!),
            if (reminder.cost != null)
              _DetailRow(icon: Icons.currency_rupee, label: 'Cost', value: '₹ ${money.format(reminder.cost)}'),
            if (reminder.notes != null)
              _DetailRow(icon: Icons.sticky_note_2_outlined, label: 'Notes', value: reminder.notes!),
            if (docs.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('DOCUMENTS FOR THIS SERVICE',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
              const SizedBox(height: 8),
              for (final d in docs) _DocRow(doc: d),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(ServiceAction.edit),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.ink, side: const BorderSide(color: AppColors.line)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(ServiceAction.complete),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.green),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(ServiceAction.delete),
                  icon: const Icon(Icons.delete_outline, color: AppColors.red),
                  style: IconButton.styleFrom(side: const BorderSide(color: AppColors.line)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.muted),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.ink)),
          ),
        ],
      ),
    );
  }
}

class _DocRow extends ConsumerWidget {
  const _DocRow({required this.doc});
  final DocumentMeta doc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        final url = await ref.read(documentRepositoryProvider).viewUrl(doc);
        if (!context.mounted) return;
        if (url == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Connect Supabase to open files.'), backgroundColor: AppColors.red));
          return;
        }
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(doc.kind.icon, size: 16, color: AppColors.ink2),
            const SizedBox(width: 8),
            Expanded(
              child: Text(doc.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
            ),
            Text(doc.prettySize, style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
            const SizedBox(width: 4),
            const Icon(Icons.open_in_new, size: 13, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
