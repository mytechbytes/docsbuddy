import 'package:flutter/material.dart';

import 'app_colors.dart';

/// App-wide Material 3 theme. Typography is Plus Jakarta Sans, bundled in
/// `assets/fonts/` and declared in `pubspec.yaml`.
abstract final class AppTheme {
  static const fontFamily = 'PlusJakartaSans';

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        primary: AppColors.ink,
        surface: AppColors.bg,
      ),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
    );
  }
}
