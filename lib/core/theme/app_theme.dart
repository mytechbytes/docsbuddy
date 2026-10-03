import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Theme-dependent colours. Widgets read them with `context.palette`;
/// [light] and [dark] are the two instances. Fixed brand/illustration
/// colours stay in [AppColors].
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.text,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderSoft,
    required this.fieldBorder,
    required this.hairline,
    required this.placeholder,
    required this.eyeIcon,
    required this.indicatorIdle,
    required this.accent,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.successStrong,
    required this.danger,
    required this.dangerSoft,
    required this.warning,
    required this.warningSoft,
    required this.inverseSurface,
    required this.onInverse,
  });

  final Color background;
  final Color surface;
  final Color text;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color borderSoft;
  final Color fieldBorder;
  final Color hairline;
  final Color placeholder;
  final Color eyeIcon;
  final Color indicatorIdle;
  final Color accent;
  final Color accentSoft;
  final Color success;
  final Color successSoft;
  final Color successStrong;
  final Color danger;
  final Color dangerSoft;
  final Color warning;
  final Color warningSoft;
  final Color inverseSurface;
  final Color onInverse;

  static const light = AppPalette(
    background: AppColors.bg,
    surface: AppColors.paper,
    text: AppColors.ink,
    textSecondary: AppColors.ink2,
    textMuted: AppColors.muted,
    border: AppColors.line,
    borderSoft: AppColors.lineSoft,
    fieldBorder: AppColors.fieldBorder,
    hairline: AppColors.hairline,
    placeholder: AppColors.placeholder,
    eyeIcon: AppColors.eyeIcon,
    indicatorIdle: AppColors.indicatorIdle,
    accent: AppColors.chipBlue,
    accentSoft: AppColors.blueSoft,
    success: AppColors.green,
    successSoft: AppColors.greenSoft,
    successStrong: AppColors.greenLeaf,
    danger: AppColors.red,
    dangerSoft: AppColors.redSoft,
    warning: AppColors.amber,
    warningSoft: AppColors.amberSoft,
    inverseSurface: AppColors.inverseSurface,
    onInverse: AppColors.onInverse,
  );

  static const dark = AppPalette(
    background: Color(0xFF0E1420),
    surface: Color(0xFF172131),
    text: Color(0xFFE8EDF5),
    textSecondary: Color(0xFFB8C2D3),
    textMuted: Color(0xFF8A96AB),
    border: Color(0xFF263245),
    borderSoft: Color(0xFF202B3C),
    fieldBorder: Color(0xFF2C394E),
    hairline: Color(0xFF2A3548),
    placeholder: Color(0xFF5E6A80),
    eyeIcon: Color(0xFF7C889E),
    indicatorIdle: Color(0xFF3A4659),
    accent: Color(0xFF5B9BFF),
    accentSoft: Color(0xFF1C2D4A),
    success: Color(0xFF34C27E),
    successSoft: Color(0xFF173828),
    successStrong: Color(0xFF5CCB7C),
    danger: Color(0xFFF0707A),
    dangerSoft: Color(0xFF3A1D22),
    warning: Color(0xFFF0B048),
    warningSoft: Color(0xFF3A2E17),
    inverseSurface: Color(0xFFE8EDF5),
    onInverse: Color(0xFF0E1420),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? text,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? borderSoft,
    Color? fieldBorder,
    Color? hairline,
    Color? placeholder,
    Color? eyeIcon,
    Color? indicatorIdle,
    Color? accent,
    Color? accentSoft,
    Color? success,
    Color? successSoft,
    Color? successStrong,
    Color? danger,
    Color? dangerSoft,
    Color? warning,
    Color? warningSoft,
    Color? inverseSurface,
    Color? onInverse,
  }) =>
      AppPalette(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        text: text ?? this.text,
        textSecondary: textSecondary ?? this.textSecondary,
        textMuted: textMuted ?? this.textMuted,
        border: border ?? this.border,
        borderSoft: borderSoft ?? this.borderSoft,
        fieldBorder: fieldBorder ?? this.fieldBorder,
        hairline: hairline ?? this.hairline,
        placeholder: placeholder ?? this.placeholder,
        eyeIcon: eyeIcon ?? this.eyeIcon,
        indicatorIdle: indicatorIdle ?? this.indicatorIdle,
        accent: accent ?? this.accent,
        accentSoft: accentSoft ?? this.accentSoft,
        success: success ?? this.success,
        successSoft: successSoft ?? this.successSoft,
        successStrong: successStrong ?? this.successStrong,
        danger: danger ?? this.danger,
        dangerSoft: dangerSoft ?? this.dangerSoft,
        warning: warning ?? this.warning,
        warningSoft: warningSoft ?? this.warningSoft,
        inverseSurface: inverseSurface ?? this.inverseSurface,
        onInverse: onInverse ?? this.onInverse,
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
      borderSoft: mix(borderSoft, other.borderSoft),
      fieldBorder: mix(fieldBorder, other.fieldBorder),
      hairline: mix(hairline, other.hairline),
      placeholder: mix(placeholder, other.placeholder),
      eyeIcon: mix(eyeIcon, other.eyeIcon),
      indicatorIdle: mix(indicatorIdle, other.indicatorIdle),
      accent: mix(accent, other.accent),
      accentSoft: mix(accentSoft, other.accentSoft),
      success: mix(success, other.success),
      successSoft: mix(successSoft, other.successSoft),
      successStrong: mix(successStrong, other.successStrong),
      danger: mix(danger, other.danger),
      dangerSoft: mix(dangerSoft, other.dangerSoft),
      warning: mix(warning, other.warning),
      warningSoft: mix(warningSoft, other.warningSoft),
      inverseSurface: mix(inverseSurface, other.inverseSurface),
      onInverse: mix(onInverse, other.onInverse),
    );
  }
}

extension AppThemeContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}

/// App-wide Material 3 theme built from the design tokens (Plus Jakarta Sans, bundled in `assets/fonts/`).
abstract final class AppTheme {
  static const fontFamily = 'PlusJakartaSans';

  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.inverseSurface,
      onPrimary: p.onInverse,
      secondary: AppColors.teal,
      onSecondary: Colors.white,
      inverseSurface: p.inverseSurface,
      onInverseSurface: p.onInverse,
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
      // One header style for every screen: centered title (otherwise iOS
      // centers and Android doesn't) over a hairline, flat even when content
      // scrolls under it.
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: p.border)),
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
