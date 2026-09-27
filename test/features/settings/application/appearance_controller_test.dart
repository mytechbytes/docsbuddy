import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:docsbuddy/features/settings/application/appearance_controller.dart';
import 'package:docsbuddy/features/settings/data/shared_prefs_appearance_store.dart';
import 'package:docsbuddy/features/settings/domain/appearance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('persists the chosen appearance and restores it', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    ProviderContainer make() => ProviderContainer.test(
          overrides: [appearanceStoreProvider.overrideWithValue(SharedPrefsAppearanceStore(prefs))],
        );

    final first = make();
    expect(first.read(appearanceProvider), AppearanceMode.system);
    await first.read(appearanceProvider.notifier).set(AppearanceMode.dark);
    expect(first.read(appearanceProvider), AppearanceMode.dark);

    expect(make().read(appearanceProvider), AppearanceMode.dark); // survives restart
  });

  test('dark theme uses the dark palette and a dark scheme', () {
    final dark = AppTheme.dark;
    expect(dark.brightness, Brightness.dark);
    expect(dark.extension<AppPalette>(), AppPalette.dark);
    expect(dark.scaffoldBackgroundColor, AppPalette.dark.background);
    // Primary fills invert: light fill, dark content.
    expect(dark.colorScheme.primary, AppPalette.dark.inverseSurface);
    expect(dark.colorScheme.onPrimary, AppPalette.dark.onInverse);
  });
}
