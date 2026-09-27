import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.textMuted, letterSpacing: 1)),
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

class SettingsRow extends StatelessWidget {
  const SettingsRow({super.key, required this.icon, required this.title, this.trailing, this.onTap, this.danger = false});
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? context.palette.danger : context.palette.text;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      trailing: trailing,
    );
  }
}

/// Grey trailing value text for a [SettingsRow].
class SettingsValue extends StatelessWidget {
  const SettingsValue(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(color: context.palette.textMuted, fontWeight: FontWeight.w600, fontSize: 12.5));
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.palette.text),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: context.palette.text)),
      subtitle: subtitle == null ? null : Text(subtitle!, style: TextStyle(fontSize: 12, color: context.palette.textMuted)),
      trailing: Switch(value: value, onChanged: onChanged, activeTrackColor: context.palette.success),
    );
  }
}
