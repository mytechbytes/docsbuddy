import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/widgets/feedback.dart';
import '../application/document_providers.dart';
import 'attachment_widgets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

class AssetDocumentsSection extends ConsumerStatefulWidget {
  const AssetDocumentsSection({super.key, required this.assetId});
  final String assetId;

  @override
  ConsumerState<AssetDocumentsSection> createState() => _AssetDocumentsSectionState();
}

class _AssetDocumentsSectionState extends ConsumerState<AssetDocumentsSection> {
  bool _busy = false;

  /// Camera scan, gallery multi-select, or file browser multi-select —
  /// every picked file is uploaded.
  Future<void> _add() async {
    final files = await pickDocuments(context);
    if (files.isEmpty || !mounted) return;
    setState(() => _busy = true);
    await runAction(context, () => ref.read(assetDocumentsControllerProvider(widget.assetId)).attach(files));
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final docs = ref.watch(assetDocumentsProvider(widget.assetId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.docsTitle, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.textMuted, letterSpacing: 1)),
            _busy
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : GestureDetector(
                    onTap: _add,
                    child: Text(context.l10n.docsAdd, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.accent)),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        docs.when(
          loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
          error: (e, _) => Text(context.failureText(e), style: TextStyle(color: context.palette.textMuted)),
          data: (list) => list.isEmpty
              ? Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(context.l10n.docsEmpty, style: TextStyle(color: context.palette.textMuted)))
              : DocumentGrid(assetId: widget.assetId, docs: list, canDelete: true),
        ),
      ],
    );
  }
}
