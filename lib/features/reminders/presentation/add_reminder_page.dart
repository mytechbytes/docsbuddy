import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/step_flow.dart';
import '../../documents/presentation/attachment_widgets.dart';
import '../../settings/application/settings_providers.dart';
import '../../settings/domain/notification_prefs.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_inputs.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/widgets/catalog_widgets.dart';
import '../application/reminder_editor_controller.dart';
import 'widgets/reminder_kind_tile.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isEdit && _label.text.isEmpty) _label.text = _kind.displayName(context);
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
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.palette.text),
        title: Text(
          _isEdit ? context.l10n.reminderEditTitle : context.l10n.reminderAddTitle,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: context.palette.text),
        ),
        actions: [
          IconButton(icon: Icon(Icons.close, color: context.palette.text), onPressed: () => Navigator.of(context).pop()),
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
                  TextSpan(text: context.l10n.reminderFor, children: [
                    TextSpan(text: asset.name, style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
                  ]),
                  style: TextStyle(fontSize: 13, color: context.palette.textMuted),
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
                nextLabel: _step < _stepAttach
                    ? context.l10n.commonNext
                    : (_isEdit ? context.l10n.reminderSaveChanges : context.l10n.reminderSave),
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
      StepHeader(step: 0, total: _total, title: context.l10n.reminderTypeTitle, subtitle: context.l10n.reminderTypeSubtitle),
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
            ReminderKindTile(
              kind: k,
              selected: _kind == k,
              onTap: () => setState(() {
                if (_kind != k) {
                  _kind = k;
                  _label.text = k.displayName(context);
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
      StepHeader(
          step: 1,
          total: _total,
          title: context.l10n.reminderDetailsTitle(_kind.displayName(context)),
          subtitle: context.l10n.reminderDetailsSubtitle),
      const SizedBox(height: 16),
      AppTextField(
          label: context.l10n.reminderLabel, controller: _label, icon: Icons.label_outline, hint: _kind.displayName(context)),
      const SizedBox(height: 14),
      Text(context.l10n.reminderDueDate, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.text)),
      const SizedBox(height: 6),
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _pickDate,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.palette.fieldBorder, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(Icons.event_outlined, size: 18, color: context.palette.textMuted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(context.formatNumericDate(_due),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.palette.text)),
              ),
              Text(
                relativeDays(context.l10n, calendarDaysBetween(DateTime.now(), _due)),
                style: TextStyle(fontSize: 12, color: context.palette.textMuted),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      Text(context.l10n.reminderRepeats, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.text)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final r in Recurrence.values)
            ChoiceChip(
              selected: _recurrence == r,
              onSelected: (_) => setState(() => _recurrence = r),
              label: Text(r == Recurrence.none ? context.l10n.recurrenceNever : r.displayName(context)),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: _recurrence == r ? context.palette.onInverse : context.palette.textSecondary),
              selectedColor: context.palette.inverseSurface,
              backgroundColor: context.palette.surface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999), side: BorderSide(color: context.palette.border)),
            ),
        ],
      ),
      const SizedBox(height: 16),
      Text(context.l10n.reminderServiceDetails,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.text)),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(child: AppTextField(label: context.l10n.catalogProvider, controller: _provider, hint: context.l10n.reminderProviderHint)),
          const SizedBox(width: 12),
          Expanded(child: AppTextField(label: context.l10n.reminderPolicyNo, controller: _policyNo, hint: context.l10n.commonOptional)),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: AppTextField(
              label: context.l10n.catalogCost,
              controller: _cost,
              hint: context.l10n.reminderCostHint,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: AppTextField(label: context.l10n.catalogNotes, controller: _notes, hint: context.l10n.commonOptional)),
        ],
      ),
    ];
  }

  // ── Step 3: notification settings ──
  List<Widget> _notifyStep(Set<int> offsets) {
    return [
      StepHeader(
          step: 2,
          total: _total,
          title: context.l10n.reminderNotifyTitle,
          subtitle: context.l10n.reminderNotifySubtitle),
      const SizedBox(height: 16),
      Text(context.l10n.reminderNotifyMe, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.text)),
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
              label: Text(context.l10n.settingsDaysBefore(d)),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: offsets.contains(d) ? Colors.white : context.palette.textSecondary),
              selectedColor: context.palette.accent,
              checkmarkColor: Colors.white,
              backgroundColor: context.palette.surface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999), side: BorderSide(color: context.palette.border)),
            ),
        ],
      ),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: context.palette.accentSoft, borderRadius: BorderRadius.circular(12)),
        child: Text(
          offsets.isEmpty
              ? context.l10n.reminderNoOffsets
              : context.l10n.reminderOffsetsSummary(sortedOffsets(offsets).map(context.l10n.durationDaysShort).join(', ')),
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: context.palette.accent),
        ),
      ),
    ];
  }

  // ── Step 4: attachments ──
  List<Widget> _attachStep() {
    return [
      StepHeader(
          step: 3,
          total: _total,
          title: context.l10n.reminderAttachTitle,
          subtitle: context.l10n.reminderAttachSubtitle),
      const SizedBox(height: 16),
      PickedMediaGrid(files: _attachments, onRemove: (i) => setState(() => _attachments.removeAt(i))),
      if (_attachments.isNotEmpty) const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: _pickAttachment,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: context.palette.fieldBorder, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(Icons.attach_file, size: 18, color: context.palette.textSecondary),
        label: Text(context.l10n.reminderAttachDocs,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.palette.text)),
      ),
    ];
  }
}
