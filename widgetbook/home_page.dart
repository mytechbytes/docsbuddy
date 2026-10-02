import 'package:flutter/material.dart';

import 'config/devices.dart';

/// Shown until a use case is picked. Widgetbook renders it in its own chrome
/// (not the app's theme), so it uses plain Material.
class CatalogHomePage extends StatelessWidget {
  const CatalogHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    Widget step(String lead, String text) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
              children: [
                TextSpan(text: '$lead  ', style: const TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(text: text, style: TextStyle(color: muted)),
              ],
            ),
          ),
        );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.all(32),
          shrinkWrap: true,
          children: [
            Text('DocsBuddy catalog', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              'Every widget and screen the app draws, in light and dark, on any screen size and at any font scale.',
              style: theme.textTheme.bodyLarge?.copyWith(color: muted, height: 1.45),
            ),
            const SizedBox(height: 28),
            step('Browse', 'Foundations, core widgets, feature widgets, then whole screens. Pick a use case on the left.'),
            step('Addons', 'on the right: Theme (light/dark), Text scale, Zoom, Viewport (phones, tablets, landscape) and Inspector.'),
            step('Knobs', 'on the right: live controls for the selected widget, where it has any.'),
            step('Screens', 'are the real pages on an in-memory fake backend, each in Populated, Empty, Loading and Error '
                'where that applies. Leaving a screen lands on a placeholder naming the route it would open.'),
            const SizedBox(height: 18),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Worst-case check', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      'Theme Dark · Text scale 2.0 · Viewport "${ScreenSizes.compactPhone.name}". '
                      'That is a small phone with the largest font setting, which real users do configure.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: muted, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
