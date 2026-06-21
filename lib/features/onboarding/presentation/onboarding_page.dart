import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/db_logo.dart';
import '../application/onboarding_controller.dart';
import 'widgets/onboarding_illustrations.dart';

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

  static const _slides = <_SlideData>[
    _SlideData(eyebrow: 'Welcome', title: 'Never miss a renewal again', subtitle: 'DocsBuddy keeps track of warranties, insurance, bills and dates — so the deadlines don’t sneak up on you.'),
    _SlideData(eyebrow: 'Organise', title: 'All your assets in one place', subtitle: 'Vehicles, appliances, electronics, even documents — organised by room and category.'),
    _SlideData(eyebrow: 'Stay ahead', title: 'Smart reminders, weeks ahead', subtitle: 'Configure 60 / 30 / 7 / 1-day alerts. Push, email or WhatsApp — your choice.'),
    _SlideData(eyebrow: 'Together', title: 'Keep the whole family in sync', subtitle: 'Invite up to 8 members. Everyone gets reminded, anyone can update — no more single point of failure.'),
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
                  if (_index < _slides.length - 1)
                    GestureDetector(
                      onTap: () => _finish('/sign-in'),
                      child: const Text('Skip', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.muted)),
                    )
                  else
                    const SizedBox(width: 28),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _Slide(
                  data: _slides[i],
                  index: i,
                  total: _slides.length,
                  illustration: _illustrationFor(i),
                  onPrimary: i < _slides.length - 1 ? _next : () => _finish('/sign-up'),
                  primaryLabel: switch (i) { 0 => 'Get Started', 3 => 'Create Account', _ => 'Next' },
                  secondaryLabel: i == _slides.length - 1 ? 'I already have an account' : null,
                  onSecondary: i == _slides.length - 1 ? () => _finish('/sign-in') : null,
                  footer: i == 0 ? _SignInFooter(onTap: () => _finish('/sign-in')) : null,
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
                            decoration: BoxDecoration(color: const Color(0xFFEEF3FB), borderRadius: BorderRadius.circular(999)),
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
        const Text('Already with us? ', style: TextStyle(fontSize: 13, color: AppColors.ink2)),
        GestureDetector(
          onTap: onTap,
          child: const Text('Sign in', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.chipBlue)),
        ),
      ],
    );
  }
}
