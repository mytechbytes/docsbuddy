import 'dart:typed_data';

import 'package:docsbuddy/core/media/picked_media.dart';
import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:docsbuddy/features/documents/presentation/asset_documents_section.dart';
import 'package:docsbuddy/features/documents/presentation/attachment_widgets.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../support/demo_data.dart';
import '../support/demo_images.dart';
import '../support/scenario.dart';
import '../support/use_cases.dart';

WidgetbookFolder documentWidgets() => WidgetbookFolder(
      name: 'Documents',
      children: [
        WidgetbookComponent(name: 'fileTypeIcon', useCases: [
          gallery('Icon by file type', [
            Builder(
              builder: (context) => Wrap(spacing: 16, runSpacing: 16, children: [
                for (final name in const [
                  'invoice.pdf',
                  'notes.docx',
                  'budget.xlsx',
                  'deck.pptx',
                  'readme.md',
                  'backup.zip',
                  'voice.m4a',
                  'clip.mp4',
                  'mystery.xyz',
                ])
                  SizedBox(
                    width: 84,
                    child: Column(children: [
                      Icon(fileTypeIcon(name), size: 30, color: context.palette.textSecondary),
                      const SizedBox(height: 6),
                      Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: context.palette.textMuted)),
                    ]),
                  ),
              ]),
            ),
          ]),
        ]),
        WidgetbookComponent(name: 'DocumentThumb', useCases: [
          component(
            'Playground',
            (context) => DocumentThumb(
              doc: demoDocuments[context.knobs.int.slider(label: 'Document', initialValue: 0, min: 0, max: demoDocuments.length - 1)],
              size: context.knobs.double.slider(label: 'Size', initialValue: 64, min: 24, max: 160),
              radius: context.knobs.double.slider(label: 'Radius', initialValue: 12, min: 0, max: 40),
            ),
          ),
          gallery('Each kind of file', [
            Wrap(spacing: 14, runSpacing: 14, children: [for (final d in demoDocuments) DocumentThumb(doc: d, size: 64)]),
          ]),
        ]),
        WidgetbookComponent(name: 'PickedMediaGrid', useCases: [
          component(
            'Ready to upload',
            (_) => Interactive<List<PickedMedia>>(
              initial: [
                PickedMedia(name: 'front.png', bytes: demoPhotoWarm),
                PickedMedia(name: 'invoice.pdf', bytes: Uint8List(0)),
                PickedMedia(name: 'rating-plate.png', bytes: demoPhotoCool),
                PickedMedia(name: 'a-very-long-file-name-for-the-warranty-card.pdf', bytes: Uint8List(0)),
              ],
              builder: (context, files, set) => PickedMediaGrid(
                files: files,
                onRemove: (i) => set([...files]..removeAt(i)),
              ),
            ),
            alignment: Alignment.topCenter,
          ),
          component('Nothing picked', (_) => const PickedMediaGrid(files: [], onRemove: _ignore)),
        ]),
        WidgetbookComponent(name: 'DocumentGrid', useCases: [
          component(
            'Read-only',
            (_) => DocumentGrid(assetId: 'a-demo', docs: demoDocuments),
            alignment: Alignment.topCenter,
          ),
          component(
            'Can delete',
            (_) => DocumentGrid(assetId: 'a-demo', docs: demoDocuments, canDelete: true),
            alignment: Alignment.topCenter,
          ),
          component(
            'One document',
            (_) => DocumentGrid(assetId: 'a-demo', docs: [demoDocuments.first]),
            alignment: Alignment.topCenter,
          ),
        ]),
        WidgetbookComponent(name: 'AssetDocumentsSection', useCases: [
          for (final s in Scenario.values)
            component(
              s.label,
              (_) => const AssetDocumentsSection(assetId: 'a-demo'),
              alignment: Alignment.topCenter,
              scenario: s,
            ),
        ]),
        WidgetbookComponent(name: 'ImageViewerPage', useCases: [
          screen('From picked bytes', (_) => ImageViewerPage(title: 'rating-plate.png', bytes: demoPhotoSage)),
        ]),
      ],
    );

void _ignore(int _) {}
