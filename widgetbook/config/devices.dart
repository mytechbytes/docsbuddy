import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Screen sizes worth checking, smallest and most awkward first within each
/// group. Reused from Widgetbook where it ships a matching device; the rest
/// cover what it lacks: the narrowest phones still in use, and landscape.
///
/// "Compact" is also what an Android phone becomes with Settings → Display →
/// Display size at its largest, so it pairs with the text-scale addon to give
/// the worst case a real user can configure.
abstract final class ScreenSizes {
  static const compactPhone = ViewportData(
    name: 'Phone · compact 320×568',
    width: 320,
    height: 568,
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
