import 'dart:async';

import 'package:flutter/material.dart';

import '../core/l10n/l10n.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/startup_screen.dart';
import 'app_startup.dart';

/// Draws the app straight away and shows [StartupScreen] — progress, or a
/// retry if a step fails — while [startup] runs, then swaps in the real app.
/// Without it nothing is drawn until every init step finishes, so the app
/// looks frozen (and stays blank forever if one of them throws).
class StartupGate extends StatefulWidget {
  const StartupGate({super.key, required this.startup, required this.appBuilder});

  final AppStartup startup;

  /// Builds the real app once startup succeeded.
  final Widget Function(AppBootstrap bootstrap) appBuilder;

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  StartupState _state = const StartupRunning(StartupStep.services);
  StreamSubscription<StartupState>? _subscription;
  Widget? _app;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  void _listen() {
    _subscription?.cancel();
    _subscription = widget.startup.run().listen((state) {
      if (mounted) setState(() => _state = state);
    });
  }

  void _retry() {
    setState(() => _state = const StartupRunning(StartupStep.services));
    _listen();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_state case StartupReady(:final bootstrap)) return _app ??= widget.appBuilder(bootstrap);

    // The real MaterialApp (router, providers) doesn't exist yet, so this
    // screen brings its own localisation and theme.
    return MaterialApp(
      title: 'DocsBuddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: _screen),
    );
  }

  Widget _screen(BuildContext context) {
    final l10n = context.l10n;
    return switch (_state) {
      StartupRunning(:final step) => StartupScreen.progress(
          message: switch (step) {
            StartupStep.services => l10n.startupStepServices,
            StartupStep.account => l10n.startupStepAccount,
            StartupStep.preferences => l10n.startupStepPreferences,
          },
          stepLabel: l10n.startupStepCount(step.index + 1, StartupStep.values.length),
        ),
      final state => StartupScreen.failed(
          title: l10n.startupFailedTitle,
          body: l10n.startupFailedBody,
          detail: state is StartupFailed ? state.summary : null,
          retryLabel: l10n.startupRetry,
          onRetry: _retry,
        ),
    };
  }
}
