import 'dart:math' as math;

import 'package:docsbuddy/core/media/picked_media.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/catalog/presentation/service_detail_sheet.dart';
import 'package:docsbuddy/features/catalog/presentation/widgets/asset_detail_widgets.dart';
import 'package:docsbuddy/features/catalog/presentation/widgets/asset_form_fields.dart';
import 'package:docsbuddy/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:docsbuddy/features/reminders/presentation/widgets/reminder_kind_tile.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../support/demo_data.dart';
import '../support/demo_images.dart';
import '../support/use_cases.dart';

void _noop() {}

const _newRoom = '__new_room__';

String _kindName(ReminderKind k) => k.label;

/// Assets, rooms and the services (reminders) attached to them.
WidgetbookFolder assetWidgets() => WidgetbookFolder(
      name: 'Assets and reminders',
      children: [
        WidgetbookComponent(name: 'IconBubble', useCases: [
          component(
            'Playground',
            (context) => IconBubble(
              kind: context.knobs.object.dropdown(
                  label: 'Kind', options: ReminderKind.values, labelBuilder: _kindName),
              size: context.knobs.double.slider(label: 'Size', initialValue: 44, min: 20, max: 96),
            ),
          ),
          gallery('Every reminder kind', [
            Wrap(spacing: 14, runSpacing: 14, children: [
              for (final kind in ReminderKind.values)
                Column(mainAxisSize: MainAxisSize.min, children: [
                  IconBubble(kind: kind),
                  const SizedBox(height: 6),
                  Text(kind.label, style: const TextStyle(fontSize: 11)),
                ]),
            ]),
          ]),
        ]),
        WidgetbookComponent(name: 'AssetThumb', useCases: [
          gallery('Fallback when there is no photo', [
            Labeled('Sizes 32 / 44 / 64', Row(children: [
              for (final size in const [32.0, 44.0, 64.0]) ...[
                AssetThumb(
                  imageRef: null,
                  size: size,
                  fallback: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(color: Colors.blueGrey.shade100, borderRadius: BorderRadius.circular(size * 0.27)),
                    child: Icon(Icons.kitchen_outlined, size: size * 0.5),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ])),
            const Labeled('Fallback is an IconBubble, as on reminder tiles',
                AssetThumb(imageRef: null, size: 46, fallback: IconBubble(kind: ReminderKind.insurance, size: 46))),
            const Labeled(
                'A photo reference that cannot resolve keeps the fallback',
                AssetThumb(
                    imageRef: 'local/a1/photo.jpg', size: 46, fallback: IconBubble(kind: ReminderKind.warranty, size: 46))),
          ]),
        ]),
        WidgetbookComponent(name: 'DayPill', useCases: [
          component(
            'Playground',
            (context) => DayPill(
                daysLeft: context.knobs.int.slider(label: 'Days left', initialValue: 6, min: -30, max: 400)),
          ),
          gallery('Urgency ladder', [
            for (final (label, days) in const [
              ('Overdue by 12 days', -12),
              ('Due today', 0),
              ('Tomorrow', 1),
              ('Last "soon" day (7)', 7),
              ('First "ok" day (8)', 8),
              ('Months away', 140),
              ('Three digits wide', 365),
            ])
              Labeled(label, Align(alignment: Alignment.centerLeft, child: DayPill(daysLeft: days))),
          ]),
        ]),
        WidgetbookComponent(name: 'CategoryChip', useCases: [
          component(
            'Playground',
            (context) => CategoryChip(context.knobs.string(label: 'Label', initialValue: 'Air Conditioner')),
          ),
          gallery('Labels', const [
            Labeled('Short', Align(alignment: Alignment.centerLeft, child: CategoryChip('TV'))),
            Labeled('Long', Align(alignment: Alignment.centerLeft, child: CategoryChip('Washing Machine (Front Load)'))),
          ]),
        ]),
        WidgetbookComponent(name: 'AddPill', useCases: [
          component('Default', (_) => AddPill(onTap: _noop)),
        ]),
        WidgetbookComponent(name: 'AssetInfoCard', useCases: [
          component('Full record',
              (_) => AssetInfoCard(asset: demoAsset, reminderCount: 3, onChangePhoto: _noop),
              alignment: Alignment.topCenter),
          component('Minimal record',
              (_) => AssetInfoCard(asset: demoAssetMinimal, reminderCount: 0, onChangePhoto: _noop),
              alignment: Alignment.topCenter),
          component('Very long name and model',
              (_) => AssetInfoCard(asset: demoAssetLongName, reminderCount: 5, onChangePhoto: _noop),
              alignment: Alignment.topCenter),
        ]),
        WidgetbookComponent(name: 'InfoRow', useCases: [
          component(
            'Playground',
            (context) => InfoRow(
              context.knobs.string(label: 'Label', initialValue: 'Serial number'),
              context.knobs.string(label: 'Value', initialValue: 'DK-7731-2290'),
            ),
          ),
          gallery('Wrapping', const [
            InfoRow('Brand', 'Daikin'),
            InfoRow('Purchase price', '₹ 46,500'),
            InfoRow('Store', 'Reliance Digital, Indiranagar, Bengaluru (second floor service desk)'),
          ]),
        ]),
        WidgetbookComponent(name: 'NextDueBanner', useCases: [
          component(
            'Playground',
            (context) => NextDueBanner(
              reminder: demoReminder(
                kind: context.knobs.object.dropdown(
                    label: 'Kind', options: ReminderKind.values, initialOption: ReminderKind.insurance, labelBuilder: _kindName),
                days: context.knobs.int.slider(label: 'Days left', initialValue: 12, min: -30, max: 120),
              ),
            ),
          ),
          gallery('Countdown wording', [
            Labeled('Overdue', NextDueBanner(reminder: demoReminder(days: -3))),
            Labeled('Due today', NextDueBanner(reminder: demoReminder(days: 0))),
            Labeled('Days left', NextDueBanner(reminder: demoReminder(days: 18, kind: ReminderKind.service))),
            Labeled('Long label', NextDueBanner(reminder: demoReminder(days: 18, label: 'Extended warranty'))),
          ]),
        ]),
        WidgetbookComponent(name: 'ServiceRow', useCases: [
          component(
            'Playground',
            (context) => ServiceRow(
              reminder: demoReminder(
                kind: context.knobs.object.dropdown(
                    label: 'Kind', options: ReminderKind.values, initialOption: ReminderKind.service, labelBuilder: _kindName),
                days: context.knobs.int.slider(label: 'Days left', initialValue: 12, min: -30, max: 400),
                provider: context.knobs.stringOrNull(label: 'Provider', initialValue: 'Daikin Care'),
                policyNo: context.knobs.stringOrNull(label: 'Policy no.', initialValue: null),
              ),
              onTap: _noop,
              onAction: (_) {},
            ),
          ),
          gallery('Cases', [
            Labeled('Provider and policy',
                ServiceRow(reminder: demoReminder(), onTap: _noop, onAction: (_) {})),
            Labeled('Nothing optional',
                ServiceRow(
                    reminder: demoReminder(kind: ReminderKind.warranty, days: 140, provider: null, policyNo: null),
                    onTap: _noop,
                    onAction: (_) {})),
            Labeled('Overdue',
                ServiceRow(reminder: demoReminder(kind: ReminderKind.amc, days: -2), onTap: _noop, onAction: (_) {})),
            Labeled('Six alert offsets wrap instead of overflowing',
                ServiceRow(
                    reminder: demoReminder(kind: ReminderKind.service, days: 6, offsets: const [60, 30, 14, 7, 3, 1]),
                    onTap: _noop,
                    onAction: (_) {})),
            Labeled('Long label and provider',
                ServiceRow(
                    reminder: demoReminder(
                        label: 'Annual maintenance contract renewal',
                        provider: 'Authorised Daikin Service Partner, Whitefield',
                        policyNo: 'AMC-2026-00042-REV-B'),
                    onTap: _noop,
                    onAction: (_) {})),
          ]),
        ]),
        WidgetbookComponent(name: 'ServiceDetailSheet', useCases: [
          filling('Full service record', (_) => SheetFrame(child: ServiceDetailSheet(reminder: demoReminder(notes: 'Technician visit booked for the first week. Ask for the filter wash too.')))),
          filling('Minimal service record',
              (_) => SheetFrame(
                  child: ServiceDetailSheet(
                      reminder: demoReminder(
                          kind: ReminderKind.warranty, days: 140, provider: null, policyNo: null, cost: null, recurrence: Recurrence.none)))),
          filling('Overdue',
              (_) => SheetFrame(child: ServiceDetailSheet(reminder: demoReminder(kind: ReminderKind.pollution, days: -5)))),
        ]),
        WidgetbookComponent(name: 'CategoryCard', useCases: [
          component(
            'Selectable grid',
            (_) => Interactive<AssetCategoryKind>(
              initial: AssetCategoryKind.appliance,
              builder: (context, selected, set) => GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: CategoryCard.minHeight(context),
                ),
                children: [
                  for (final kind in AssetCategoryKind.values)
                    CategoryCard(kind: kind, selected: kind == selected, onTap: () => set(kind)),
                ],
              ),
            ),
          ),
        ]),
        WidgetbookComponent(name: 'AssetTypeChip', useCases: [
          component(
            'Selectable chips',
            (_) => Interactive<int>(
              initial: 1,
              builder: (context, selected, set) => Wrap(spacing: 8, runSpacing: 8, children: [
                for (final (i, (icon, label)) in const [
                  (Icons.ac_unit_outlined, 'Air Conditioner'),
                  (Icons.kitchen_outlined, 'Refrigerator'),
                  (Icons.local_laundry_service_outlined, 'Washing Machine'),
                  (Icons.tv_outlined, 'Television'),
                ].indexed)
                  AssetTypeChip(icon: icon, label: label, selected: i == selected, onTap: () => set(i)),
              ]),
            ),
          ),
        ]),
        WidgetbookComponent(name: 'RoomDropdown', useCases: [
          component(
            'Pick a room',
            (_) => Interactive<String?>(
              initial: null,
              builder: (context, value, set) =>
                  RoomDropdown(rooms: demoRooms, value: value, newRoomSentinel: _newRoom, onChanged: set),
            ),
            alignment: Alignment.topCenter,
          ),
          component('A room is chosen',
              (_) => Interactive<String?>(
                    initial: 'Kitchen',
                    builder: (context, value, set) =>
                        RoomDropdown(rooms: demoRooms, value: value, newRoomSentinel: _newRoom, onChanged: set),
                  ),
              alignment: Alignment.topCenter),
          component('Prefilled room that does not exist yet',
              (_) => Interactive<String?>(
                    initial: 'Study',
                    builder: (context, value, set) =>
                        RoomDropdown(rooms: demoRooms, value: value, newRoomSentinel: _newRoom, onChanged: set),
                  ),
              alignment: Alignment.topCenter),
        ]),
        WidgetbookComponent(name: 'AssetPhotoPicker', useCases: [
          gallery('States', [
            Labeled('No photo yet', Align(alignment: Alignment.centerLeft, child: AssetPhotoPicker(photo: null, onTap: _noop))),
            Labeled(
                'Freshly picked photo',
                Align(
                    alignment: Alignment.centerLeft,
                    child: AssetPhotoPicker(photo: PickedMedia(name: 'ac.png', bytes: demoPhotoWarm), onTap: _noop))),
          ]),
        ]),
        WidgetbookComponent(name: 'DateField', useCases: [
          component(
            'Playground',
            (context) => DateField(
              label: context.knobs.string(label: 'Label', initialValue: 'Purchase date'),
              value: context.knobs.boolean(label: 'Has a date', initialValue: true) ? DateTime(2023, 5, 18) : null,
              onTap: _noop,
            ),
          ),
        ]),
        WidgetbookComponent(name: 'ReminderKindTile', useCases: [
          component(
            'Selectable grid',
            (_) => Interactive<ReminderKind>(
              initial: ReminderKind.service,
              builder: (context, selected, set) => GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: math.max(ReminderKindTile.minHeight(context), 74),
                ),
                children: [
                  for (final kind in ReminderKind.values)
                    ReminderKindTile(kind: kind, selected: kind == selected, onTap: () => set(kind)),
                ],
              ),
            ),
          ),
        ]),
      ],
    );
