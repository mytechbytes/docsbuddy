# Theming & dark mode

- **Tokens** live in `core/theme/app_colors.dart`. Fixed colours (brand,
  reminder-kind bubbles, stat cards, illustrations) are used directly as
  `AppColors.x`.
- **Theme-dependent colours** live in `AppPalette` (`core/theme/app_theme.dart`)
  with a `light` and a `dark` instance, read in widgets as
  `context.palette.surface`, `.text`, `.textMuted`, `.border`, `.accent`,
  `.success`, `.danger`, … Never use `AppColors.ink/paper/bg/muted/line` in
  widgets — they don't switch with the theme.
- **Inverse fills** (primary buttons, selected chips, FABs): background
  `palette.inverseSurface`, content `palette.onInverse`.
- Filled red/green/amber badges and banners with white content keep the fixed
  `AppColors` values so the white text stays readable in both modes.
- **Appearance** (System / Light / Dark) is a device-local preference:
  Settings → App → Appearance (`features/settings/application/appearance_controller.dart`).
