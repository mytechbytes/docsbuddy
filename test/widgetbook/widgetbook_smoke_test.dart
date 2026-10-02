// Mounts every Widgetbook use case through the real Widgetbook route and fails
// on any exception or layout overflow, so the catalog can't quietly rot as the
// app changes.
//
//   flutter test test/widgetbook
//
// The default run uses Widgetbook's defaults (light, 1.0× text, iPhone 13) and
// must be clean. A second, opt-in pass renders every use case the hard way at
// once (dark theme, 2.0× text, the 320dp "compact" phone) and prints where the
// layout breaks, grouped by the widget responsible. It reports and never fails,
// because it is a worklist for the app, not a gate:
//
//   flutter test test/widgetbook --dart-define=WIDGETBOOK_STRESS=true --plain-name stress
import 'dart:io';

import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../widgetbook/app.dart';
import '../../widgetbook/config/devices.dart';
import '../../widgetbook/directories.dart';
import '../../widgetbook/support/harness.dart';

const _stress = bool.fromEnvironment('WIDGETBOOK_STRESS');

/// The route Widgetbook opens for [path] with the given addon settings.
String _route(String path, {Map<String, Map<String, String>> addons = const {}}) => Uri(
      path: '/',
      queryParameters: {
        'path': path,
        for (final e in addons.entries) e.key: FieldCodec.encodeQueryGroup(e.value),
      },
    ).toString();

const _brandImages = ['assets/icon/source_logo.png'];

/// Decodes the brand images into the image cache. Asset loading is real I/O, so
/// it never finishes under the test clock; without this a logo's width depends
/// on whether an earlier test happened to load it, and layouts differ run to run.
Future<void> _warmImages(WidgetTester tester) => tester.runAsync(() async {
      final context = tester.element(find.byType(MaterialApp).first);
      for (final path in _brandImages) {
        await precacheImage(AssetImage(path), context);
      }
    });

/// Lets the harness seed its fake backend and the screen's providers settle.
/// Not `pumpAndSettle`: loading states spin forever by design.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Where in `lib/` or `widgetbook/` a layout error was raised, from the
/// "relevant error-causing widget" line Flutter prints with it.
String _source(FlutterErrorDetails details) {
  final text = details.toString();
  final match = RegExp(r'file:///[^\s)]*?/((?:lib|widgetbook)/[^\s:)]+):(\d+)').firstMatch(text);
  return match == null ? 'unknown location' : '${match.group(1)}:${match.group(2)}';
}

String _summary(FlutterErrorDetails details) {
  final first = details.exceptionAsString().split('\n').first;
  return first.length > 90 ? '${first.substring(0, 90)}…' : first;
}

/// Mounts every use case. With [report] false any error fails that test; with
/// it true errors are collected into [findings] (use case → "source: message").
void _runAll(
  String groupName, {
  Map<String, Map<String, String>> addons = const {},
  bool report = false,
  Map<String, Set<String>>? findings,
}) {
  final useCases = WidgetbookRoot(children: buildDirectories()).leaves.whereType<WidgetbookUseCase>().toList();

  group(groupName, () {
    for (final useCase in useCases) {
      testWidgets(useCase.path, (tester) async {
        tester.view
          ..physicalSize = const Size(1600, 1000)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        // Described as they happen: once the tree is disposed Flutter can no
        // longer say which widget an error came from.
        final errors = <String>[];
        final previous = FlutterError.onError;
        if (report) FlutterError.onError = (details) => errors.add('${_source(details)}  ${_summary(details)}');
        try {
          await tester.pumpWidget(DocsBuddyWidgetbook(initialRoute: _route(useCase.path, addons: addons)));
          await _warmImages(tester);
          await _settle(tester);

          expect(find.byType(Harness), findsOneWidget, reason: 'the use case did not open');
          if (!report) expect(tester.takeException(), isNull);

          // Dispose the tree and flush timers so one case can't leak into the next.
          await tester.pumpWidget(const SizedBox());
          await tester.pump(const Duration(seconds: 1));
        } finally {
          FlutterError.onError = previous;
        }

        if (errors.isNotEmpty) (findings![useCase.path] ??= {}).addAll(errors);
      });
    }
  });
}

/// One entry per offending widget (its source line), worst first, with how far
/// it overflowed and which use cases it broke.
String _report(Map<String, Set<String>> findings) {
  final overflow = RegExp(r'overflowed by ([\d.]+) pixels on the (\w+)');
  final bySource = <String, ({Set<String> useCases, double worst, Set<String> edges, Set<String> other})>{};

  findings.forEach((useCase, items) {
    for (final item in items) {
      final source = item.split('  ').first;
      final entry = bySource[source] ??= (useCases: {}, worst: 0, edges: {}, other: {});
      entry.useCases.add(useCase);
      final m = overflow.firstMatch(item);
      if (m == null) {
        entry.other.add(item.substring(source.length).trim());
      } else {
        final px = double.parse(m.group(1)!);
        bySource[source] = (
          useCases: entry.useCases,
          worst: px > entry.worst ? px : entry.worst,
          edges: entry.edges..add(m.group(2)!),
          other: entry.other,
        );
      }
    }
  });

  final sorted = bySource.entries.toList()
    ..sort((a, b) => b.value.useCases.length.compareTo(a.value.useCases.length));
  final out = StringBuffer()
    ..writeln('Stress report: ${findings.length} use cases hit ${sorted.length} distinct widgets.')
    ..writeln('(dark theme, 2.0x text, 320dp phone; sorted by how many use cases a widget breaks)')
    ..writeln();
  for (final e in sorted) {
    final v = e.value;
    final what = [
      if (v.worst > 0) 'overflows up to ${v.worst.toStringAsFixed(0)}px (${v.edges.join(', ')})',
      ...v.other,
    ].join('; ');
    out.writeln('${v.useCases.length.toString().padLeft(3)}×  ${e.key}  $what');
    for (final useCase in (v.useCases.toList()..sort()).take(3)) {
      out.writeln('       $useCase');
    }
    if (v.useCases.length > 3) out.writeln('       … and ${v.useCases.length - 3} more');
  }
  return out.toString();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Without this, text is laid out in the test runner's placeholder font, whose
  // glyphs are all a full em wide, so every row looks like it overflows.
  setUpAll(() async {
    final font = FontLoader(AppTheme.fontFamily)
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'));
    await font.load();
  });

  test('every use case has its own path', () {
    final paths = WidgetbookRoot(children: buildDirectories())
        .leaves
        .whereType<WidgetbookUseCase>()
        .map((u) => u.path)
        .toList();
    final seen = <String>{};
    final duplicates = paths.where((p) => !seen.add(p)).toList();
    expect(duplicates, isEmpty, reason: 'Widgetbook shows only one use case per path');
    expect(paths, isNotEmpty);
  });

  _runAll('renders');

  if (_stress) {
    final findings = <String, Set<String>>{};
    _runAll(
      'stress: dark, 2.0x text, compact phone',
      report: true,
      findings: findings,
      addons: {
        'theme': {'name': 'Dark'},
        'text-scale': {'factor': '2.0'},
        'viewport': {'name': ScreenSizes.compactPhone.name},
      },
    );
    tearDownAll(() {
      final report = _report(findings);
      File('build/widgetbook_stress_report.txt')
        ..createSync(recursive: true)
        ..writeAsStringSync(report);
      // ignore: avoid_print
      print(report);
    });
  }
}
