import 'package:docsbuddy/core/l10n/app_language.dart';
import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:widgetbook/widgetbook.dart';

import 'devices.dart';

// Built once: the theme getters assemble a fresh ThemeData on every call, and
// Widgetbook compares themes by value.
final _light = AppTheme.light;
final _dark = AppTheme.dark;

/// The knobs that apply to every use case, outermost first. Order matters:
/// theme and text scale feed the viewport, which sizes the frame the use case
/// is drawn in, so they must wrap it.
List<WidgetbookAddon> buildAddons() => [
      // Light / dark, using the app's own themes (never Widgetbook's).
      MaterialThemeAddon(
        themes: [
          WidgetbookTheme(name: 'Light', data: _light),
          WidgetbookTheme(name: 'Dark', data: _dark),
        ],
      ),
      // Font scaling. 1.3 and 2.0 are Android's "Large" and "Largest"; iOS
      // accessibility sizes run to about 3.1.
      TextScaleAddon(min: 0.8, max: 3.0, divisions: 22),
      // Magnifies the whole preview (device frame included) for inspecting
      // detail; unlike text scale it changes nothing about layout.
      ZoomAddon(),
      // Screen size, density and platform; sets MediaQuery for the use case.
      ViewportAddon(ScreenSizes.all),
      // Every language the app ships, Arabic included: selecting it also
      // mirrors the layout, so right-to-left problems show up here first.
      LocalizationAddon(
        locales: [for (final language in AppLanguage.explicit) language.locale!],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        initialLocale: AppLanguage.english.locale,
      ),
      InspectorAddon(),
    ];
