import 'package:flutter/widgets.dart';

final _slot = RegExp(r'\{(\w+)\}');

/// Renders a translated sentence with styled pieces (a link, a bold name) without the code fixing their position.
/// Ask the generated message for its placeholders as themselves (`l10n.authTermsAgreement('{terms}', '{privacy}')`)
/// and pass the spans to drop in, so the translation controls word order.
List<InlineSpan> richTemplate(String template, Map<String, InlineSpan> slots) {
  final spans = <InlineSpan>[];
  var cursor = 0;
  for (final match in _slot.allMatches(template)) {
    final slot = slots[match.group(1)];
    if (slot == null) continue; // not ours: leave the braces as plain text
    if (match.start > cursor) spans.add(TextSpan(text: template.substring(cursor, match.start)));
    spans.add(slot);
    cursor = match.end;
  }
  if (cursor < template.length) spans.add(TextSpan(text: template.substring(cursor)));
  return spans;
}
