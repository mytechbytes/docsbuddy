import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';

class AssetDetailPage extends ConsumerWidget {
  const AssetDetailPage({super.key, required this.assetId});
  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetProvider(assetId));
    final reminders = ref.watch(assetRemindersProvider(assetId));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: Text(asset.valueOrNull?.name ?? 'Asset', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: asset.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (a) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            _InfoCard(asset: a),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('REMINDERS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
                GestureDetector(
                  onTap: () => _addReminder(context, ref, a),
                  child: const Text('+ Add', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.chipBlue)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            reminders.when(
              loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Text('$e'),
              data: (list) => list.isEmpty
                  ? const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: Text('No reminders for this asset yet.', style: TextStyle(color: AppColors.muted))))
                  : Column(children: [for (final r in list) _ReminderRow(reminder: r)]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addReminder(BuildContext context, WidgetRef ref, Asset asset) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _AddReminderSheet(asset: asset),
    );
    ref.invalidate(assetRemindersProvider(assetId));
    refreshCatalog(ref);
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.asset});
  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(14)),
            child: Icon(asset.category.icon, color: AppColors.ink2),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text([asset.subtitle, if (asset.brand != null) asset.brand].join(' · '), style: const TextStyle(fontSize: 13, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
      child: Row(
        children: [
          IconBubble(kind: reminder.kind, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                Text('${DateFormat('d MMM yyyy').format(reminder.dueDate)} · ${reminder.recurrence.label}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          DayPill(daysLeft: reminder.daysLeft),
        ],
      ),
    );
  }
}

class _AddReminderSheet extends ConsumerStatefulWidget {
  const _AddReminderSheet({required this.asset});
  final Asset asset;

  @override
  ConsumerState<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends ConsumerState<_AddReminderSheet> {
  final _label = TextEditingController();
  ReminderKind _kind = ReminderKind.insurance;
  Recurrence _recurrence = Recurrence.yearly;
  DateTime _due = DateTime.now().add(const Duration(days: 30));
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _label.text = _kind.label;
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(catalogRepositoryProvider).addReminder(
          assetId: widget.asset.id,
          kind: _kind,
          label: _label.text.trim().isEmpty ? _kind.label : _label.text.trim(),
          dueDate: _due,
          recurrence: _recurrence,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(999)))),
              const SizedBox(height: 16),
              Text('Add reminder · ${widget.asset.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 16),
              const Text('Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final k in ReminderKind.values)
                    ChoiceChip(
                      selected: _kind == k,
                      onSelected: (_) => setState(() {
                        _kind = k;
                        _label.text = k.label;
                      }),
                      label: Text(k.label),
                      labelStyle: TextStyle(fontWeight: FontWeight.w600, color: _kind == k ? k.fg : AppColors.ink2, fontSize: 12),
                      selectedColor: k.bg,
                      backgroundColor: AppColors.paper,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999), side: const BorderSide(color: AppColors.line)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: 'Due date',
                      child: InkWell(
                        onTap: _pickDate,
                        child: Text(DateFormat('d MMM yyyy').format(_due), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Field(
                      label: 'Repeat',
                      child: DropdownButton<Recurrence>(
                        value: _recurrence,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: [for (final r in Recurrence.values) DropdownMenuItem(value: r, child: Text(r.label))],
                        onChanged: (v) => setState(() => _recurrence = v ?? Recurrence.none),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: 'Save reminder', isLoading: _saving, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
        const SizedBox(height: 6),
        Container(
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.fieldBorder, width: 1.5)),
          child: child,
        ),
      ],
    );
  }
}
