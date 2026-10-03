import 'package:docsbuddy/core/l10n/rich_template.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

String _plain(List<InlineSpan> spans) => TextSpan(children: spans).toPlainText();

void main() {
  const bold = TextStyle(fontWeight: FontWeight.w800);

  test('puts each styled span where the translation says', () {
    final spans = richTemplate('I agree to the {terms} and {privacy}.', {
      'terms': const TextSpan(text: 'Terms', style: bold),
      'privacy': const TextSpan(text: 'Privacy', style: bold),
    });

    expect(_plain(spans), 'I agree to the Terms and Privacy.');
    expect(spans.whereType<TextSpan>().where((s) => s.style == bold), hasLength(2));
  });

  test('follows the translator’s word order, even reversed', () {
    final spans = richTemplate('{privacy} و {terms}', {
      'terms': const TextSpan(text: 'الشروط'),
      'privacy': const TextSpan(text: 'الخصوصية'),
    });

    expect(_plain(spans), 'الخصوصية و الشروط');
  });

  test('a sentence with no slots, or text after the last slot, survives intact', () {
    expect(_plain(richTemplate('Plain.', const {})), 'Plain.');
    expect(_plain(richTemplate('{n} unités restantes', {'n': const TextSpan(text: '3')})), '3 unités restantes');
  });

  test('braces that are not one of ours stay as text', () {
    expect(_plain(richTemplate('Hello {name}', const {})), 'Hello {name}');
  });
}
