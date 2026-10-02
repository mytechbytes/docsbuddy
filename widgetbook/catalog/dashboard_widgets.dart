import 'package:docsbuddy/core/theme/app_colors.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/dashboard/presentation/widgets/dashboard_widgets.dart';
import 'package:docsbuddy/features/reminders/domain/reminder_filters.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../support/demo_data.dart';
import '../support/use_cases.dart';

void _noop() {}

WidgetbookFolder dashboardWidgets() => WidgetbookFolder(
      name: 'Dashboard',
      children: [
        WidgetbookComponent(name: 'AppBarIconButton', useCases: [
          component(
            'Playground',
            (context) => AppBarIconButton(
              context.knobs.object.dropdown(
                label: 'Icon',
                options: const [Icons.search, Icons.notifications_none],
                labelBuilder: (i) => i == Icons.search ? 'Search' : 'Notifications',
              ),
              dot: context.knobs.boolean(label: 'Unread dot'),
              onTap: _noop,
            ),
          ),
          gallery('As in the dashboard app bar', [
            Row(children: [
              AppBarIconButton(Icons.search, onTap: _noop),
              AppBarIconButton(Icons.notifications_none, onTap: _noop),
              AppBarIconButton(Icons.notifications_none, dot: true, onTap: _noop),
            ]),
          ]),
        ]),
        WidgetbookComponent(name: 'StatGrid', useCases: [
          component(
            'Playground',
            (context) => StatGrid(
              counts: {
                ReminderFilter.active: context.knobs.int.slider(label: 'Active', initialValue: 12, min: 0, max: 1000),
                ReminderFilter.secured: context.knobs.int.slider(label: 'Secured', initialValue: 7, min: 0, max: 1000),
                ReminderFilter.soon: context.knobs.int.slider(label: 'Expiring soon', initialValue: 4, min: 0, max: 1000),
                ReminderFilter.expired: context.knobs.int.slider(label: 'Expired', initialValue: 1, min: 0, max: 1000),
              },
              assetCount: context.knobs.int.slider(label: 'Appliances', initialValue: 8, min: 0, max: 1000),
            ),
            alignment: Alignment.topCenter,
          ),
          component(
            'Lived-in account',
            (_) => const StatGrid(counts: {
              ReminderFilter.active: 12,
              ReminderFilter.secured: 7,
              ReminderFilter.soon: 4,
              ReminderFilter.expired: 1,
            }, assetCount: 8),
            alignment: Alignment.topCenter,
          ),
          component('New account (all zero)', (_) => const StatGrid(counts: {}, assetCount: 0), alignment: Alignment.topCenter),
          component(
            'Large numbers',
            (_) => const StatGrid(counts: {
              ReminderFilter.active: 1284,
              ReminderFilter.secured: 977,
              ReminderFilter.soon: 3150,
              ReminderFilter.expired: 12,
            }, assetCount: 4096),
            alignment: Alignment.topCenter,
          ),
        ]),
        WidgetbookComponent(name: 'StatCard', useCases: [
          component(
            'Playground',
            (context) => SizedBox(
              width: 170,
              child: StatCard(
                value: context.knobs.string(label: 'Value', initialValue: '12'),
                label: context.knobs.string(label: 'Label', initialValue: 'Active services'),
                icon: Icons.description_outlined,
                bg: context.knobs.object.dropdown(
                  label: 'Background',
                  options: const [AppColors.navy, AppColors.teal, AppColors.statSoonBg, AppColors.statExpiredBg],
                  labelBuilder: (c) => {
                    AppColors.navy: 'Navy',
                    AppColors.teal: 'Teal',
                    AppColors.statSoonBg: 'Soon',
                    AppColors.statExpiredBg: 'Expired',
                  }[c]!,
                ),
                fg: context.knobs.boolean(label: 'Light text', initialValue: true) ? Colors.white : AppColors.ink,
                filter: ReminderFilter.active,
              ),
            ),
          ),
        ]),
        WidgetbookComponent(name: 'AppliancesCard', useCases: [
          component(
            'Playground',
            (context) => AppliancesCard(count: context.knobs.int.slider(label: 'Count', initialValue: 8, min: 0, max: 5000)),
          ),
        ]),
        WidgetbookComponent(name: 'UpcomingReminderTile', useCases: [
          gallery('Urgency ladder', [
            for (final r in demoUrgencyLadder) UpcomingReminderTile(reminder: r),
          ]),
          component(
            'Long asset name',
            (_) => UpcomingReminderTile(reminder: demoReminder(assetName: demoAssetLongName.name, label: 'Extended warranty renewal')),
          ),
        ]),
        WidgetbookComponent(name: 'AssetGroupCard', useCases: [
          component(
            'Asset with several services',
            (_) => AssetGroupCard(
              asset: demoAsset,
              reminders: [
                demoReminder(kind: ReminderKind.service, days: 6, assetName: demoAsset.name),
                demoReminder(kind: ReminderKind.amc, days: 40, assetName: demoAsset.name),
                demoReminder(kind: ReminderKind.warranty, days: 190, assetName: demoAsset.name),
              ],
            ),
          ),
          component(
            'Overdue first',
            (_) => AssetGroupCard(
              asset: demoAsset,
              reminders: [
                demoReminder(kind: ReminderKind.amc, days: -2, assetName: demoAsset.name),
                demoReminder(kind: ReminderKind.warranty, days: 90, assetName: demoAsset.name),
              ],
            ),
          ),
          component(
            'Asset not in the list (unknown type)',
            (_) => AssetGroupCard(asset: null, reminders: [demoReminder(days: 12)]),
          ),
        ]),
      ],
    );
