import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/media/media_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../application/document_providers.dart';
import '../data/document_models.dart';

const _imageExts = {'jpg', 'jpeg', 'png', 'webp', 'heic', 'gif', 'bmp'};

bool isImageName(String name) {
  final dot = name.lastIndexOf('.');
  return dot >= 0 && _imageExts.contains(name.substring(dot + 1).toLowerCase());
}

bool isImageMime(String mime) => mime.startsWith('image/');

/// Icon for a non-image attachment by file extension / MIME type; the
/// generic "unknown file" icon when the type isn't recognised.
IconData fileTypeIcon(String name, [String? mime]) {
  final dot = name.lastIndexOf('.');
  final ext = dot < 0 ? '' : name.substring(dot + 1).toLowerCase();
  return switch (ext) {
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
}

/// Full-page image viewer: pinch-zoom / pan / double-tap zoom on a dark
/// canvas, with the file name in the bar. Works from a URL (stored
/// documents) or raw bytes (attachments not yet uploaded).
class ImageViewerPage extends StatefulWidget {
  const ImageViewerPage({super.key, required this.title, this.url, this.bytes})
      : assert(url != null || bytes != null, 'Provide a url or bytes');

  final String title;
  final String? url;
  final Uint8List? bytes;

  static void open(BuildContext context, {required String title, String? url, Uint8List? bytes}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ImageViewerPage(title: title, url: url, bytes: bytes)),
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
            errorBuilder: (context, _, _) => const Center(
                child: Text('Could not load image', style: TextStyle(color: Colors.white70))),
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
      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(radius)),
      child: Icon(fileTypeIcon(doc.title, doc.mimeType), color: AppColors.ink2, size: size * 0.5),
    );
    if (!isImageMime(doc.mimeType) && !isImageName(doc.title)) return iconBox;

    final url = ref.watch(documentUrlProvider(doc)).valueOrNull;
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
    final image = isImageName(f.name);
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
                    color: AppColors.paper,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.line),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: image
                      ? Image.memory(f.bytes, fit: BoxFit.cover)
                      : Icon(fileTypeIcon(f.name), color: AppColors.ink2, size: 30),
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
                      color: AppColors.ink,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.close, size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(f.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
        ],
      ),
    );
  }
}
