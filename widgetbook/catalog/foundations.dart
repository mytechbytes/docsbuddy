import 'package:docsbuddy/core/theme/app_colors.dart';
import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_enums.dart';
import 'package:docsbuddy/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../support/use_cases.dart';

WidgetbookCategory foundations() => WidgetbookCategory(
      name: 'Foundations',
      children: [
        WidgetbookComponent(name: 'Colors', useCases: [
          filling('Theme palette', (_) => const _PaletteList()),
          filling('Light and dark side by side', (_) => const _PaletteComparison()),
          filling('Brand and semantic', (_) => const _FixedColors()),
          filling('Reminder kinds', (_) => const _ReminderKindColors()),
        ]),
        WidgetbookComponent(name: 'Typography', useCases: [
          filling('Type ramp as used in the app', (_) => const _TypeRamp()),
        ]),
      ],
    );

/// Every [AppPalette] token, in the order the palette declares them.
Map<String, Color> _tokens(AppPalette p) => {
      'background': p.background,
      'surface': p.surface,
      'text': p.text,
      'textSecondary': p.textSecondary,
      'textMuted': p.textMuted,
      'border': p.border,
      'borderSoft': p.borderSoft,
      'fieldBorder': p.fieldBorder,
      'hairline': p.hairline,
      'placeholder': p.placeholder,
      'eyeIcon': p.eyeIcon,
      'indicatorIdle': p.indicatorIdle,
      'accent': p.accent,
      'accentSoft': p.accentSoft,
      'success': p.success,
      'successSoft': p.successSoft,
      'successStrong': p.successStrong,
      'danger': p.danger,
      'dangerSoft': p.dangerSoft,
      'warning': p.warning,
      'warningSoft': p.warningSoft,
      'inverseSurface': p.inverseSurface,
      'onInverse': p.onInverse,
    };

String _hex(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color, required this.labelColor, required this.outline});

  final String name;
  final Color color;
  final Color labelColor;
  final Color outline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: outline),
            ),
          ),
          const SizedBox(width: 12),
          // Name over hex, so a narrow column or large text only wraps.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: labelColor)),
                Text(_hex(color), style: TextStyle(fontSize: 12, color: labelColor.withValues(alpha: 0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteList extends StatelessWidget {
  const _PaletteList();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final e in _tokens(p).entries)
          _Swatch(name: e.key, color: e.value, labelColor: p.text, outline: p.border),
      ],
    );
  }
}

class _PaletteComparison extends StatelessWidget {
  const _PaletteComparison();

  Widget _column(AppPalette p, String title) {
    return Expanded(
      child: ColoredBox(
        color: p.background,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: p.text)),
            ),
            for (final e in _tokens(p).entries)
              _Swatch(name: e.key, color: e.value, labelColor: p.text, outline: p.border),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [_column(AppPalette.light, 'Light'), _column(AppPalette.dark, 'Dark')]);
  }
}

class _FixedColors extends StatelessWidget {
  const _FixedColors();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const colors = {
      'navy': AppColors.navy,
      'teal': AppColors.teal,
      'chipBlue': AppColors.chipBlue,
      'green': AppColors.green,
      'red': AppColors.red,
      'amber': AppColors.amber,
      'shieldBlue': AppColors.shieldBlue,
      'statSoonBg': AppColors.statSoonBg,
      'statExpiredBg': AppColors.statExpiredBg,
      'splashBackground': AppColors.splashBackground,
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final e in colors.entries)
          _Swatch(name: e.key, color: e.value, labelColor: p.text, outline: p.border),
      ],
    );
  }
}

class _ReminderKindColors extends StatelessWidget {
  const _ReminderKindColors();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final kind in ReminderKind.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                IconBubble(kind: kind),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kind.label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: p.text)),
                      Text('${_hex(kind.bg)} on ${_hex(kind.fg)}', style: TextStyle(fontSize: 12, color: p.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The sizes and weights the screens actually use, from the heaviest title down
/// to the small caps label. The app styles text inline rather than through a
/// type scale, so this is the set those styles add up to.
class _TypeRamp extends StatelessWidget {
  const _TypeRamp();

  static const _ramp = <(String, double, FontWeight, double?, double?)>[
    ('Hero title (auth, big)', 30, FontWeight.w800, 1.1, -0.5),
    ('Hero title', 26, FontWeight.w800, 1.1, -0.5),
    ('Screen title', 20, FontWeight.w800, null, null),
    ('Section title', 17, FontWeight.w800, null, null),
    ('Button', 16, FontWeight.w700, null, null),
    ('List title', 15, FontWeight.w800, 1.15, null),
    ('Body', 14, FontWeight.w400, 1.45, null),
    ('Field label', 13, FontWeight.w700, null, null),
    ('Meta', 12.5, FontWeight.w400, null, null),
    ('Caption', 12, FontWeight.w400, null, null),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final (name, size, weight, height, spacing) in _ramp)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name · ${size}px · w${weight.value}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.textMuted)),
                const SizedBox(height: 4),
                Text('Keep every renewal in one place',
                    style: TextStyle(
                        fontSize: size, fontWeight: weight, height: height, letterSpacing: spacing, color: p.text)),
              ],
            ),
          ),
        Text('SECTION LABEL · 11PX · W700 · SPACED',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1, color: p.textMuted)),
      ],
    );
  }
}
