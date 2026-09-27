import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../core/media/picked_media.dart';
import '../../../core/widgets/feedback.dart';
import '../application/document_providers.dart';
import '../domain/document_models.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

/// Icon for a non-image attachment by file extension / MIME type; the
/// generic "unknown file" icon when the type isn't recognised.
IconData fileTypeIcon(String name, [String? mime]) => switch (fileExtension(name)) {
      'pdf' => Icons.picture_as_pdf_outlined,
      'doc' || 'docx' || 'rtf' || 'odt' => Icons.description_outlined,
      'xls' || 'xlsx' || 'csv' || 'ods' => Icons.table_chart_outlined,
      'ppt' || 'pptx' => Icons.slideshow_outlined,
      'txt' || 'md' => Icons.notes_outlined,
      'zip' || 'rar' || '7z' || 'gz' => Icons.folder_zip_outlined,
      'mp3' || 'wav' || 'm4a' || 'aac' || 'ogg' => Icons.audiotrack_outlined,
      'mp4' || 'mov' || 'mkv' || 'avi' || 'webm' => Icons.videocam_outlined,
      _ => switch (mime?.split('/').firstOrNull) {
          'audio' => Icons.audiotrack_outlined,
          'video' => Icons.videocam_outlined,
          'text' => Icons.notes_outlined,
          _ => Icons.insert_drive_file_outlined, // unknown type
        },
    };

extension DocKindStyle on DocKind {
  String displayName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      DocKind.invoice => l.docKindInvoice,
      DocKind.warranty => l.docKindWarranty,
      DocKind.insurance => l.docKindInsurance,
      DocKind.manual => l.docKindManual,
      DocKind.photo => l.docKindPhoto,
      DocKind.other => l.docKindOther,
    };
  }

  IconData get icon => switch (this) {
        DocKind.invoice => Icons.receipt_long_outlined,
        DocKind.warranty => Icons.verified_outlined,
        DocKind.insurance => Icons.shield_outlined,
        DocKind.manual => Icons.menu_book_outlined,
        DocKind.photo => Icons.image_outlined,
        DocKind.other => Icons.description_outlined,
      };
}

/// Shares raw bytes as a file via the platform share sheet.
Future<void> shareBytes(Uint8List bytes, {required String name, required String mime}) {
  return SharePlus.instance.share(ShareParams(
    files: [XFile.fromData(bytes, mimeType: mime, name: name)],
    fileNameOverrides: [name],
  ));
}

/// Downloads a stored document and opens the share sheet.
Future<void> shareDocument(BuildContext context, WidgetRef ref, DocumentMeta doc) => runAction(context, () async {
      final bytes = await ref.read(assetDocumentsControllerProvider(doc.assetId)).download(doc);
      await shareBytes(bytes, name: doc.title, mime: doc.mimeType);
    });

/// Opens a stored document: images in the in-app viewer, everything else in
/// the platform viewer for its type.
Future<void> openDocument(BuildContext context, WidgetRef ref, DocumentMeta doc) => runAction(context, () async {
      final url = await ref.read(assetDocumentsControllerProvider(doc.assetId)).viewUrl(doc);
      if (!context.mounted) return;
      if (doc.isImage) {
        ImageViewerPage.open(context, title: doc.title, url: url, onShare: () => shareDocument(context, ref, doc));
      } else {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    });

/// Full-page image viewer: pinch-zoom / pan / double-tap zoom on a dark
/// canvas, with the file name in the bar. Works from a URL (stored
/// documents) or raw bytes (attachments not yet uploaded).
class ImageViewerPage extends StatefulWidget {
  const ImageViewerPage({super.key, required this.title, this.url, this.bytes, this.onShare})
      : assert(url != null || bytes != null, 'Provide a url or bytes');

  final String title;
  final String? url;
  final Uint8List? bytes;

  /// Shown as a share action in the bar when provided (or when [bytes] is
  /// set, which shares the bytes directly).
  final Future<void> Function()? onShare;

  static void open(BuildContext context,
      {required String title, String? url, Uint8List? bytes, Future<void> Function()? onShare}) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => ImageViewerPage(title: title, url: url, bytes: bytes, onShare: onShare)),
    );
  }

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  final _controller = TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_controller.value != Matrix4.identity()) {
      _controller.value = Matrix4.identity();
      return;
    }
    final position = _doubleTapDetails?.localPosition;
    if (position == null) return;
    _controller.value = Matrix4.identity()
      ..translateByDouble(-position.dx * 1.5, -position.dy * 1.5, 0, 1)
      ..scaleByDouble(2.5, 2.5, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.bytes != null
        ? Image.memory(widget.bytes!, fit: BoxFit.contain)
        : Image.network(
            widget.url!,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const Center(child: CircularProgressIndicator(color: Colors.white70)),
            errorBuilder: (context, _, _) => Center(
                child: Text(context.l10n.docsImageLoadFailed, style: const TextStyle(color: Colors.white70))),
          );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        actions: [
          if (widget.onShare != null || widget.bytes != null)
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.white),
              onPressed: () => widget.onShare != null
                  ? widget.onShare!()
                  : shareBytes(widget.bytes!,
                      name: widget.title, mime: 'image/${widget.title.split('.').last}'),
            ),
        ],
      ),
      body: GestureDetector(
        onDoubleTapDown: (d) => _doubleTapDetails = d,
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _controller,
          minScale: 0.8,
          maxScale: 6,
          child: Center(child: image),
        ),
      ),
    );
  }
}

/// Square thumbnail for a stored document: the image itself when it's an
/// image (tap → [ImageViewerPage]), else the file-type icon.
class DocumentThumb extends ConsumerWidget {
  const DocumentThumb({super.key, required this.doc, this.size = 40, this.radius = 12});

  final DocumentMeta doc;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconBox = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: context.palette.background, borderRadius: BorderRadius.circular(radius)),
      child: Icon(fileTypeIcon(doc.title, doc.mimeType),
          color: context.palette.textSecondary, size: size.isFinite ? size * 0.5 : 30),
    );
    if (!doc.isImage) return iconBox;

    final url = ref.watch(documentUrlProvider(doc)).value;
    if (url == null) return iconBox;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, _, _) => iconBox,
      ),
    );
  }
}

/// Grid of not-yet-uploaded attachments ([PickedMedia]): image thumbnails
/// (tap → viewer) or file-type icons, each with a remove button.
class PickedMediaGrid extends StatelessWidget {
  const PickedMediaGrid({super.key, required this.files, required this.onRemove});

  final List<PickedMedia> files;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var i = 0; i < files.length; i++) _tile(context, i),
      ],
    );
  }

  Widget _tile(BuildContext context, int i) {
    final f = files[i];
    final image = isImageFileName(f.name);
    return SizedBox(
      width: 86,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: image ? () => ImageViewerPage.open(context, title: f.name, bytes: f.bytes) : null,
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: context.palette.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.palette.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: image
                      ? Image.memory(f.bytes, fit: BoxFit.cover)
                      : Icon(fileTypeIcon(f.name), color: context.palette.textSecondary, size: 30),
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: InkWell(
                  onTap: () => onRemove(i),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: context.palette.inverseSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.palette.onInverse, width: 1.5),
                    ),
                    child: Icon(Icons.close, size: 12, color: context.palette.onInverse),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(f.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.5, color: context.palette.textMuted)),
        ],
      ),
    );
  }
}

/// Grid of stored documents: image thumbnails or file-type icons, title +
/// size, and a ⋮ menu (View / Share / optional Delete).
class DocumentGrid extends ConsumerWidget {
  const DocumentGrid({super.key, required this.assetId, required this.docs, this.canDelete = false});

  final String assetId;
  final List<DocumentMeta> docs;
  final bool canDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth < 360 ? 2 : 3;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.82),
          itemCount: docs.length,
          itemBuilder: (context, i) => _DocCard(
            doc: docs[i],
            onTap: () => openDocument(context, ref, docs[i]),
            onShare: () => shareDocument(context, ref, docs[i]),
            onDelete: canDelete
                ? () => runAction(context, () => ref.read(assetDocumentsControllerProvider(assetId)).delete(docs[i]))
                : null,
          ),
        );
      },
    );
  }
}

class _DocCard extends ConsumerWidget {
  const _DocCard({required this.doc, required this.onTap, required this.onShare, this.onDelete});
  final DocumentMeta doc;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: context.palette.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.palette.border)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: DocumentThumb(doc: doc, size: double.infinity, radius: 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 2, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.palette.text)),
                        Text('${doc.kind.displayName(context)} · ${formatBytes(doc.sizeBytes)}',
                            style: TextStyle(fontSize: 10.5, color: context.palette.textMuted)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 28,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.more_vert, size: 17, color: context.palette.textMuted),
                      onSelected: (v) {
                        if (v == 'view') onTap();
                        if (v == 'share') onShare();
                        if (v == 'delete') onDelete?.call();
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'view', child: Text(context.l10n.commonView)),
                        PopupMenuItem(value: 'share', child: Text(context.l10n.commonShare)),
                        if (onDelete != null)
                          PopupMenuItem(
                              value: 'delete',
                              child: Text(context.l10n.commonDelete, style: TextStyle(color: context.palette.danger))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
