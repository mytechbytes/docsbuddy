import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/adaptive_layout.dart';
import '../../documents/application/document_providers.dart';
import '../../documents/domain/document_models.dart';
import '../../documents/presentation/attachment_widgets.dart';
import '../domain/catalog_models.dart';
import 'widgets/catalog_widgets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

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
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ServiceDetailSheet(reminder: reminder),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(serviceDocumentsProvider((assetId: reminder.assetId, reminderId: reminder.id))).value ??
        const <DocumentMeta>[];

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
                        BoxDecoration(color: context.palette.border, borderRadius: BorderRadius.circular(999)))),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final title = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reminder.label,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
                    Text(reminder.assetName, style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
                  ],
                );
                // Beside the title the pill leaves it a few letters of width at
                // large text, so it goes under the title.
                if (fitsAtScale(context, constraints.maxWidth, 250)) {
                  return Row(
                    children: [
                      IconBubble(kind: reminder.kind, size: 44),
                      const SizedBox(width: 12),
                      Expanded(child: title),
                      DayPill(daysLeft: reminder.daysLeft),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconBubble(kind: reminder.kind, size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [title, const SizedBox(height: 8), DayPill(daysLeft: reminder.daysLeft)],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            _DetailRow(
                icon: Icons.event_outlined,
                label: context.l10n.catalogDue,
                value:
                    '${context.formatDate(reminder.dueDate)} · ${reminder.isOneOff ? context.l10n.catalogOneOff : reminder.recurrence.displayName(context)}'),
            _DetailRow(icon: Icons.notifications_none, label: context.l10n.catalogReminds, value: context.formatOffsets(reminder.notifyOffsets)),
            if (reminder.provider != null)
              _DetailRow(icon: Icons.storefront_outlined, label: context.l10n.catalogProvider, value: reminder.provider!),
            if (reminder.policyNo != null)
              _DetailRow(icon: Icons.tag, label: context.l10n.catalogPolicyContract, value: reminder.policyNo!),
            if (reminder.cost != null)
              _DetailRow(icon: Icons.currency_rupee, label: context.l10n.catalogCost, value: context.formatMoney(reminder.cost!)),
            if (reminder.notes != null)
              _DetailRow(icon: Icons.sticky_note_2_outlined, label: context.l10n.catalogNotes, value: reminder.notes!),
            if (docs.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(context.l10n.catalogServiceDocuments,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.textMuted, letterSpacing: context.tracking(1))),
              const SizedBox(height: 8),
              DocumentGrid(assetId: reminder.assetId, docs: docs),
            ],
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final edit = OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(ServiceAction.edit),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text(context.l10n.commonEdit, style: const TextStyle(fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: context.palette.text, side: BorderSide(color: context.palette.border)),
                );
                final done = FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(ServiceAction.complete),
                  icon: const Icon(Icons.check, size: 16),
                  label: Text(context.l10n.commonDone, style: const TextStyle(fontWeight: FontWeight.w700)),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.green),
                );
                final delete = IconButton(
                  onPressed: () => Navigator.of(context).pop(ServiceAction.delete),
                  icon: Icon(Icons.delete_outline, color: context.palette.danger),
                  style: IconButton.styleFrom(side: BorderSide(color: context.palette.border)),
                );
                if (fitsAtScale(context, constraints.maxWidth, 240)) {
                  return Row(
                    children: [
                      Expanded(child: edit),
                      const SizedBox(width: 10),
                      Expanded(child: done),
                      const SizedBox(width: 10),
                      delete,
                    ],
                  );
                }
                // Three controls no longer fit one line: the main action first,
                // each at full width.
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [done, const SizedBox(height: 10), edit, const SizedBox(height: 10), Align(alignment: AlignmentDirectional.centerStart, child: delete)],
                );
              },
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
          Icon(icon, size: 16, color: context.palette.textMuted),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(fontSize: 13, color: context.palette.textMuted)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: context.palette.text)),
          ),
        ],
      ),
    );
  }
}
