import 'package:widgetbook/widgetbook.dart';

import 'catalog/account_widgets.dart';
import 'catalog/asset_widgets.dart';
import 'catalog/auth_widgets.dart';
import 'catalog/core_widgets.dart';
import 'catalog/dashboard_widgets.dart';
import 'catalog/document_widgets.dart';
import 'catalog/family_widgets.dart';
import 'catalog/foundations.dart';
import 'catalog/screens.dart';

/// The whole catalog, top to bottom. One file per area under `catalog/`.
List<WidgetbookNode> buildDirectories() => [
      foundations(),
      coreWidgets(),
      WidgetbookCategory(name: 'Feature widgets', children: [
        authWidgets(),
        assetWidgets(),
        dashboardWidgets(),
        familyWidgets(),
        documentWidgets(),
        securityWidgets(),
        profileWidgets(),
        onboardingWidgets(),
      ]),
      screens(),
    ];
