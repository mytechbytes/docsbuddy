import 'package:flutter/widgets.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/reminder_filters.dart';

extension ReminderFilterName on ReminderFilter {
  String displayName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      ReminderFilter.active => l.filterActive,
      ReminderFilter.secured => l.filterSecured,
      ReminderFilter.soon => l.filterSoon,
      ReminderFilter.expired => l.filterExpired,
    };
  }
}
