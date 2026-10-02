import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

final _light = AppTheme.light;
final _dark = AppTheme.dark;

/// The app shell every use case sits in: Material, the app's themes and its
/// localisations, so `context.l10n` and `context.palette` resolve as in the app.
/// The light/dark choice itself comes from the theme addon, inside this.
Widget docsBuddyAppBuilder(BuildContext context, Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _light,
      darkTheme: _dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Material(child: child),
    );
