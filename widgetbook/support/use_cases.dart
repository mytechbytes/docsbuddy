// Small constructors that keep the catalog files declarative: say what to show
// and in which state; the harness supplies the rest.
import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'harness.dart';
import 'scenario.dart';

/// A single widget, centred on the page background in its own harness. [builder] runs inside Widgetbook's own build
/// (so `context.knobs` works); wrap in a [Builder] if the widget needs a context from inside the harness.
WidgetbookUseCase component(
  String name,
  Widget Function(BuildContext context) builder, {
  Alignment alignment = Alignment.center,
  EdgeInsets padding = const EdgeInsets.all(16),
  Scenario scenario = Scenario.populated,
  WorldOptions options = const WorldOptions(),
}) =>
    WidgetbookUseCase(
      name: name,
      builder: (context) {
        final child = builder(context);
        return Harness(
          scenario: scenario,
          options: options,
          placement: Placement.inline,
          alignment: alignment,
          padding: padding,
          builder: (_) => child,
        );
      },
    );

/// A widget that fills the preview itself (a list, a sheet, an empty state).
WidgetbookUseCase filling(
  String name,
  Widget Function(BuildContext context) builder, {
  Scenario scenario = Scenario.populated,
  WorldOptions options = const WorldOptions(),
}) =>
    WidgetbookUseCase(
      name: name,
      builder: (context) {
        final child = builder(context);
        return Harness(scenario: scenario, options: options, builder: (_) => Scaffold(body: SafeArea(child: child)));
      },
    );

/// A full screen, built once the scenario's data exists so it can be pointed at a seeded asset or room via [DemoRefs].
/// A [root] screen (a tab, the sign-in page) has no back button; any other is shown pushed, as in the app.
WidgetbookUseCase screen(
  String name,
  Widget Function(DemoRefs refs) builder, {
  Scenario scenario = Scenario.populated,
  WorldOptions options = const WorldOptions(),
  bool root = false,
}) =>
    WidgetbookUseCase(
      name: name,
      builder: (_) => Harness(scenario: scenario, options: options, root: root, builder: builder),
    );

/// One screen in each of [scenarios], as separate use cases named after them.
List<WidgetbookUseCase> screenStates(
  Widget Function(DemoRefs refs) builder, {
  List<Scenario> scenarios = Scenario.values,
  WorldOptions options = const WorldOptions(),
  bool root = false,
}) =>
    [for (final s in scenarios) screen(s.label, builder, scenario: s, options: options, root: root)];

/// Every variant of a widget stacked and labelled, scrollable: the "all states
/// at a glance" view that sits next to a knob-driven playground.
WidgetbookUseCase gallery(String name, List<Widget> children, {Scenario scenario = Scenario.populated}) =>
    WidgetbookUseCase(
      name: name,
      builder: (_) => Harness(
        scenario: scenario,
        builder: (_) => Scaffold(
          body: SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: children.length,
              separatorBuilder: (_, _) => const SizedBox(height: 20),
              itemBuilder: (_, i) => children[i],
            ),
          ),
        ),
      ),
    );

/// A caption above one variant in a [gallery].
class Labeled extends StatelessWidget {
  const Labeled(this.label, this.child, {super.key});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: context.palette.textMuted)),
        ),
        child,
      ],
    );
  }
}

/// A bottom-sheet's worth of content drawn the way the app presents it: on the
/// surface colour with rounded top corners, pinned to the bottom of the preview.
class SheetFrame extends StatelessWidget {
  const SheetFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: context.palette.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

/// Holds one piece of state for a demo, so a selectable widget can be tapped
/// in the catalog and visibly change, with no state class per use case.
class Interactive<T> extends StatefulWidget {
  const Interactive({super.key, required this.initial, required this.builder});

  final T initial;
  final Widget Function(BuildContext context, T value, ValueChanged<T> set) builder;

  @override
  State<Interactive<T>> createState() => _InteractiveState<T>();
}

class _InteractiveState<T> extends State<Interactive<T>> {
  late T _value = widget.initial;

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _value, (next) => setState(() => _value = next));
}
