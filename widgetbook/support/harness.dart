import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:docsbuddy/core/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'scenario.dart';
import 'stub_go_router.dart';

/// How a use case is laid out in the preview area.
enum Placement {
  /// Fills the preview: a whole screen that brings its own Scaffold.
  fill,

  /// Sits on the page background, padded and aligned, scrolling if it is taller
  /// than the screen: a single widget. It gets unbounded height, so widgets that
  /// need a bounded one (an `Expanded` column, a `ListView`) use [fill].
  inline,
}

/// Everything a use case needs to run like it does in the app, minus the app: a [ProviderScope] bound to a [Scenario]'s
/// fake backend (provider retries off, so a failure shows as an error), a stub go_router so `context.push/go/pop` work
/// without a route table, and its own [Navigator] so dialogs and pops stay inside the preview. A "screen closed" page sits
/// under the content, which also makes it look pushed (an AppBar gets a back arrow); root screens such as tabs pass
/// `root: true` to get none. Rebuilt whenever Widgetbook rebuilds the use case, so each configuration starts clean.
class Harness extends StatefulWidget {
  const Harness({
    super.key,
    required this.builder,
    this.scenario = Scenario.populated,
    this.options = const WorldOptions(),
    this.placement = Placement.fill,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.all(16),
    this.root = false,
  });

  /// Builds the content once the scenario's data has been seeded.
  final Widget Function(DemoRefs refs) builder;

  final Scenario scenario;
  final WorldOptions options;
  final Placement placement;
  final Alignment alignment;
  final EdgeInsets padding;

  /// The screen is the bottom of the app's navigation stack (a tab, the
  /// sign-in page), so nothing sits beneath it and it has no back button.
  final bool root;

  @override
  State<Harness> createState() => _HarnessState();
}

class _HarnessState extends State<Harness> {
  final _navigator = GlobalKey<NavigatorState>();
  late final StubGoRouter _router = StubGoRouter(
    onNavigate: _onNavigate,
    canPopNow: () => _navigator.currentState?.canPop() ?? false,
  );
  late final Future<World> _world = buildWorld(widget.scenario, options: widget.options);

  void _onNavigate(Navigation navigation) {
    final nav = _navigator.currentState;
    if (nav == null) return;
    switch (navigation.kind) {
      case NavKind.pop:
        nav.maybePop();
      case NavKind.replace:
        nav.pushReplacement(_placeholderRoute(navigation));
      case NavKind.push || NavKind.go:
        nav.push(_placeholderRoute(navigation));
    }
  }

  Route<void> _placeholderRoute(Navigation navigation) =>
      MaterialPageRoute<void>(builder: (_) => _NavigationPlaceholder(navigation: navigation));

  Route<void> _contentRoute(DemoRefs refs) => MaterialPageRoute<void>(
        builder: (_) => switch (widget.placement) {
          Placement.fill => widget.builder(refs),
          Placement.inline => Scaffold(
              body: SafeArea(
                // Centred when it fits, scrolls when it doesn't: a widget that is
                // taller than a small screen should scroll, as it would in the
                // app, not report an overflow caused by the preview.
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                      child: Align(
                        alignment: widget.alignment,
                        child: Padding(padding: widget.padding, child: widget.builder(refs)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        },
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<World>(
      future: _world,
      builder: (context, snapshot) {
        final world = snapshot.data;
        if (world == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ProviderScope(
          overrides: world.overrides,
          retry: (_, _) => null,
          child: InheritedGoRouter(
            goRouter: _router,
            child: ScaffoldMessenger(
              child: Navigator(
                key: _navigator,
                onGenerateInitialRoutes: (navigator, _) => [
                  if (!widget.root)
                    MaterialPageRoute<void>(
                      builder: (_) => _ScreenClosed(onReopen: () => navigator.push(_contentRoute(world.refs))),
                    ),
                  _contentRoute(world.refs),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// What a screen's `context.push('/asset/…')` lands on here.
class _NavigationPlaceholder extends StatelessWidget {
  const _NavigationPlaceholder({required this.navigation});

  final Navigation navigation;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final extra = navigation.extra;
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation (stub)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.alt_route_rounded, size: 36, color: palette.accent),
              const SizedBox(height: 16),
              Text('The app would ${navigation.kind.label}',
                  style: TextStyle(fontSize: 13, color: palette.textMuted)),
              const SizedBox(height: 8),
              SelectableText(navigation.location,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: palette.text)),
              if (extra != null) ...[
                const SizedBox(height: 6),
                Text('with ${extra.runtimeType}', style: TextStyle(fontSize: 12.5, color: palette.textMuted)),
              ],
              const SizedBox(height: 24),
              GhostButton(label: 'Back', onPressed: () => Navigator.of(context).maybePop()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Revealed when the content route pops itself (e.g. after "Save").
class _ScreenClosed extends StatelessWidget {
  const _ScreenClosed({required this.onReopen});

  final VoidCallback onReopen;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 36, color: palette.success),
              const SizedBox(height: 16),
              Text('This screen closed itself',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: palette.text)),
              const SizedBox(height: 6),
              Text('In the app you would be back on the previous screen.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: palette.textMuted)),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Reopen', onPressed: onReopen),
            ],
          ),
        ),
      ),
    );
  }
}
