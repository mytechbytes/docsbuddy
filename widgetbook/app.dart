import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:docsbuddy/core/widgets/db_logo.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'config/addons.dart';
import 'config/app_builder.dart';
import 'directories.dart';
import 'home_page.dart';

/// The DocsBuddy catalog. Everything the app draws, from tokens to whole
/// screens, in light and dark, on any screen size and at any font scale.
class DocsBuddyWidgetbook extends StatelessWidget {
  const DocsBuddyWidgetbook({super.key, this.initialRoute = '/'});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      initialRoute: initialRoute,
      directories: buildDirectories(),
      addons: buildAddons(),
      appBuilder: docsBuddyAppBuilder,
      home: const CatalogHomePage(),
      header: const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 4), child: _Header()),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    // Widgetbook's own chrome isn't under the app theme, so theme the logo by hand.
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: dark ? AppTheme.dark : AppTheme.light,
      child: const Align(alignment: Alignment.centerLeft, child: DbLogo(size: 17)),
    );
  }
}
