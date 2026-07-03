import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Brand mark + "Docs**Buddy**" wordmark — `DBLogo` in the design handoff.
/// The mark is the provided gradient-Z logo (`assets/icon/source_logo.png`),
/// the same file every launcher/store icon derives from.
class DbLogo extends StatelessWidget {
  const DbLogo({super.key, this.size = 17, this.showMark = true});

  final double size;

  /// Hide to render the wordmark alone (tight headers).
  final bool showMark;

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
        children: const [
          TextSpan(text: 'Docs', style: TextStyle(color: AppColors.ink)),
          TextSpan(text: 'Buddy', style: TextStyle(color: AppColors.muted)),
        ],
      ),
    );
    if (!showMark) return wordmark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icon/source_logo.png',
          height: size * 1.5,
          filterQuality: FilterQuality.medium,
        ),
        SizedBox(width: size * 0.4),
        wordmark,
      ],
    );
  }
}
