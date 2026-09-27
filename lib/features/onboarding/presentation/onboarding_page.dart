import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/db_logo.dart';
import '../application/onboarding_controller.dart';
import 'widgets/onboarding_illustrations.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';

/// First-launch walkthrough — 4 swipeable slides (`Onboarding.jsx` in the
/// design handoff). Shown only when onboarding has not been completed on this
/// device; the route guard lives in `routing/app_router.dart`.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _slideCount = 4;

  static List<_SlideData> _slides(AppLocalizations l) => [
        _SlideData(eyebrow: l.onboardingEyebrow1, title: l.onboardingTitle1, subtitle: l.onboardingBody1),
        _SlideData(eyebrow: l.onboardingEyebrow2, title: l.onboardingTitle2, subtitle: l.onboardingBody2),
        _SlideData(eyebrow: l.onboardingEyebrow3, title: l.onboardingTitle3, subtitle: l.onboardingBody3),
        _SlideData(eyebrow: l.onboardingEyebrow4, title: l.onboardingTitle4, subtitle: l.onboardingBody4),
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() => _controller.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOut);

  Future<void> _finish(String route) async {
    await ref.read(onboardingControllerProvider.notifier).complete();
    if (mounted) context.go(route);
  }

  Widget _illustrationFor(int i) => switch (i) {
        0 => const IlloWelcome(),
        1 => const IlloAssets(),
        2 => const IlloReminders(),
        _ => const IlloFamily(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top row: logo + skip
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DbLogo(),
                  if (_index < _slideCount - 1)
                    GestureDetector(
                      onTap: () => _finish(AppRoutes.signIn),
                      child: Text(context.l10n.commonSkip, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.muted)),
                    )
                  else
                    const SizedBox(width: 28),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slideCount,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _Slide(
                  data: _slides(context.l10n)[i],
                  index: i,
                  total: _slideCount,
                  illustration: _illustrationFor(i),
                  onPrimary: i < _slideCount - 1 ? _next : () => _finish(AppRoutes.signUp),
                  primaryLabel: switch (i) {
                    0 => context.l10n.onboardingGetStarted,
                    3 => context.l10n.authCreateAccountCta,
                    _ => context.l10n.commonNext,
                  },
                  secondaryLabel: i == _slideCount - 1 ? context.l10n.onboardingHaveAccount : null,
                  onSecondary: i == _slideCount - 1 ? () => _finish(AppRoutes.signIn) : null,
                  footer: i == 0 ? _SignInFooter(onTap: () => _finish(AppRoutes.signIn)) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  const _SlideData({required this.eyebrow, required this.title, required this.subtitle});
  final String eyebrow;
  final String title;
  final String subtitle;
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.data,
    required this.index,
    required this.total,
    required this.illustration,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.footer,
  });

  final _SlideData data;
  final int index;
  final int total;
  final Widget illustration;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Illustration + indicator + copy — scrolls if the screen is short,
        // centers vertically when there's room.
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: FittedBox(fit: BoxFit.scaleDown, child: illustration),
                    ),
                    const SizedBox(height: 20),
                    // Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < total; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 6,
                            width: i == index ? 22 : 6,
                            decoration: BoxDecoration(
                              color: i == index ? AppColors.ink : AppColors.indicatorIdle,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Copy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.blueSoft, borderRadius: BorderRadius.circular(999)),
                            child: Text(
                              data.eyebrow.toUpperCase(),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.chipBlue, letterSpacing: 0.66),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5, color: AppColors.ink),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Buttons (pinned to the bottom)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 4),
          child: Column(
            children: [
              PrimaryButton(label: primaryLabel, onPressed: onPrimary),
              if (secondaryLabel != null && onSecondary != null) ...[
                const SizedBox(height: 10),
                GhostButton(label: secondaryLabel!, onPressed: onSecondary!),
              ],
            ],
          ),
        ),
        if (footer != null) Padding(padding: const EdgeInsets.only(top: 14), child: footer!),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SignInFooter extends StatelessWidget {
  const _SignInFooter({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.l10n.onboardingAlreadyWithUs, style: const TextStyle(fontSize: 13, color: AppColors.ink2)),
        GestureDetector(
          onTap: onTap,
          child: Text(context.l10n.commonSignIn, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.chipBlue)),
        ),
      ],
    );
  }
}
