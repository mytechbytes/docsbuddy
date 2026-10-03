import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'adaptive_layout.dart';

/// Upper-case grey section heading used above grouped lists.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.topPadding = 14});
  final String text;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4, topPadding, 4, 8),
      child: Text(text.toUpperCase(),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.textMuted, letterSpacing: context.tracking(1))),
    );
  }
}

/// Rounded card holding a group of [SettingsRow]s. A [Material] (not a
/// decorated box) so the rows' ink ripples stay visible.
class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.palette.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.palette.border),
      ),
      child: Column(children: children),
    );
  }
}

/// Settings-style tiles stop growing with the font at this scale: they are
/// one-line titles in a fixed-width column, so beyond it a single long word
/// ("notifications") would no longer fit and would break across lines.
const _tileMaxScale = 1.6;

/// ListTile spacing for the user's font size. The default chrome (a 40dp leading
/// box, 16dp gaps) takes a quarter of a phone's width; with large text that is
/// what leaves the title too little room.
({EdgeInsets? padding, double? gap, double? leading}) _tileChrome(BuildContext context) =>
    context.textScale > 1.3
        ? (padding: const EdgeInsets.symmetric(horizontal: 12), gap: 10.0, leading: 24.0)
        : (padding: null, gap: null, leading: null);

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
  });
  final IconData icon;
  final String title;

  /// A line of explanation under the title.
  final String? subtitle;

  /// A [SettingsValue] sits beside the title while there is room and drops under
  /// it when there isn't; anything else (a chevron) always stays beside it.
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  /// Narrowest tile (at the default font size) that keeps a value beside its title.
  static const _valueBesideWidth = 260.0;

  @override
  Widget build(BuildContext context) {
    final color = danger ? context.palette.danger : context.palette.text;
    final chrome = _tileChrome(context);
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: _tileMaxScale,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Beside the title a long value or large text squeezes it to a few
          // letters a line, so under the title it goes.
          final scale = math.min(context.textScale, _tileMaxScale);
          final stacked = trailing is SettingsValue && constraints.maxWidth / scale < _valueBesideWidth;
          final hint = subtitle == null ? null : Text(subtitle!, style: TextStyle(fontSize: 12, color: context.palette.textMuted));
          return ListTile(
            onTap: onTap,
            contentPadding: chrome.padding,
            horizontalTitleGap: chrome.gap,
            minLeadingWidth: chrome.leading,
            leading: Icon(icon, color: color),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
            subtitle: stacked
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [?hint, trailing!])
                : hint,
            trailing: stacked || trailing == null
                ? null
                : ConstrainedBox(
                    // Even when it fits, a value may use at most 45% of the screen.
                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.45),
                    child: trailing,
                  ),
          );
        },
      ),
    );
  }
}

/// Grey trailing value text for a [SettingsRow].
class SettingsValue extends StatelessWidget {
  const SettingsValue(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(text,
      textAlign: TextAlign.end,
      style: TextStyle(color: context.palette.textMuted, fontWeight: FontWeight.w600, fontSize: 12.5));
}

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;

  /// Null disables the switch.
  final ValueChanged<bool>? onChanged;

  /// Narrowest tile (at the default font size) that keeps the switch beside the title.
  static const _switchBesideWidth = 230.0;

  @override
  Widget build(BuildContext context) {
    final toggle = Switch(value: value, onChanged: onChanged, activeTrackColor: context.palette.success);
    final hint = subtitle == null ? null : Text(subtitle!, style: TextStyle(fontSize: 12, color: context.palette.textMuted));
    final chrome = _tileChrome(context);
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: _tileMaxScale,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // With large text the switch would leave the title a few letters of
          // width, so it moves under the title instead.
          final scale = math.min(context.textScale, _tileMaxScale);
          final stacked = constraints.maxWidth / scale < _switchBesideWidth;
          return ListTile(
            contentPadding: chrome.padding,
            horizontalTitleGap: chrome.gap,
            minLeadingWidth: chrome.leading,
            leading: Icon(icon, color: context.palette.text),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: context.palette.text)),
            subtitle: stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [?hint, Align(alignment: AlignmentDirectional.centerStart, child: toggle)],
                  )
                : hint,
            trailing: stacked ? null : toggle,
          );
        },
      ),
    );
  }
}
