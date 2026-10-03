import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/features/app_feature.dart';
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
      context.showFailure(next.error, next.stackTrace);
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
                            alignment: AlignmentDirectional.centerStart,
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
        Text(title, textAlign: textAlign, style: TextStyle(fontSize: big ? 30 : 26, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: context.tracking(-0.5), color: context.palette.text)),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, textAlign: textAlign, style: TextStyle(fontSize: 14, height: 1.45, color: context.palette.textMuted)),
        ],
      ],
    );
  }
}

/// Centered brand lockup (app icon + "DocsBuddy") that heads sign-in and
/// sign-up in place of a title and tagline.
class AuthBrand extends StatelessWidget {
  const AuthBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Center(child: DbLogo(size: 34, stacked: true, showWordmark: false,)),
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
          // Flexible, so with large text the label wraps between the rules
          // instead of running off the row.
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text((label ?? context.l10n.authOrContinueWith).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: context.palette.textMuted, letterSpacing: context.tracking(1.2))),
            ),
          ),
          Expanded(child: Divider(color: context.palette.hairline, height: 1)),
        ],
      ),
    );
  }
}

/// Social sign-in providers on the auth screens. [enabled] follows the central
/// [AppFeature] switch: Apple and Microsoft stay off until their console and
/// Supabase setup is done (docs/social-sign-in.md, Parts 4 and 5).
enum SocialProvider {
  google(null),
  apple(AppFeature.appleSignIn),
  microsoft(AppFeature.microsoftSignIn);

  const SocialProvider(this._feature);

  /// What has to be live for this provider; null when it always is (Google).
  final AppFeature? _feature;

  bool get enabled => _feature?.live ?? true;
}

/// Outlined "Continue with Google/Apple/Microsoft" button. Rendered dimmed and
/// inert when the provider isn't [SocialProvider.enabled].
class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.provider, required this.onPressed});

  final SocialProvider provider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = provider.enabled;
    final (icon, label) = switch (provider) {
      SocialProvider.google => (
          Icon(Icons.g_mobiledata, size: 30, color: context.palette.accent) as Widget,
          context.l10n.authContinueWithGoogle,
        ),
      SocialProvider.apple => (Icon(Icons.apple, size: 22, color: context.palette.text), context.l10n.authContinueWithApple),
      SocialProvider.microsoft => (const _MicrosoftLogo(), context.l10n.authContinueWithMicrosoft),
    };
    // 50dp is a minimum: with large text the label wraps and the button grows.
    return OutlinedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: enabled ? icon : Opacity(opacity: 0.45, child: icon),
      label: Text(label, textAlign: TextAlign.center),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        foregroundColor: context.palette.text,
        backgroundColor: context.palette.surface,
        disabledForegroundColor: context.palette.textMuted,
        disabledBackgroundColor: context.palette.surface,
        side: BorderSide(color: context.palette.hairline, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'PlusJakartaSans'),
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
    // Wraps onto a second line when large text leaves no room for both.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(lead, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: context.palette.textSecondary)),
        GestureDetector(
          onTap: onTap,
          child: Text(action, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.palette.accent)),
        ),
      ],
    );
  }
}
