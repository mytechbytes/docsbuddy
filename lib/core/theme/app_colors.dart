import 'package:flutter/material.dart';

/// DocsBuddy design tokens — lifted verbatim from the design handoff
/// (`design/screens/shared.jsx` `DB_COLORS`). Keep these literal.
abstract final class AppColors {
  // Neutrals
  static const bg = Color(0xFFF4F6FA);
  static const paper = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0D1A2B); // primary text
  static const ink2 = Color(0xFF324159); // secondary text
  static const muted = Color(0xFF6B7891); // tertiary / metadata
  static const line = Color(0xFFE7EBF2); // borders / dividers
  static const indicatorIdle = Color(0xFFD6DCE6);

  // Brand
  static const navy = Color(0xFF1F3A5F);
  static const teal = Color(0xFF2A7F9E);
  static const chipBlue = Color(0xFF2476E8);

  // Semantic
  static const green = Color(0xFF1EA765);
  static const greenSoft = Color(0xFFE3F5E7);
  static const greenLeaf = Color(0xFF3FA75C);
  static const red = Color(0xFFD24B54);
  static const redSoft = Color(0xFFFDEBEC);
  static const amber = Color(0xFFD8901A);
  static const shieldBlue = Color(0xFF3A8FA3);

  // Card gradients (onboarding illustrations)
  static const cardNavy = [Color(0xFF1F3A5F), Color(0xFF2A4A6E)];
  static const cardTeal = [Color(0xFF2A7F9E), Color(0xFF3AA1BB)];

  // Reminder-type bubble palette (bg, fg) — REMINDER_TYPES in shared.jsx
  static const insuranceBg = Color(0xFFE1F1F5);
  static const insuranceFg = Color(0xFF3A8FA3);
  static const pollutionBg = Color(0xFFE3F5E7);
  static const pollutionFg = Color(0xFF3FA75C);

  // Family avatar gradients (illustration 4)
  static const familyAvatars = [
    [Color(0xFFF1C27D), Color(0xFFD68B5C)],
    [Color(0xFFA8C5E8), Color(0xFF5D80B6)],
    [Color(0xFFF4B4C3), Color(0xFFC47093)],
    [Color(0xFFBCE0C2), Color(0xFF5D9C6B)],
  ];
}
