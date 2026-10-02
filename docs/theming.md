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

## Large text and small screens

People who raise the system font size (and shrink the screen with "display
size") must be able to read everything, so layouts adapt instead of squeezing.
The helpers are in `core/widgets/adaptive_layout.dart`.

- **Decide on `width / textScale`**, not on width or scale alone: `fitsAtScale`.
  Large text on a wide screen and normal text on a narrow one are then treated alike.
- **Stack when it doesn't fit.** A row of text beside a badge, a switch or a
  second column becomes a column (`BadgedTile`, `TwoUp`, or a `LayoutBuilder`
  with `fitsAtScale`). Keep today's layout above the threshold.
- **Never fix a height.** Use `minHeight` / `minimumSize`; let boxes grow with
  their text. Grids use `mainAxisExtent` from the content (see
  `CategoryCard.minHeight`), not `childAspectRatio`.
- **Wrap primary content** (names, titles). `context.primaryLines` /
  `primaryOverflow` give one line with an ellipsis at normal size and free
  wrapping once the font is enlarged. Ellipsis is for secondary detail only.
- **Cap what can't grow:** logos and avatar initials ignore the font scale
  (`TextScaler.noScaling`); the bottom nav labels and Settings rows are clamped
  (`MediaQuery.withClampedTextScaling`); decorative art is excluded from
  semantics.

Check a change in the widget catalog (`widgetbook/`): Dark, Text scale 2.0,
*Phone · compact*. `flutter test test/widgetbook --dart-define=WIDGETBOOK_STRESS=true
--plain-name stress` fails on overflow, broken words and clipped text.
