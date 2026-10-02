// Mounts every Widgetbook use case through the real Widgetbook route and fails
// on any exception or layout overflow, so the catalog can't quietly rot as the
// app changes.
//
//   flutter test test/widgetbook
//
// The default run uses Widgetbook's defaults (light, 1.0× text, iPhone 13) and
// must be clean. A second, opt-in pass renders every use case the hard way at
// once (dark theme, large text, the 320dp "compact" phone, tall enough to build
// a whole scrolling page: what someone who raised their system font size sees) and must be clean too. When it isn't, it
// prints where the layout breaks, grouped by the widget responsible, and writes
// the same list to build/widgetbook_stress_report.txt:
//
//   flutter test test/widgetbook --dart-define=WIDGETBOOK_STRESS=true --plain-name stress
//
// The text scale defaults to 2.0 (Android's largest). iOS accessibility sizes
// go further; try them with --dart-define=WIDGETBOOK_STRESS_SCALE=3.0.
import 'dart:io';

import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../widgetbook/app.dart';
import '../../widgetbook/config/devices.dart';
import '../../widgetbook/directories.dart';
import '../../widgetbook/support/harness.dart';

const _stress = bool.fromEnvironment('WIDGETBOOK_STRESS');
const _stressScale = String.fromEnvironment('WIDGETBOOK_STRESS_SCALE', defaultValue: '2.0');

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

/// Text that large type has made hard to read, though nothing overflowed: a
/// word broken across lines ("informati / on"), or lines cut off by a box that
/// didn't grow with them. Looks only inside [root], the use case itself.
List<String> _unreadable(Element root) {
  final found = <String>[];

  // Tokens that can't be wrapped nicely whatever the width: addresses, paths,
  // colour codes, identifiers. Breaking one of these is not a layout fault.
  bool unbreakable(String token) =>
      token.contains(RegExp(r'[@/:.#]')) ||
      token.length >= 15 ||
      (token.length >= 8 && token.contains(RegExp(r'\d'))) ||
      token.contains(RegExp(r'[a-z][A-Z]'));

  final wordChar = RegExp(r'[\p{L}\p{N}]', unicode: true);
  final space = RegExp(r'\s');

  void check(RenderParagraph paragraph) {
    final text = paragraph.text.toPlainText();
    if (text.trim().isEmpty || !paragraph.hasSize) return;
    final snippet = text.length > 40 ? '${text.substring(0, 40)}…' : text;

    // Where each character sits; a drop in the top edge is a new line.
    double? lastTop;
    var reported = false;
    for (var i = 0; i < text.length && !reported; i++) {
      final boxes = paragraph.getBoxesForSelection(TextSelection(baseOffset: i, extentOffset: i + 1));
      if (boxes.isEmpty) continue;
      final box = boxes.first;
      if (lastTop != null && box.top > lastTop + 1 && i > 0) {
        // 1. The line broke between text[i - 1] and text[i]; inside a word?
        if (wordChar.hasMatch(text[i - 1]) && wordChar.hasMatch(text[i])) {
          var from = i;
          while (from > 0 && !space.hasMatch(text[from - 1])) {
            from--;
          }
          var to = i;
          while (to < text.length && !space.hasMatch(text[to])) {
            to++;
          }
          final word = text.substring(from, to);
          if (!unbreakable(word)) {
            found.add('"$snippet"  word "$word" broken across lines');
            reported = true;
          }
        }
      }
      lastTop = box.top;
    }

    // 2. A box given less height than its text needs (cut off silently, with no
    // overflow error): the paragraph is smaller than it would be unconstrained.
    if (!reported && paragraph.maxLines == null) {
      final needed = paragraph.getMaxIntrinsicHeight(paragraph.size.width);
      if (needed > paragraph.size.height + 1) found.add('"$snippet"  text cut off by its box');
    }
  }

  void visit(RenderObject node) {
    // Decorative art is excluded from semantics and from this check.
    if (node is RenderExcludeSemantics && node.excluding) return;
    if (node is RenderParagraph) check(node);
    node.visitChildren(visit);
  }

  root.findRenderObject()?.visitChildren(visit);
  return found;
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
          if (report) errors.addAll(_unreadable(tester.element(find.byType(Harness))));

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
    ..writeln('(dark theme, ${_stressScale}x text, 320dp phone, whole page; sorted by how many use cases a widget breaks)')
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
      'stress: dark, ${_stressScale}x text, compact phone, whole page',
      report: true,
      findings: findings,
      addons: {
        'theme': {'name': 'Dark'},
        'text-scale': {'factor': _stressScale},
        'viewport': {'name': ScreenSizes.compactWholePage.name},
      },
    );
    // Last in the file, so it runs after every use case has been mounted.
    test('stress: no layout errors', () {
      final report = _report(findings);
      File('build/widgetbook_stress_report.txt')
        ..createSync(recursive: true)
        ..writeAsStringSync(report);
      expect(findings, isEmpty, reason: report);
    });
  }
}
