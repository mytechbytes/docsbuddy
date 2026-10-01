import 'package:docsbuddy/core/theme/app_colors.dart';
import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light theme maps the design tokens onto Material slots', () {
    final theme = AppTheme.light;
    expect(theme.colorScheme.primary, AppColors.ink);
    expect(theme.colorScheme.error, AppColors.red);
    expect(theme.scaffoldBackgroundColor, AppColors.bg);
    expect(theme.extension<AppPalette>(), AppPalette.light);
  });

  testWidgets('context.palette reads the registered extension', (tester) async {
    late AppPalette palette;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: Builder(builder: (context) {
        palette = context.palette;
        return const SizedBox();
      }),
    ));
    expect(palette.accent, AppColors.chipBlue);
  });

  test('app bars share one header style in both themes', () {
    for (final (theme, palette) in [(AppTheme.light, AppPalette.light), (AppTheme.dark, AppPalette.dark)]) {
      final bar = theme.appBarTheme;
      expect(bar.centerTitle, isTrue, reason: 'iOS centers by default, Android does not');
      expect(bar.elevation, 0);
      expect(bar.scrolledUnderElevation, 0);
      expect(bar.shape, Border(bottom: BorderSide(color: palette.border)));
    }
  });

  test('palettes interpolate for theme animations', () {
    final dark = AppPalette.light.copyWith(background: Colors.black);
    expect(AppPalette.light.lerp(dark, 1).background, Colors.black);
    expect(AppPalette.light.lerp(dark, 0).background, AppColors.bg);
  });
}
