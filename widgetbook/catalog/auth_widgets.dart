import 'package:docsbuddy/core/theme/app_colors.dart';
import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:docsbuddy/core/widgets/buttons.dart';
import 'package:docsbuddy/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../support/demo_field.dart';
import '../support/use_cases.dart';

void _noop() {}

WidgetbookFolder authWidgets() => WidgetbookFolder(
      name: 'Auth',
      children: [
        WidgetbookComponent(name: 'AuthScaffold', useCases: [
          screen('With back and logo', (_) => _scaffold()),
          screen('No back button', (_) => _scaffold(showBack: false)),
          screen('No logo', (_) => _scaffold(showLogo: false)),
        ]),
        WidgetbookComponent(name: 'AuthHero', useCases: [
          component(
            'Playground',
            (context) => AuthHero(
              title: context.knobs.string(label: 'Title', initialValue: 'Welcome back'),
              subtitle: context.knobs.stringOrNull(label: 'Subtitle', initialValue: 'Sign in to keep every renewal in one place.'),
              big: context.knobs.boolean(label: 'Big'),
              center: context.knobs.boolean(label: 'Centered'),
            ),
          ),
          gallery('Variants', const [
            Labeled('Left aligned', AuthHero(title: 'Create account', subtitle: 'It only takes a minute.')),
            Labeled('Big and centered',
                AuthHero(title: 'Verify your email', subtitle: 'We sent a 6-digit code to you@example.com.', big: true, center: true)),
            Labeled('Title only', AuthHero(title: 'Reset password')),
            Labeled('Long title wraps',
                AuthHero(title: 'Choose a new password for your DocsBuddy account', subtitle: 'Make it one you do not use anywhere else.')),
          ]),
        ]),
        WidgetbookComponent(name: 'AuthBrand', useCases: [
          component('Default', (_) => const AuthBrand()),
        ]),
        WidgetbookComponent(name: 'HeroBadge', useCases: [
          component(
            'Playground',
            (context) => HeroBadge(
              background: context.palette.accentSoft,
              foreground: context.palette.accent,
              icon: context.knobs.object.dropdown(
                label: 'Icon',
                options: const [Icons.vpn_key_outlined, Icons.mail_outline, Icons.lock_outline],
                labelBuilder: (i) => i == Icons.vpn_key_outlined
                    ? 'Key'
                    : i == Icons.mail_outline
                        ? 'Mail'
                        : 'Lock',
              ),
            ),
          ),
          component(
            'As used on the three recovery screens',
            (_) => Builder(
              builder: (context) {
                final p = context.palette;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HeroBadge(background: p.accentSoft, foreground: p.accent, icon: Icons.vpn_key_outlined),
                    const SizedBox(width: 12),
                    HeroBadge(background: p.successSoft, foreground: p.success, icon: Icons.mail_outline),
                    const SizedBox(width: 12),
                    HeroBadge(background: p.warningSoft, foreground: AppColors.amberDeep, icon: Icons.lock_outline),
                  ],
                );
              },
            ),
          ),
        ]),
        WidgetbookComponent(name: 'OrDivider', useCases: [
          component('Default label', (_) => const OrDivider()),
          component(
            'Custom label',
            (context) => OrDivider(label: context.knobs.string(label: 'Label', initialValue: 'or sign up with')),
          ),
        ]),
        WidgetbookComponent(name: 'SocialButton', useCases: [
          component(
            'Playground',
            (context) => SocialButton(
              provider: context.knobs.object.segmented(
                label: 'Provider',
                options: SocialProvider.values,
                labelBuilder: (p) => p.name,
              ),
              onPressed: _noop,
            ),
          ),
          gallery('All providers', [
            for (final provider in SocialProvider.values)
              Labeled(
                '${provider.name} · ${provider.enabled ? 'enabled' : 'switched off until its console setup is done'}',
                SocialButton(provider: provider, onPressed: _noop),
              ),
          ]),
        ]),
        WidgetbookComponent(name: 'InlineLink', useCases: [
          component(
            'Playground',
            (context) => InlineLink(
              lead: context.knobs.string(label: 'Lead', initialValue: 'New to DocsBuddy? '),
              action: context.knobs.string(label: 'Action', initialValue: 'Sign up'),
              onTap: _noop,
            ),
          ),
        ]),
      ],
    );

Widget _scaffold({bool showBack = true, bool showLogo = true}) => AuthScaffold(
      showBack: showBack,
      showLogo: showLogo,
      children: [
        const AuthBrand(),
        const SizedBox(height: 20),
        const DemoTextField(label: 'Email', icon: Icons.mail_outline, hint: 'you@example.com'),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Sign in', onPressed: _noop),
      ],
    );
