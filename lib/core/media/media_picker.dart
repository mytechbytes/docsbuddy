import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_colors.dart';
import 'picked_media.dart';

export 'picked_media.dart';

Future<PickedMedia?> _fromXFile(XFile? f) async =>
    f == null ? null : PickedMedia(name: f.name, bytes: await f.readAsBytes());

/// Picks ONE image: camera capture, gallery, or the file browser.
/// Used everywhere a photo is set (asset/room photos, avatar).
Future<PickedMedia?> pickImage(BuildContext context) async {
  final source = await _showSourceSheet(context, const [
    _SourceOption('camera', Icons.photo_camera_outlined, 'Take photo'),
    _SourceOption('gallery', Icons.photo_library_outlined, 'Choose from gallery'),
    _SourceOption('files', Icons.folder_open_outlined, 'Browse files'),
  ]);
  switch (source) {
    case 'camera':
      return _fromXFile(await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 88));
    case 'gallery':
      return _fromXFile(await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 92));
    case 'files':
      final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
      final f = res?.files.firstOrNull;
      return f?.bytes == null ? null : PickedMedia(name: f!.name, bytes: f.bytes!);
  }
  return null;
}

/// Picks one or more documents: camera scan (single shot), gallery photos
/// (multi-select) or the file browser (multi-select — PDFs, images, docs).
Future<List<PickedMedia>> pickDocuments(BuildContext context) async {
  final source = await _showSourceSheet(context, const [
    _SourceOption('camera', Icons.document_scanner_outlined, 'Scan with camera'),
    _SourceOption('gallery', Icons.photo_library_outlined, 'Photos from gallery'),
    _SourceOption('files', Icons.folder_open_outlined, 'Browse files'),
  ]);
  switch (source) {
    case 'camera':
      final shot = await _fromXFile(await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 88));
      return [?shot];
    case 'gallery':
      final picked = await ImagePicker().pickMultiImage(imageQuality: 92);
      return [for (final f in picked) PickedMedia(name: f.name, bytes: await f.readAsBytes())];
    case 'files':
      final res = await FilePicker.platform.pickFiles(withData: true, allowMultiple: true);
      return [
        for (final f in res?.files ?? const <PlatformFile>[])
          if (f.bytes != null) PickedMedia(name: f.name, bytes: f.bytes!),
      ];
  }
  return const [];
}

class _SourceOption {
  const _SourceOption(this.key, this.icon, this.label);
  final String key;
  final IconData icon;
  final String label;
}

Future<String?> _showSourceSheet(BuildContext context, List<_SourceOption> options) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.paper,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(999)),
          ),
          const SizedBox(height: 8),
          for (final o in options)
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
                child: Icon(o.icon, size: 20, color: AppColors.ink2),
              ),
              title: Text(o.label,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.ink)),
              onTap: () => Navigator.of(context).pop(o.key),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
