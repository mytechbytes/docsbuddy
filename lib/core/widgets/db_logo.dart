import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// "Docs**Buddy**" wordmark — `DBLogo` in the design handoff.
class DbLogo extends StatelessWidget {
  const DbLogo({super.key, this.size = 17});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
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
  }
}
