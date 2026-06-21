import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../application/document_providers.dart';
import '../data/document_models.dart';

String _mimeFor(String? ext) => switch (ext?.toLowerCase()) {
      'pdf' => 'application/pdf',
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      'doc' => 'application/msword',
      'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      _ => 'application/octet-stream',
    };

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

  Future<void> _add() async {
    final res = await FilePicker.platform.pickFiles(withData: true);
    if (res == null || res.files.isEmpty) return;
    final f = res.files.first;
    final bytes = f.bytes;
    if (bytes == null) {
      _snack('Could not read that file.', error: true);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(documentRepositoryProvider).upload(
            assetId: widget.assetId,
            fileName: f.name,
            bytes: bytes,
            mimeType: _mimeFor(f.extension),
            kind: _kindFor(f.extension),
          );
      ref.invalidate(assetDocumentsProvider(widget.assetId));
    } catch (e) {
      if (mounted) _snack('Upload failed: $e', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _view(DocumentMeta doc) async {
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
              : Column(children: [for (final d in list) _DocTile(doc: d, onView: () => _view(d), onDelete: () => _delete(d))]),
        ),
      ],
    );
  }
}

class _DocTile extends StatelessWidget {
  const _DocTile({required this.doc, required this.onView, required this.onDelete});
  final DocumentMeta doc;
  final VoidCallback onView;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onView,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
              child: Icon(doc.kind.icon, color: AppColors.ink2, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  Text('${doc.kind.label} · ${doc.prettySize}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.muted),
              onSelected: (v) => v == 'view' ? onView() : onDelete(),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'view', child: Text('View')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
