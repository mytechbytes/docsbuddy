import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/db_logo.dart';
import '../../application/auth_controller.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';

/// Wire this in a page's `build` to surface [AuthController] failures as a
/// SnackBar. Safe to call once per build (ref.listen dedupes).
void listenAuthErrors(WidgetRef ref, BuildContext context) {
  ref.listen<AsyncValue<void>>(authControllerProvider, (prev, next) {
    if (next is AsyncError) {
      context.showFailure(next.error);
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
      backgroundColor: context.palette.background,
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
                            icon: Icon(Icons.arrow_back, size: 22, color: context.palette.text),
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
        Text(title, textAlign: textAlign, style: TextStyle(fontSize: big ? 30 : 26, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5, color: context.palette.text)),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, textAlign: textAlign, style: TextStyle(fontSize: 14, height: 1.45, color: context.palette.textMuted)),
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
  const OrDivider({super.key, this.label});

  /// Defaults to the localized "or continue with".
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 18),
      child: Row(
        children: [
          Expanded(child: Divider(color: context.palette.hairline, height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text((label ?? context.l10n.authOrContinueWith).toUpperCase(),
                style: TextStyle(fontSize: 11, color: context.palette.textMuted, letterSpacing: 1.2)),
          ),
          Expanded(child: Divider(color: context.palette.hairline, height: 1)),
        ],
      ),
    );
  }
}

enum SocialProvider { google, apple, microsoft }

/// Outlined "Continue with Google/Apple/Microsoft" button.
class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.provider, required this.onPressed});

  final SocialProvider provider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (provider) {
      SocialProvider.google => (
          Icon(Icons.g_mobiledata, size: 30, color: context.palette.accent) as Widget,
          context.l10n.authContinueWithGoogle,
        ),
      SocialProvider.apple => (Icon(Icons.apple, size: 22, color: context.palette.text), context.l10n.authContinueWithApple),
      SocialProvider.microsoft => (const _MicrosoftLogo(), context.l10n.authContinueWithMicrosoft),
    };
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.palette.text,
          backgroundColor: context.palette.surface,
          side: BorderSide(color: context.palette.hairline, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'PlusJakartaSans'),
        ),
      ),
    );
  }
}

/// Microsoft's four-square mark (brand colours, fixed in both themes).
class _MicrosoftLogo extends StatelessWidget {
  const _MicrosoftLogo();

  static const _squares = [AppColors.msRed, AppColors.msGreen, AppColors.msBlue, AppColors.msYellow];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        physics: const NeverScrollableScrollPhysics(),
        children: [for (final c in _squares) ColoredBox(color: c)],
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
        Text(lead, style: TextStyle(fontSize: 13, color: context.palette.textSecondary)),
        GestureDetector(
          onTap: onTap,
          child: Text(action, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.accent)),
        ),
      ],
    );
  }
}
