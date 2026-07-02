import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/catalog_widgets.dart';
import '../../../core/widgets/db_logo.dart';
import '../../documents/presentation/asset_documents_section.dart';
import '../application/catalog_providers.dart';
import '../data/catalog_models.dart';

class AssetDetailPage extends ConsumerWidget {
  const AssetDetailPage({super.key, required this.assetId});
  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetProvider(assetId));
    final reminders = ref.watch(assetRemindersProvider(assetId));
    final list = reminders.valueOrNull ?? const <Reminder>[];
    final next = _soonest(list);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const DbLogo(size: 18),
        actions: const [
          Icon(Icons.notifications_none, color: AppColors.ink2, size: 22),
          SizedBox(width: 14),
          _Avatar(),
          SizedBox(width: 16),
        ],
      ),
      body: asset.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (a) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            _InfoCard(asset: a, reminderCount: list.length, onChangePhoto: () => _changePhoto(context, ref, a)),
            const SizedBox(height: 16),
            if (next != null) ...[
              _NextDueBanner(reminder: next),
              const SizedBox(height: 20),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Reminders · ${list.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                _AddPill(onTap: () => _addReminder(context, ref, a)),
              ],
            ),
            const SizedBox(height: 12),
            reminders.when(
              loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Text('$e'),
              data: (rs) => rs.isEmpty
                  ? const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: Text('No reminders for this asset yet.', style: TextStyle(color: AppColors.muted))))
                  : Column(children: [
                      for (final r in rs) _ReminderRow(reminder: r, onComplete: () => _complete(context, ref, r)),
                    ]),
            ),
            const SizedBox(height: 22),
            AssetDocumentsSection(assetId: a.id),
          ],
        ),
      ),
    );
  }

  /// The most urgent reminder (smallest days-left, overdue first).
  static Reminder? _soonest(List<Reminder> list) {
    if (list.isEmpty) return null;
    final sorted = [...list]..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
    return sorted.first;
  }

  /// Picks an image and uploads it as the asset's photo.
  Future<void> _changePhoto(BuildContext context, WidgetRef ref, Asset asset) async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    final f = res?.files.firstOrNull;
    final bytes = f?.bytes;
    if (f == null || bytes == null) return;
    try {
      await ref.read(catalogRepositoryProvider).setAssetImage(
            asset.id,
            bytes: bytes,
            fileName: f.name,
            mimeType: _imageMime(f.extension),
          );
      ref.invalidate(assetProvider(assetId));
      refreshCatalog(ref);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Photo upload failed: $e'), backgroundColor: AppColors.red));
      }
    }
  }

  static String _imageMime(String? ext) => switch (ext?.toLowerCase()) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        'gif' => 'image/gif',
        _ => 'image/jpeg',
      };

  /// Marks a service done — recurring ones roll their due date forward.
  Future<void> _complete(BuildContext context, WidgetRef ref, Reminder r) async {
    await ref.read(catalogRepositoryProvider).completeReminder(r.id);
    ref.invalidate(assetRemindersProvider(assetId));
    refreshCatalog(ref);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(r.recurrence == Recurrence.none
            ? '${r.label} marked as done.'
            : '${r.label} done — next due date scheduled.'),
        backgroundColor: AppColors.green,
      ));
    }
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

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Color(0xFFF1C27D), Color(0xFFD68B5C)]),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 17),
    );
  }
}

class _AddPill extends StatelessWidget {
  const _AddPill({required this.onTap});
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.asset, required this.reminderCount, required this.onChangePhoto});
  final Asset asset;
  final int reminderCount;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    final meta = [
      '$reminderCount reminder${reminderCount == 1 ? '' : 's'} tracked',
      if (asset.brand != null) asset.brand,
      if (asset.model != null) asset.model,
      if (asset.serialNo != null) asset.serialNo,
    ].whereType<String>().join(' · ');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
      child: Row(
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
                Align(alignment: Alignment.centerLeft, child: CategoryChip(asset.category.label)),
                const SizedBox(height: 8),
                Text(meta, style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Red "next due" banner highlighting the most urgent reminder.
class _NextDueBanner extends StatelessWidget {
  const _NextDueBanner({required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final d = reminder.daysLeft;
    final phrase = d < 0
        ? 'Overdue by ${-d} day${d == -1 ? '' : 's'}'
        : d == 0
            ? 'Due today'
            : '$d day${d == 1 ? '' : 's'} left';
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

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({required this.reminder, required this.onComplete});
  final Reminder reminder;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final service = [
      if (reminder.provider != null) reminder.provider,
      if (reminder.policyNo != null) reminder.policyNo,
    ].whereType<String>().join(' · ');
    return Container(
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
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_vert, size: 18, color: AppColors.muted),
            onSelected: (_) => onComplete(),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'done', child: Text('Mark as done')),
            ],
          ),
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
  final _provider = TextEditingController();
  final _policyNo = TextEditingController();
  final _cost = TextEditingController();
  final _notes = TextEditingController();
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
    _provider.dispose();
    _policyNo.dispose();
    _cost.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _text(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

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
          provider: _text(_provider),
          policyNo: _text(_policyNo),
          cost: double.tryParse(_cost.text.trim().replaceAll(',', '')),
          notes: _text(_notes),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
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
              const SizedBox(height: 16),
              const Text('Service details (optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
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
