import 'package:flutter/material.dart';

/// DocsBuddy design tokens — lifted verbatim from the design handoff
/// (`design/screens/shared.jsx` `DB_COLORS`). Keep these literal.
abstract final class AppColors {
  // Neutrals
  static const bg = Color(0xFFF4F6FA);

  /// Launch-screen background: the launcher icon's tint, so the native splash,
  /// the startup screen and the app icon all read as one brand moment.
  static const splashBackground = Color(0xFFE8F3F7);
  static const paper = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0D1A2B); // primary text
  static const ink2 = Color(0xFF324159); // secondary text
  static const muted = Color(0xFF6B7891); // tertiary / metadata
  static const line = Color(0xFFE7EBF2); // borders / dividers
  static const indicatorIdle = Color(0xFFD6DCE6);

  // Form inputs (auth)
  static const fieldBorder = Color(0xFFE6EBF3); // input idle border
  static const hairline = Color(0xFFE1E6EF); // dividers / social button border
  static const placeholder = Color(0xFFA3ACBA); // input placeholder text
  static const eyeIcon = Color(0xFF94A0B3); // password visibility toggle

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

  // Inverse: dark fills (primary buttons, selected chips) and what sits on them
  static const inverseSurface = ink;
  static const onInverse = paper;

  // Surfaces & accents
  static const blueSoft = Color(0xFFEEF3FB); // icon tiles, chips, info banners, nav indicator
  static const lineSoft = Color(0xFFEEF2F8); // subtle card borders
  static const amberSoft = Color(0xFFFDF1E0);
  static const amberDeep = Color(0xFFC68318);
  static const shadow = Color(0xFF0F1E37); // base for drop shadows (apply alpha)

  // Dashboard stat cards
  static const statSoonBg = Color(0xFFC9D6E0);
  static const statExpiredBg = Color(0xFFE89098);

  // Default avatar gradient
  static const avatarGradient = [Color(0xFFF1C27D), Color(0xFFD68B5C)];

  // Reminder-type bubble palette (bg, fg) — REMINDER_TYPES in shared.jsx
  static const insuranceBg = Color(0xFFE1F1F5);
  static const insuranceFg = Color(0xFF3A8FA3);
  static const pollutionBg = Color(0xFFE3F5E7);
  static const pollutionFg = Color(0xFF3FA75C);
  static const amcBg = amberSoft;
  static const amcFg = amberDeep;
  static const serviceBg = Color(0xFFFBE7EE);
  static const serviceFg = Color(0xFFC63D75);
  static const taxBg = Color(0xFFE8E4F7);
  static const taxFg = Color(0xFF6C52C2);
  static const warrantyBg = Color(0xFFDFECFF);
  static const warrantyFg = chipBlue;
  static const registrationBg = Color(0xFFE5EFE8);
  static const registrationFg = Color(0xFF4D8A64);
  static const otherKindBg = Color(0xFFEEF1F6);

  // Microsoft brand mark
  static const msRed = Color(0xFFF25022);
  static const msGreen = Color(0xFF7FBA00);
  static const msBlue = Color(0xFF00A4EF);
  static const msYellow = Color(0xFFFFB900);

  // Onboarding illustrations
  static const illustrationLabel = Color(0xFF7A6A53);
  static const tintBlue = Color(0xFFEAF0FB);
  static const tintGreen = Color(0xFFE7F4EC);
  static const tileSand = Color(0xFFE8D9C4);
  static const tileSlate = Color(0xFFDEE2EA);
  static const tileSage = Color(0xFFDDE9E2);
  static const amberLight = Color(0xFFFBD58A);

  // Family avatar gradients (illustration 4)
  static const familyAvatars = [
    [Color(0xFFF1C27D), Color(0xFFD68B5C)],
    [Color(0xFFA8C5E8), Color(0xFF5D80B6)],
    [Color(0xFFF4B4C3), Color(0xFFC47093)],
    [Color(0xFFBCE0C2), Color(0xFF5D9C6B)],
  ];
}
