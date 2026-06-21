import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/db_logo.dart';
import '../../application/auth_controller.dart';

/// Wire this in a page's `build` to surface [AuthController] failures as a
/// SnackBar. Safe to call once per build (ref.listen dedupes).
void listenAuthErrors(WidgetRef ref, BuildContext context) {
  ref.listen<AsyncValue<void>>(authControllerProvider, (prev, next) {
    if (next is AsyncError) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('${next.error}'), backgroundColor: AppColors.red));
    }
  });
}

/// Shared auth screen scaffold: optional back button + centered logo, then
/// scrollable content over the app background.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.children,
    this.showBack = true,
    this.showLogo = true,
  });

  final List<Widget> children;
  final bool showBack;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: showBack
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            icon: const Icon(Icons.arrow_back, size: 22, color: AppColors.ink),
                            onPressed: () => Navigator.of(context).maybePop(),
                          )
                        : null,
                  ),
                  Expanded(child: Center(child: showLogo ? const DbLogo(size: 18) : const SizedBox())),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Title + optional subtitle block.
class AuthHero extends StatelessWidget {
  const AuthHero({super.key, required this.title, this.subtitle, this.big = false, this.center = false});

  final String title;
  final String? subtitle;
  final bool big;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = center ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(title, textAlign: textAlign, style: TextStyle(fontSize: big ? 30 : 26, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5, color: AppColors.ink)),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, textAlign: textAlign, style: const TextStyle(fontSize: 14, height: 1.45, color: AppColors.muted)),
        ],
      ],
    );
  }
}

/// 84pt round tinted icon badge used atop forgot/verify/reset screens.
class HeroBadge extends StatelessWidget {
  const HeroBadge({super.key, required this.background, required this.foreground, required this.icon});

  final Color background;
  final Color foreground;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: 36, color: foreground),
    );
  }
}

/// "OR CONTINUE WITH" divider.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.label = 'or continue with'});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 18),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.hairline, height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label.toUpperCase(), style: const TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 1.2)),
          ),
          const Expanded(child: Divider(color: AppColors.hairline, height: 1)),
        ],
      ),
    );
  }
}

enum SocialProvider { google, apple }

/// Outlined "Continue with Google/Apple" button.
class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.provider, required this.onPressed});

  final SocialProvider provider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isApple = provider == SocialProvider.apple;
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: isApple
            ? const Icon(Icons.apple, size: 22, color: Colors.black)
            : const Icon(Icons.g_mobiledata, size: 30, color: AppColors.chipBlue),
        label: Text('Continue with ${isApple ? 'Apple' : 'Google'}'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          backgroundColor: AppColors.paper,
          side: const BorderSide(color: AppColors.hairline, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'PlusJakartaSans'),
        ),
      ),
    );
  }
}

/// Inline link styled like the design's blue links.
class InlineLink extends StatelessWidget {
  const InlineLink({super.key, required this.lead, required this.action, required this.onTap});

  final String lead;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(lead, style: const TextStyle(fontSize: 13, color: AppColors.ink2)),
        GestureDetector(
          onTap: onTap,
          child: Text(action, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.chipBlue)),
        ),
      ],
    );
  }
}
