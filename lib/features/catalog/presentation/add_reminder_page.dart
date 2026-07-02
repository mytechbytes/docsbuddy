import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../documents/application/document_providers.dart';
import '../../documents/data/document_models.dart';
import '../../settings/application/settings_providers.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';

/// Design screen 08 — Add Reminder as a full page: type tile grid, due date
/// with an "in N days" helper, repeat chips, multi-select notify offsets
/// (pre-filled from prefs), service details, and a service-scoped
/// attach-document row.
class AddReminderPage extends ConsumerStatefulWidget {
  const AddReminderPage({super.key, required this.assetId, this.editing});
  final String assetId;

  /// When set, the page edits this service instead of creating one.
  final Reminder? editing;

  @override
  ConsumerState<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends ConsumerState<AddReminderPage> {
  late final _label = TextEditingController(text: widget.editing?.label ?? '');
  late final _provider = TextEditingController(text: widget.editing?.provider ?? '');
  late final _policyNo = TextEditingController(text: widget.editing?.policyNo ?? '');
  late final _cost = TextEditingController(
      text: widget.editing?.cost == null ? '' : widget.editing!.cost!.toStringAsFixed(0));
  late final _notes = TextEditingController(text: widget.editing?.notes ?? '');
  late ReminderKind _kind = widget.editing?.kind ?? ReminderKind.insurance;
  late Recurrence _recurrence = widget.editing?.recurrence ?? Recurrence.yearly;
  late DateTime _due = widget.editing?.dueDate ?? DateTime.now().add(const Duration(days: 30));
  late Set<int>? _offsets = widget.editing == null ? null : {...widget.editing!.notifyOffsets};
  PlatformFile? _attachment;
  bool _saving = false;

  bool get _isEdit => widget.editing != null;

  static const _offsetOptions = [60, 30, 14, 7, 3, 1];

  @override
  void initState() {
    super.initState();
    if (!_isEdit) _label.text = _kind.label;
  }

  @override
  void dispose() {
    _label.dispose();
    _provider.dispose();
    _policyNo.dispose();
    _cost.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _text(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  int get _daysAway {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(_due.year, _due.month, _due.day).difference(today).inDays;
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

  Future<void> _pickAttachment() async {
    final res = await FilePicker.platform.pickFiles(withData: true);
    final f = res?.files.firstOrNull;
    if (f?.bytes != null) setState(() => _attachment = f);
  }

  Future<void> _save(Set<int> offsets) async {
    setState(() => _saving = true);
    final repo = ref.read(catalogRepositoryProvider);
    try {
      final sorted = offsets.toList()..sort((a, b) => b.compareTo(a));
      final label = _label.text.trim().isEmpty ? _kind.label : _label.text.trim();
      final Reminder reminder;
      if (_isEdit) {
        reminder = await repo.updateReminder(
          widget.editing!.id,
          kind: _kind,
          label: label,
          dueDate: _due,
          recurrence: _recurrence,
          notifyOffsets: sorted,
          provider: _text(_provider),
          policyNo: _text(_policyNo),
          cost: double.tryParse(_cost.text.trim().replaceAll(',', '')),
          notes: _text(_notes),
        );
      } else {
        reminder = await repo.addReminder(
          assetId: widget.assetId,
          kind: _kind,
          label: label,
          dueDate: _due,
          recurrence: _recurrence,
          notifyOffsets: sorted,
          provider: _text(_provider),
          policyNo: _text(_policyNo),
          cost: double.tryParse(_cost.text.trim().replaceAll(',', '')),
          notes: _text(_notes),
        );
      }

      // Service-scoped document (documents.asset_date_id).
      final attachment = _attachment;
      if (attachment?.bytes != null) {
        try {
          await ref.read(documentRepositoryProvider).upload(
                assetId: widget.assetId,
                assetDateId: reminder.id,
                fileName: attachment!.name,
                bytes: attachment.bytes!,
                mimeType: switch (attachment.extension?.toLowerCase()) {
                  'pdf' => 'application/pdf',
                  'jpg' || 'jpeg' => 'image/jpeg',
                  'png' => 'image/png',
                  _ => 'application/octet-stream',
                },
                kind: _kind == ReminderKind.insurance ? DocKind.insurance : DocKind.other,
              );
          ref.invalidate(assetDocumentsProvider(widget.assetId));
        } catch (_) {/* reminder saved; the document can be attached later */}
      }

      if (!mounted) return;
      ref.invalidate(assetRemindersProvider(widget.assetId));
      refreshCatalog(ref);
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not save: $e'), backgroundColor: AppColors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = ref.watch(assetProvider(widget.assetId)).valueOrNull;
    final prefDefaults =
        ref.watch(notificationPrefsProvider).valueOrNull?.defaultOffsets ?? const [30, 7, 1];
    final offsets = _offsets ?? {...prefDefaults};

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        actions: [
          IconButton(icon: const Icon(Icons.close, color: AppColors.ink), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          Text(_isEdit ? 'Edit Reminder' : 'Add Reminder',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink)),
          if (asset != null) ...[
            const SizedBox(height: 2),
            Text.rich(
              TextSpan(text: 'For ', children: [
                TextSpan(text: asset.name, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
              ]),
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ],
          const SizedBox(height: 16),
          const Text('Reminder Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.92,
            children: [
              for (final k in ReminderKind.values.where((k) => k != ReminderKind.other))
                _TypeTile(
                  kind: k,
                  selected: _kind == k,
                  onTap: () => setState(() {
                    _kind = k;
                    _label.text = k.label;
                  }),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Due Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _pickDate,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_outlined, size: 18, color: AppColors.muted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(DateFormat('dd / MM / yyyy').format(_due),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ),
                  Text(
                    _daysAway < 0 ? '${-_daysAway}d ago' : 'in $_daysAway day${_daysAway == 1 ? '' : 's'}',
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Repeats', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final r in Recurrence.values)
                ChoiceChip(
                  selected: _recurrence == r,
                  onSelected: (_) => setState(() => _recurrence = r),
                  label: Text(r == Recurrence.none ? 'Never' : r.label),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: _recurrence == r ? Colors.white : AppColors.ink2),
                  selectedColor: AppColors.ink,
                  backgroundColor: AppColors.paper,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999), side: const BorderSide(color: AppColors.line)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Notify me', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 2),
          const Text('Push notification & reminder to all family members.',
              style: TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final d in _offsetOptions)
                FilterChip(
                  selected: offsets.contains(d),
                  onSelected: (v) => setState(() {
                    final next = {...offsets};
                    v ? next.add(d) : next.remove(d);
                    _offsets = next;
                  }),
                  label: Text('${d}d before'),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: offsets.contains(d) ? Colors.white : AppColors.ink2),
                  selectedColor: AppColors.chipBlue,
                  checkmarkColor: Colors.white,
                  backgroundColor: AppColors.paper,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999), side: const BorderSide(color: AppColors.line)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Service details (optional)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: AppTextField(label: 'Provider', controller: _provider, hint: 'e.g. Acko')),
              const SizedBox(width: 12),
              Expanded(child: AppTextField(label: 'Policy / contract no.', controller: _policyNo, hint: 'optional')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Cost',
                  controller: _cost,
                  hint: 'e.g. 4200',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: AppTextField(label: 'Notes', controller: _notes, hint: 'optional')),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _pickAttachment,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.line)),
              child: Row(
                children: [
                  Icon(_attachment == null ? Icons.attach_file : Icons.check_circle_outline,
                      size: 20, color: _attachment == null ? AppColors.ink2 : AppColors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_attachment?.name ?? 'Attach document',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                        const Text('Insurance policy, receipt, photo…',
                            style: TextStyle(fontSize: 12, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.muted),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          PrimaryButton(
              label: _isEdit ? 'Save Changes' : 'Save Reminder',
              isLoading: _saving,
              onPressed: () => _save(offsets)),
        ],
      ),
    );
  }
}

class _TypeTile extends StatelessWidget {
  const _TypeTile({required this.kind, required this.selected, required this.onTap});
  final ReminderKind kind;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.chipBlue : AppColors.line, width: selected ? 2 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: kind.bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(kind.icon, size: 18, color: kind.fg),
            ),
            const SizedBox(height: 6),
            Text(kind.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink)),
          ],
        ),
      ),
    );
  }
}
