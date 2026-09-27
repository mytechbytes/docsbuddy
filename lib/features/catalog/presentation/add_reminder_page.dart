import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/step_flow.dart';
import '../../documents/presentation/attachment_widgets.dart';
import '../../settings/application/settings_providers.dart';
import '../../settings/domain/notification_prefs.dart';
import '../application/catalog_providers.dart';
import '../application/editor_controllers.dart';
import '../domain/catalog_inputs.dart';
import '../domain/catalog_models.dart';
import 'widgets/catalog_widgets.dart';

/// Design screen 08 — Add Reminder as a 4-step flow:
///   1. Reminder type
///   2. Details — due date, repeats, provider / policy / cost / notes
///   3. Notification settings — notify-before offsets
///   4. Attachments — camera / gallery / files, with thumbnails
class AddReminderPage extends ConsumerStatefulWidget {
  const AddReminderPage({super.key, required this.assetId, this.editing});
  final String assetId;

  /// When set, the page edits this service instead of creating one.
  final Reminder? editing;

  @override
  ConsumerState<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends ConsumerState<AddReminderPage> {
  static const _stepType = 0;
  static const _stepDetails = 1;
  static const _stepNotify = 2;
  static const _stepAttach = 3;
  static const _total = 4;

  int _step = _stepType;

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
  final _attachments = <PickedMedia>[];

  bool get _isEdit => widget.editing != null;

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
    final picked = await pickDocuments(context);
    if (picked.isNotEmpty) setState(() => _attachments.addAll(picked));
  }

  Future<void> _save(Set<int> offsets) async {
    final draft = ReminderDraft(
      kind: _kind,
      dueDate: _due,
      recurrence: _recurrence,
      notifyOffsets: offsets,
      label: _label.text,
      provider: _provider.text,
      policyNo: _policyNo.text,
      cost: _cost.text,
      notes: _notes.text,
    );
    final ok = await runAction(
      context,
      () => ref.read(reminderEditorControllerProvider.notifier).save(
            assetId: widget.assetId,
            draft: draft,
            editing: widget.editing,
            attachments: _attachments,
          ),
    );
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final asset = ref.watch(assetProvider(widget.assetId)).value;
    final defaultOffsets = ref.watch(defaultNotifyOffsetsProvider);
    final offsets = _offsets ?? defaultOffsets.toSet();
    final saving = ref.watch(reminderEditorControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: Text(
          _isEdit ? 'Edit Reminder' : 'Add Reminder',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.close, color: AppColors.ink), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
      body: Column(
        children: [
          if (asset != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(text: 'For ', children: [
                    TextSpan(text: asset.name, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
                  ]),
                  style: const TextStyle(fontSize: 13, color: AppColors.muted),
                ),
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              children: switch (_step) {
                _stepType => _typeStep(),
                _stepDetails => _detailsStep(),
                _stepNotify => _notifyStep(offsets),
                _ => _attachStep(),
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: StepNav(
                step: _step,
                busy: saving,
                nextLabel: _step < _stepAttach ? 'Next' : (_isEdit ? 'Save Changes' : 'Save Reminder'),
                onBack: () => setState(() => _step--),
                onNext: () {
                  if (_step < _stepAttach) {
                    setState(() => _step++);
                  } else {
                    _save(offsets);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 1: reminder type ──
  List<Widget> _typeStep() {
    return [
      const StepHeader(step: 0, total: _total, title: 'Reminder type', subtitle: 'What should we track?'),
      const SizedBox(height: 16),
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
                if (_kind != k) {
                  _kind = k;
                  _label.text = k.label;
                }
                _step = _stepDetails;
              }),
            ),
        ],
      ),
    ];
  }

  // ── Step 2: details ──
  List<Widget> _detailsStep() {
    return [
      StepHeader(step: 1, total: _total, title: '${_kind.label} details', subtitle: 'When is it due?'),
      const SizedBox(height: 16),
      AppTextField(label: 'Label', controller: _label, icon: Icons.label_outline, hint: _kind.label),
      const SizedBox(height: 14),
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
                relativeDays(calendarDaysBetween(DateTime.now(), _due)),
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
    ];
  }

  // ── Step 3: notification settings ──
  List<Widget> _notifyStep(Set<int> offsets) {
    return [
      const StepHeader(
          step: 2,
          total: _total,
          title: 'Notification settings',
          subtitle: 'Push notification & reminder to all family members.'),
      const SizedBox(height: 16),
      const Text('Notify me', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final d in notifyOffsetOptions)
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
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFEEF3FB), borderRadius: BorderRadius.circular(12)),
        child: Text(
          offsets.isEmpty
              ? 'No reminders will fire for this service — pick at least one offset to be notified.'
              : 'You\'ll be reminded ${sortedOffsets(offsets).map((d) => '${d}d').join(', ')} before the due date, on your enabled channels (see Settings).',
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.chipBlue),
        ),
      ),
    ];
  }

  // ── Step 4: attachments ──
  List<Widget> _attachStep() {
    return [
      const StepHeader(
          step: 3,
          total: _total,
          title: 'Attachments',
          subtitle: 'Policy PDF, receipt, photos… attach now or later from the asset page.'),
      const SizedBox(height: 16),
      PickedMediaGrid(files: _attachments, onRemove: (i) => setState(() => _attachments.removeAt(i))),
      if (_attachments.isNotEmpty) const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: _pickAttachment,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: AppColors.fieldBorder, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.attach_file, size: 18, color: AppColors.ink2),
        label: const Text('Attach documents — camera, gallery or files',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
      ),
    ];
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
