import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/widgets/buttons.dart';
import 'package:docsbuddy/core/widgets/db_logo.dart';
import 'package:docsbuddy/core/widgets/feedback.dart';
import 'package:docsbuddy/core/widgets/settings_list.dart';
import 'package:docsbuddy/core/widgets/startup_screen.dart';
import 'package:docsbuddy/core/widgets/step_flow.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../support/demo_field.dart';
import '../support/use_cases.dart';

void _noop() {}

WidgetbookCategory coreWidgets() => WidgetbookCategory(
      name: 'Core widgets',
      children: [
        WidgetbookComponent(name: 'PrimaryButton', useCases: [
          component(
            'Playground',
            (context) => PrimaryButton(
              label: context.knobs.string(label: 'Label', initialValue: 'Save asset'),
              isLoading: context.knobs.boolean(label: 'Loading'),
              onPressed: _noop,
            ),
          ),
          gallery('States', [
            Labeled('Default', PrimaryButton(label: 'Continue', onPressed: _noop)),
            Labeled('Loading (taps ignored)', PrimaryButton(label: 'Continue', isLoading: true, onPressed: _noop)),
            Labeled('Long label', PrimaryButton(label: 'Create my family and invite everyone', onPressed: _noop)),
          ]),
        ]),
        WidgetbookComponent(name: 'GhostButton', useCases: [
          component(
            'Playground',
            (context) => GhostButton(
              label: context.knobs.string(label: 'Label', initialValue: 'Join with code'),
              onPressed: _noop,
            ),
          ),
          gallery('Beside a primary button', [
            Labeled('Stacked as in the family empty state', Column(children: [
              PrimaryButton(label: 'Create a family', onPressed: _noop),
              const SizedBox(height: 10),
              GhostButton(label: 'Join with code', onPressed: _noop),
            ])),
          ]),
        ]),
        WidgetbookComponent(name: 'AppTextField', useCases: [
          component(
            'Playground',
            (context) => DemoTextField(
              label: context.knobs.string(label: 'Label', initialValue: 'Email'),
              hint: context.knobs.stringOrNull(label: 'Hint', initialValue: 'you@example.com'),
              text: context.knobs.string(label: 'Text'),
              errorText: context.knobs.stringOrNull(label: 'Error', initialValue: null),
              icon: context.knobs.boolean(label: 'Leading icon', initialValue: true) ? Icons.mail_outline : null,
              obscure: context.knobs.boolean(label: 'Password field'),
            ),
          ),
          gallery('States', [
            const Labeled('Empty with hint', DemoTextField(label: 'Email', hint: 'you@example.com', icon: Icons.mail_outline)),
            const Labeled('Filled', DemoTextField(label: 'Email', text: 'anand.kumar@example.com', icon: Icons.mail_outline)),
            const Labeled('Password (tap the eye)',
                DemoTextField(label: 'Password', text: 'hunter2hunter2', icon: Icons.lock_outline, obscure: true)),
            const Labeled('Error',
                DemoTextField(label: 'Email', text: 'anand@', icon: Icons.mail_outline, errorText: 'Enter a valid email address.')),
            const Labeled('Long error wraps',
                DemoTextField(
                    label: 'New password',
                    obscure: true,
                    icon: Icons.lock_outline,
                    text: 'short',
                    errorText: 'Password must be at least 8 characters and include a number and a symbol.')),
            const Labeled('No icon', DemoTextField(label: 'Display name', hint: 'What should we call you?')),
          ]),
        ]),
        WidgetbookComponent(name: 'DbLogo', useCases: [
          component(
            'Playground',
            (context) => DbLogo(
              size: context.knobs.double.slider(label: 'Size', initialValue: 34, min: 12, max: 64),
              showMark: context.knobs.boolean(label: 'Show mark', initialValue: true),
              stacked: context.knobs.boolean(label: 'Stacked (mark above wordmark)'),
            ),
          ),
          gallery('Sizes in use', [
            const Labeled('Header (17–20)', DbLogo(size: 20)),
            const Labeled('Auth header (18)', DbLogo(size: 18)),
            const Labeled('Auth brand (34)', DbLogo(size: 34)),
            const Labeled('Stacked, as on the startup screen (34)', Center(child: DbLogo(size: 34, stacked: true))),
            const Labeled('Wordmark only', DbLogo(size: 20, showMark: false)),
          ]),
        ]),
        WidgetbookComponent(name: 'Settings list', useCases: [
          component('Grouped card', (_) => const _SettingsGroup(), alignment: Alignment.topCenter),
          gallery('Rows', [
            Labeled('SettingsRow', SettingsCard(children: [
              SettingsRow(icon: Icons.person_outline, title: 'Profile', onTap: _noop),
              SettingsRow(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  trailing: const SettingsValue('System'),
                  onTap: _noop),
              SettingsRow(icon: Icons.logout, title: 'Sign out', danger: true, onTap: _noop),
            ])),
            Labeled('SettingsToggleRow', SettingsCard(children: [
              SettingsToggleRow(
                  icon: Icons.notifications_outlined, title: 'Push', subtitle: 'On this device', value: true, onChanged: (_) {}),
              SettingsToggleRow(icon: Icons.mail_outline, title: 'Email', value: false, onChanged: (_) {}),
              const SettingsToggleRow(icon: Icons.chat_outlined, title: 'WhatsApp', value: false, onChanged: null),
            ])),
            const Labeled('Section label', SectionLabel('Notifications')),
          ]),
        ]),
        WidgetbookComponent(name: 'Step flow', useCases: [
          component(
            'StepHeader playground',
            (context) {
              final total = context.knobs.int.slider(label: 'Steps', initialValue: 3, min: 2, max: 6);
              return StepHeader(
                step: context.knobs.int.slider(label: 'Current (0-based)', initialValue: 1, min: 0, max: total - 1),
                total: total,
                title: context.knobs.string(label: 'Title', initialValue: 'Purchase details'),
                subtitle: context.knobs.stringOrNull(label: 'Subtitle', initialValue: 'Helps track warranty.'),
              );
            },
            alignment: Alignment.topCenter,
          ),
          gallery('StepNav', [
            Labeled('First step (no Back)', StepNav(step: 0, nextLabel: 'Next', onNext: _noop, onBack: _noop)),
            Labeled('Middle step', StepNav(step: 1, nextLabel: 'Next', onNext: _noop, onBack: _noop)),
            Labeled('Last step, saving', StepNav(step: 2, nextLabel: 'Save', onNext: _noop, onBack: _noop, busy: true)),
          ]),
        ]),
        WidgetbookComponent(name: 'StartupScreen', useCases: [
          screen('Progress', (_) => const StartupScreen.progress(message: 'Connecting to your account…', stepLabel: 'Step 2 of 3'),
              root: true),
          screen(
              'Progress, long message',
              (_) => const StartupScreen.progress(
                  message: 'Still connecting to your account, this is taking longer than usual…', stepLabel: 'Step 2 of 3'),
              root: true),
          screen(
            'Failed',
            (_) => StartupScreen.failed(
              title: 'We couldn’t start DocsBuddy',
              body: 'Check your connection and try again.',
              retryLabel: 'Try again',
              onRetry: _noop,
            ),
            root: true,
          ),
        ]),
        WidgetbookComponent(name: 'Feedback snackbars', useCases: [
          component(
            'Success and failure',
            (_) => Builder(
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(label: 'Show success', onPressed: () => context.showSuccess('Asset saved')),
                  const SizedBox(height: 10),
                  GhostButton(label: 'Show failure: offline', onPressed: () => context.showFailure(const NetworkFailure())),
                  const SizedBox(height: 10),
                  GhostButton(
                      label: 'Show failure: server message',
                      onPressed: () => context.showFailure(const ServerFailure('Asset not found.'))),
                  const SizedBox(height: 10),
                  GhostButton(
                      label: 'Show failure: unknown error', onPressed: () => context.showFailure(StateError('boom'))),
                ],
              ),
            ),
          ),
        ]),
      ],
    );

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel('Account', topPadding: 0),
        SettingsCard(children: [
          SettingsRow(icon: Icons.person_outline, title: 'Profile', onTap: _noop),
          SettingsRow(icon: Icons.lock_outline, title: 'Change password', onTap: _noop),
          SettingsRow(
              icon: Icons.verified_user_outlined,
              title: 'Two-step verification',
              trailing: const SettingsValue('On'),
              onTap: _noop),
        ]),
        const SectionLabel('Notifications'),
        SettingsCard(children: [
          SettingsToggleRow(
              icon: Icons.notifications_outlined,
              title: 'Push notifications',
              subtitle: 'Reminders on this device',
              value: true,
              onChanged: (_) {}),
          SettingsToggleRow(icon: Icons.mail_outline, title: 'Email', value: false, onChanged: (_) {}),
        ]),
        const SectionLabel('Session'),
        SettingsCard(children: [SettingsRow(icon: Icons.logout, title: 'Sign out', danger: true, onTap: _noop)]),
      ],
    );
  }
}
