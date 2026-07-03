import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../application/document_providers.dart';
import 'attachment_widgets.dart';
import '../data/document_models.dart';

DocKind _kindFor(String? ext) =>
    {'jpg', 'jpeg', 'png', 'webp', 'heic'}.contains(ext?.toLowerCase()) ? DocKind.photo : DocKind.other;

class AssetDocumentsSection extends ConsumerStatefulWidget {
  const AssetDocumentsSection({super.key, required this.assetId});
  final String assetId;

  @override
  ConsumerState<AssetDocumentsSection> createState() => _AssetDocumentsSectionState();
}

class _AssetDocumentsSectionState extends ConsumerState<AssetDocumentsSection> {
  bool _busy = false;

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg), backgroundColor: error ? AppColors.red : AppColors.green));
  }

  /// Camera scan, gallery multi-select, or file browser multi-select —
  /// every picked file is uploaded.
  Future<void> _add() async {
    final files = await pickDocuments(context);
    if (files.isEmpty) return;
    setState(() => _busy = true);
    var failed = 0;
    for (final f in files) {
      try {
        await ref.read(documentRepositoryProvider).upload(
              assetId: widget.assetId,
              fileName: f.name,
              bytes: f.bytes,
              mimeType: f.docMime,
              kind: _kindFor(f.extension),
            );
      } catch (_) {
        failed++;
      }
    }
    ref.invalidate(assetDocumentsProvider(widget.assetId));
    if (mounted) {
      setState(() => _busy = false);
      if (failed > 0) _snack('$failed of ${files.length} uploads failed.', error: true);
    }
  }

  /// Opens a non-image document in the platform's viewer for its type.
  Future<void> _open(DocumentMeta doc) async {
    final url = await ref.read(documentRepositoryProvider).viewUrl(doc);
    if (!mounted) return;
    if (url == null) {
      _snack('Connect Supabase to open files.', error: true);
      return;
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> _delete(DocumentMeta doc) async {
    try {
      await ref.read(documentRepositoryProvider).delete(doc);
      ref.invalidate(assetDocumentsProvider(widget.assetId));
    } catch (e) {
      if (mounted) _snack('Delete failed: $e', error: true);
    }
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
            const Text('DOCUMENTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
            _busy
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : GestureDetector(
                    onTap: _add,
                    child: const Text('+ Add', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.chipBlue)),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        docs.when(
          loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
          error: (e, _) => Text('$e', style: const TextStyle(color: AppColors.muted)),
          data: (list) => list.isEmpty
              ? const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text('No documents yet. Attach invoices, warranties or photos.', style: TextStyle(color: AppColors.muted)))
              : DocumentGrid(docs: list, onOpen: _open, onDelete: _delete),
        ),
      ],
    );
  }
}
