import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic colours that Material's [ColorScheme] has no slot for. Read with
/// `context.palette`. Registered on the theme so a dark variant is a second
/// [AppPalette] instance rather than a rewrite of every widget.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.text,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.accent,
    required this.accentSoft,
    required this.success,
    required this.warning,
    required this.danger,
  });

  final Color background;
  final Color surface;
  final Color text;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color accent;
  final Color accentSoft;
  final Color success;
  final Color warning;
  final Color danger;

  static const light = AppPalette(
    background: AppColors.bg,
    surface: AppColors.paper,
    text: AppColors.ink,
    textSecondary: AppColors.ink2,
    textMuted: AppColors.muted,
    border: AppColors.line,
    accent: AppColors.chipBlue,
    accentSoft: AppColors.blueSoft,
    success: AppColors.green,
    warning: AppColors.amber,
    danger: AppColors.red,
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? text,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? accent,
    Color? accentSoft,
    Color? success,
    Color? warning,
    Color? danger,
  }) =>
      AppPalette(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        text: text ?? this.text,
        textSecondary: textSecondary ?? this.textSecondary,
        textMuted: textMuted ?? this.textMuted,
        border: border ?? this.border,
        accent: accent ?? this.accent,
        accentSoft: accentSoft ?? this.accentSoft,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        danger: danger ?? this.danger,
      );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      text: mix(text, other.text),
      textSecondary: mix(textSecondary, other.textSecondary),
      textMuted: mix(textMuted, other.textMuted),
      border: mix(border, other.border),
      accent: mix(accent, other.accent),
      accentSoft: mix(accentSoft, other.accentSoft),
      success: mix(success, other.success),
      warning: mix(warning, other.warning),
      danger: mix(danger, other.danger),
    );
  }
}

extension AppThemeContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}

/// App-wide Material 3 theme built from the design tokens. Typography is
/// Plus Jakarta Sans, bundled in `assets/fonts/` and declared in
/// `pubspec.yaml`.
abstract final class AppTheme {
  static const fontFamily = 'PlusJakartaSans';

  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.text,
      onPrimary: p.surface,
      secondary: AppColors.teal,
      onSecondary: Colors.white,
      tertiary: p.accent,
      onTertiary: Colors.white,
      error: p.danger,
      onError: Colors.white,
      surface: p.background,
      onSurface: p.text,
      onSurfaceVariant: p.textMuted,
      surfaceContainerLowest: p.surface,
      surfaceContainer: p.surface,
      outline: p.border,
      outlineVariant: p.border,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      extensions: [p],
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: p.text, displayColor: p.text),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: p.text),
        titleTextStyle: TextStyle(
            fontFamily: fontFamily, fontSize: 17, fontWeight: FontWeight.w800, color: p.text),
      ),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: p.surface, indicatorColor: p.accentSoft),
      dividerTheme: DividerThemeData(color: p.border, space: 1),
      dialogTheme: DialogThemeData(backgroundColor: p.surface),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: p.surface),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
