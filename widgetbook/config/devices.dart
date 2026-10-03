import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Screen sizes worth checking, smallest and most awkward first within each group: Widgetbook's own devices plus the
/// narrowest phones still in use, and landscape. "Compact" is also what an Android phone becomes at its largest display
/// size, so it pairs with the text-scale addon to give the worst case a user can configure.
abstract final class ScreenSizes {
  static const compactPhone = ViewportData(
    name: 'Phone · compact 320×568',
    width: 320,
    height: 568,
    pixelRatio: 2,
    platform: TargetPlatform.android,
    safeAreas: EdgeInsets.only(top: 24),
  );

  /// A 320dp screen as tall as a long page. Lists build only what is on screen,
  /// so this is how to see (and test) a whole scrolling screen at once.
  static const compactWholePage = ViewportData(
    name: 'Phone · compact, whole page 320×4000',
    width: 320,
    height: 4000,
    pixelRatio: 2,
    platform: TargetPlatform.android,
    safeAreas: EdgeInsets.only(top: 24),
  );

  static const phone = ViewportData(
    name: 'Phone · Android 360×800',
    width: 360,
    height: 800,
    pixelRatio: 3,
    platform: TargetPlatform.android,
    safeAreas: EdgeInsets.only(top: 24, bottom: 16),
  );

  static const phoneLandscape = ViewportData(
    name: 'Phone · iPhone 13 landscape 844×390',
    width: 844,
    height: 390,
    pixelRatio: 3,
    platform: TargetPlatform.iOS,
    safeAreas: EdgeInsets.only(left: 47, right: 47, bottom: 21),
  );

  static const tabletLandscape = ViewportData(
    name: 'Tablet · iPad landscape 1080×810',
    width: 1080,
    height: 810,
    pixelRatio: 2,
    platform: TargetPlatform.iOS,
    safeAreas: EdgeInsets.only(top: 20),
  );

  /// First entry is what Widgetbook opens with.
  static const all = <ViewportData>[
    IosViewports.iPhone13,
    compactPhone,
    compactWholePage,
    IosViewports.iPhoneSE,
    phone,
    AndroidViewports.samsungGalaxyNote20Ultra,
    IosViewports.iPhone13ProMax,
    phoneLandscape,
    AndroidViewports.smallTablet,
    IosViewports.iPad,
    IosViewports.iPad12InchesGen4,
    tabletLandscape,
    Viewports.none,
  ];
}
