import 'package:docsbuddy/core/theme/app_colors.dart';
import 'package:docsbuddy/features/onboarding/presentation/widgets/onboarding_illustrations.dart';
import 'package:docsbuddy/features/profile/presentation/widgets/profile_avatar_button.dart';
import 'package:docsbuddy/features/security/presentation/widgets/security_widgets.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../support/demo_data.dart';
import '../support/scenario.dart';
import '../support/use_cases.dart';

WidgetbookFolder profileWidgets() => WidgetbookFolder(
      name: 'Profile',
      children: [
        WidgetbookComponent(name: 'ProfileAvatarButton', useCases: [
          component(
            'Signed in',
            (context) => ProfileAvatarButton(
                size: context.knobs.double.slider(label: 'Size', initialValue: 32, min: 20, max: 96)),
          ),
          component(
            'Profile still loading',
            (_) => const ProfileAvatarButton(size: 48),
            scenario: Scenario.loading,
          ),
        ]),
      ],
    );

WidgetbookFolder securityWidgets() => WidgetbookFolder(
      name: 'Security',
      children: [
        WidgetbookComponent(name: 'TotpEnrollSheet', useCases: [
          filling('Authenticator setup', (_) => SheetFrame(child: TotpEnrollSheet(enrollment: demoEnrollment))),
        ]),
        WidgetbookComponent(name: 'BiometricTypesRow', useCases: [
          component('Face ID and fingerprint', (_) => const BiometricTypesRow()),
        ]),
      ],
    );

WidgetbookFolder onboardingWidgets() => WidgetbookFolder(
      name: 'Onboarding',
      children: [
        WidgetbookComponent(name: 'IlloStage', useCases: [
          component(
            'Playground',
            (context) => IlloStage(
              tint: context.knobs.object.dropdown(
                label: 'Tint',
                options: const [AppColors.tintBlue, AppColors.tintGreen, AppColors.amberSoft],
                labelBuilder: (c) => c == AppColors.tintBlue
                    ? 'Blue'
                    : c == AppColors.tintGreen
                        ? 'Green'
                        : 'Amber',
              ),
              size: context.knobs.double.slider(label: 'Size', initialValue: 250, min: 120, max: 360),
              child: const Icon(Icons.home_outlined, size: 56, color: AppColors.navy),
            ),
          ),
        ]),
        WidgetbookComponent(name: 'Illustrations', useCases: [
          component('Welcome', (_) => const IlloWelcome()),
          component('Assets', (_) => const IlloAssets()),
          component('Reminders', (_) => const IlloReminders()),
          component('Family', (_) => const IlloFamily()),
        ]),
      ],
    );
