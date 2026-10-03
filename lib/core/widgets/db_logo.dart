import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Brand mark + "Docs**Buddy**" wordmark (`DBLogo` in the design handoff); the mark is `assets/icon/source_logo.png`.
/// It's a logo, not body text: the wordmark ignores the system font scale so it can't crowd an app bar.
class DbLogo extends StatelessWidget {
  const DbLogo({super.key, this.size = 17, this.showMark = true, this.showWordmark = true, this.stacked = false})
      : assert(showMark || showWordmark, 'A logo needs its mark, its wordmark, or both');

  /// Wordmark font size; the mark is sized from it.
  final double size;

  /// Hide to render the wordmark alone (tight headers).
  final bool showMark;

  /// Hide to render the mark alone (an avatar-sized brand tile). The mark keeps
  /// the size it has beside the wordmark, so toggling this doesn't resize it.
  final bool showWordmark;

  /// Mark above the wordmark instead of beside it: the lockup for a screen
  /// where the brand is the hero (the startup screen).
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final wordmark = Text.rich(
      TextSpan(
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontWeight: FontWeight.w800,
          fontSize: size,
          letterSpacing: -0.02 * size,
        ),
        children: [
          TextSpan(text: 'Docs', style: TextStyle(color: context.palette.text)),
          TextSpan(text: 'Buddy', style: TextStyle(color: context.palette.textMuted)),
        ],
      ),
      textScaler: TextScaler.noScaling,
    );
    // A logo scales *down* to the room it is given (an app bar title beside a
    // back arrow and three actions can be narrower than it) but never up.
    Widget fit(Widget logo) => FittedBox(fit: BoxFit.scaleDown, alignment: AlignmentDirectional.centerStart, child: logo);

    if (!showMark) return fit(wordmark);

    // Alone, the mark is the only thing naming the brand, so it says so.
    Widget mark(double height) => Image.asset(
          'assets/icon/source_logo.png',
          height: height,
          filterQuality: FilterQuality.medium,
          semanticLabel: showWordmark ? null : 'DocsBuddy',
        );

    if (!showWordmark) return fit(mark(stacked ? size * 3 : size * 1.5));

    if (stacked) {
      return fit(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            mark(size * 3),
            SizedBox(height: size * 0.5),
            wordmark,
          ],
        ),
      );
    }
    return fit(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          mark(size * 1.5),
          SizedBox(width: size * 0.4),
          wordmark,
        ],
      ),
    );
  }
}
